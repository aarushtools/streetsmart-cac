from ninja import NinjaAPI, Schema
from core.models import PedestrianWay, SafetyArea, SafetyPoint, BikeRack, BikeShare
from django.contrib.gis.measure import D
from opening_hours import OpeningHours
from math import exp
import math
from django.contrib.gis.db.models.functions import Distance
from django.contrib.gis.geos import Point, LineString
from django.db import connection
from collections import Counter
from datetime import datetime
from functools import lru_cache
import json


api = NinjaAPI(title="StreetSmart API", description="Provide endpoints for safety data for StreetSmart on Flutter")

SETTINGS = {
    "safety_area_inclusve_distance": 30,
    "safety_point_inclusive_distance": 30,
}


@api.get("/hello")
def hello(request, name: str):
    return {"message": f"Hello, {name}!"}

@api.get("/get_routes/{starting_latitude}/{starting_longitude}/{ending_latitude}/{ending_longitude}/{num_routes}/{srid}")
def get_routes_endpoint(request, starting_latitude: float, starting_longitude: float, ending_latitude: float, ending_longitude: float, num_routes: int, srid: int):
    starting_point = Point(starting_longitude, starting_latitude, srid=srid)
    ending_point = Point(ending_longitude, ending_latitude, srid=srid)
    starting_point.transform(srid=3857)
    ending_point.transform(srid=3857)

    result = get_routes(starting_point, ending_point, num_routes, 7 < datetime.now().hour < 22)
    return json.dumps(result)

def get_routes(start_point, end_point, k, is_daytime: bool):
    with connection.cursor() as cursor:
        # Find nearest source and target nodes
        cursor.execute("""
            SELECT id FROM safety_osm_lines_vertices_pgr
            ORDER BY the_geom <-> ST_GeomFromText(%s, 3857)
            LIMIT 1;
        """, [start_point.wkt])
        start_vid = cursor.fetchone()[0]

        cursor.execute("""
            SELECT id FROM safety_osm_lines_vertices_pgr
            ORDER BY the_geom <-> ST_GeomFromText(%s, 3857)
            LIMIT 1;
        """, [end_point.wkt])
        end_vid = cursor.fetchone()[0]

        # Run K Shortest Paths
        cursor.execute(f"""
            SELECT ksp.route_id, w.way_id, w.geom, w.reasons, w.{"daytime_safety_score" if is_daytime else "nighttime_safety_score"}
            FROM pgr_ksp(
                "SELECT way_id AS id, source, target,
                        (1.0 / (0.5 + {f"daytime_safety_score" if is_daytime else "nighttime_safety_score"})) AS cost,
                        (1.0 / (0.5 + {f"daytime_safety_score" if is_daytime else "nighttime_safety_score"})) AS reverse_cost
                 FROM safety_osm_lines",
                %s, %s, %s, directed := false
            ) AS ksp
            JOIN safety_osm_lines w ON ksp.edge = w.way_id;
        """, [start_vid, end_vid, k])

        routes = {}
        global_reasons_counter = Counter()
        for route_id, way_id, geom, reasons_json, safety in cursor.fetchall():
            routes.setdefault(route_id, {"segments": [], "avg_safety": 0})
            routes[route_id]["segments"].append(LineString(geom))
            routes[route_id]["avg_safety"] += safety

            selected_reasons = (reasons_json or {}).get("daytime" if is_daytime else "nighttime", {})
            if isinstance(selected_reasons, dict):
                global_reasons_counter.update(selected_reasons)

        for rid in routes:
            routes[rid]["avg_safety"] /= len(routes[rid]["segments"])

        ordered_reasons = sorted(global_reasons_counter.items(), key=lambda x: x[1], reverse=True)
        return {
            "routes": sorted(
                (
                    {"route_id": rid, **data}
                    for rid, data in routes.items()
                ),
                key=lambda x: x["avg_safety"],
                reverse=True,
            ),
            "reasons": [
                {"reason": reason, "count": count}
                for reason, count in ordered_reasons
            ],
        }

def add_occurrence(dictionary, reason):
    dictionary[reason] = dictionary.get(reason, 0) + 1

@lru_cache(maxsize=10000)
def _opening_hours_state_cached(opening_hours_str: str, hour_cache_key: str) -> float | None:
    try:
        return 1.0 if "open" in OpeningHours(opening_hours_str).state() else 0.4
    except Exception:
        return None


def calculate_safety_score(pedestrian_way: PedestrianWay, is_daytime: bool):
    road_geom = pedestrian_way.geom
    reasons = {}

    safety_score = 0

    lighting_subscore = 0.0
    if pedestrian_way.lit == "yes":
        lighting_subscore = 1.0
    elif pedestrian_way.lit == "limited":
        lighting_subscore = 0.6
        if not is_daytime:
            add_occurrence(reasons, "Limited street lighting")
    else:  # no or null
        lighting_subscore = 0.3
        if not is_daytime:
            add_occurrence(reasons, "No street lighting")

    # convex blend
    lighting_score = (1 - (not is_daytime))*0.7 + (not is_daytime)*lighting_subscore

    surface_score = 0.0
    surface = (pedestrian_way.surface or "").lower()
    if surface in ("asphalt", "concrete", "paved"):
        surface_score = 1.0
    elif surface in ("compacted", "sett", "paving_stones"):
        surface_score = 0.75
        add_occurrence(reasons, "The pedestrian walkway's surface is primarily made of compacted, sett, or paving stones, instead of asphalt, concrete, or pavement")
    elif surface == "gravel":
        surface_score = 0.60
        add_occurrence(reasons, "The pedestrian walkway's surface is primarily made of gravel, instead of asphalt, concrete, or pavement")
    elif surface in ("dirt", "sand", "grass"):
        surface_score = 0.40
        add_occurrence(reasons, "The pedestrian walkway's surface is primarily made of dirt, sand, or grass, instead of asphalt, concrete, or pavement")
    else:
        surface_score = 0.50

    sidewalk_score = 0.0
    sidewalk = (pedestrian_way.sidewalk or "").lower()
    if sidewalk == "both":
        sidewalk_score = 1.0
    elif sidewalk in ("left", "right"):
        sidewalk_score = 0.80
    elif sidewalk == "no":
        sidewalk_score = 0.30
        add_occurrence(reasons, "Limited or no sidewalks available on the streets")
    else:
        sidewalk_score = 0.60

    motor_interaction_score = 0.0
    highway = (pedestrian_way.highway or "").lower()
    if highway in ("footway", "pedestrian", "path", "sidewalk"):
        motor_interaction_score = 1.0
    elif highway == "living_street":
        motor_interaction_score = 0.75
    elif highway in ("residential", "service"):
        motor_interaction_score = 0.55
        add_occurrence(reasons, "The walkway has high car traffic")
    else:
        motor_interaction_score = 0.60

    safety_score = 0.35*lighting_score + 0.25*surface_score + 0.25*sidewalk_score + 0.15*motor_interaction_score

    # Now let's do safety area/points

    nearby_safety_areas = (
        SafetyArea.objects
        .filter(geom__distance_lte=(road_geom, D(m=SETTINGS["safety_area_inclusve_distance"])))
        .annotate(distance=Distance("geom", road_geom))
        .values("landuse", "amenity", "shop", "distance", "opening_hours")
    )
    nearby_safety_points = (
        SafetyPoint.objects
        .filter(geom__distance_lte=(road_geom, D(m=SETTINGS["safety_point_inclusive_distance"])))
        .annotate(distance=Distance("geom", road_geom))
        .values("amenity", "shop", "highway", "distance", "opening_hours")
    )


    safety_point_scores_list = []
    now = datetime.now()
    hour_key = now.strftime('%Y%m%d%H')
    exp_local = exp
    add_reason = add_occurrence

    for point in nearby_safety_points:
        is_open = 0.7  # default unknown
        point_influence = 0.0

        oh = point.get("opening_hours")
        if oh:
            cached = _opening_hours_state_cached(oh, hour_key)
            if cached is not None:
                is_open = cached

        amenity = (point.get("amenity") or "").lower()
        highway_local = (point.get("highway") or "").lower()
        dist_m = point["distance"].m

        if amenity == "street_lamp":
            time_of_day_multiplier = 1.4 if not is_daytime else 1.0
            point_influence = 0.9 * time_of_day_multiplier * is_open * exp_local(-dist_m / 15)

        elif highway_local == "bus_stop":
            time_of_day_multiplier = 1.1 if not is_daytime else 1.0
            point_influence = 0.9 * time_of_day_multiplier * is_open * exp_local(-dist_m / 20)

        elif point.get("shop") is not None or amenity in ["cafe", "restaurant", "bar", "fast_food"]:
            point_influence = 0.55 * is_open * exp_local(-dist_m / 18)

        elif amenity in ["police", "hospital", "school", "university"]:
            point_influence = 0.7 * is_open * exp_local(-dist_m / 25)

        else:
            point_influence = 0.3 * is_open * exp_local(-dist_m / 15)
            if not amenity:
                add_reason(reasons, "No information or low information available about amenity on OSM")
            if not is_open:
                add_reason(reasons, "Amenities are not open at this time")

        safety_point_scores_list.append(point_influence)

    total_raw_points = sum(safety_point_scores_list)
    points_score = 1 - exp(-total_raw_points)  # diminishing returns i.e. 100 street lamps have less of an effect cumulatively

    safety_area_scores_list = []
    for area in nearby_safety_areas:
        # Base weight depends on landuse / amenity / shop
        landuse = (area.get("landuse") or "").lower()
        amenity = (area.get("amenity") or "").lower()
        shop = (area.get("shop") or "").lower()
        area_influence = 0.0

        # Default multipliers
        time_of_day_multiplier = 1.0
        is_open = 1.0  # assume always open unless otherwise stated
        oh_area = area.get("opening_hours")
        if oh_area:
            cached = _opening_hours_state_cached(oh_area, hour_key)
            if cached is not None:
                is_open = cached

        # landuse-based weighting
        if landuse in ["commercial", "retail", "mixed_use"]:
            base_weight = 0.7
            radius = 25
        elif landuse == "residential":
            base_weight = 0.55
            radius = 22
        elif landuse == "industrial":
            base_weight = 0.3
            radius = 18
            if not is_daytime:
                time_of_day_multiplier = 0.8  # quieter and darker at night
                add_occurrence(reasons, "Path goes through industrial areas, and it's nighttime")
        elif landuse in ["park", "recreation_ground", "forest"]:
            base_weight = 0.55 if is_daytime else 0.35
            if not is_daytime:
                add_occurrence(reasons, "Path goes through the park, recreational grounds, or forest, and it's night")
            radius = 20
        else:
            base_weight = 0.4
            radius = 20

        # amenity/shop inside area adds bonuses
        if amenity in ["school", "university", "hospital", "police"]:
            base_weight += 0.2
        if shop:
            base_weight += 0.1

        # clamp weight to [0, 1]
        base_weight = min(base_weight, 1.0)

        # final influence (distance decay)
        dist_m = area["distance"].m
        area_influence = base_weight * time_of_day_multiplier * is_open * exp_local(-dist_m / radius)
        safety_area_scores_list.append(area_influence)

    total_raw_areas = sum(safety_area_scores_list)
    areas_score = 1 - exp(-total_raw_areas)

    final_score = (0.5 * safety_score) + (0.3 * points_score) + (0.2 * areas_score)
    return round(final_score * 1000, 2), reasons


# bike rack endpoints
@api.get("/bike-racks")
def get_bike_racks(request, latitude: float = None, longitude: float = None, radius_km: float = 5.0):
    """
    get all bike racks, optionally filtered by location
    radius is in km, defaults to 5km if lat/lon provided
    """
    racks = BikeRack.objects.filter(is_available=True)
    
    # if location provided, filter by distance
    # TODO: could use postgis distance queries but this works for now
    if latitude is not None and longitude is not None:
        # simple bounding box filter first to speed things up
        lat_delta = radius_km / 111.0  # roughly 1 degree lat = 111km
        lon_delta = radius_km / (111.0 * abs(latitude / 90.0))
        
        racks = racks.filter(
            latitude__gte=latitude - lat_delta,
            latitude__lte=latitude + lat_delta,
            longitude__gte=longitude - lon_delta,
            longitude__lte=longitude + lon_delta
        )
    
    results = []
    for rack in racks:
        # calculate actual distance if lat/lon provided
        distance_mi = None
        if latitude is not None and longitude is not None:
            # haversine distance calc - close enough for our purposes
            lat1_rad = math.radians(latitude)
            lat2_rad = math.radians(rack.latitude)
            dlat = math.radians(rack.latitude - latitude)
            dlon = math.radians(rack.longitude - longitude)
            a = math.sin(dlat/2)**2 + math.cos(lat1_rad) * math.cos(lat2_rad) * math.sin(dlon/2)**2
            c = 2 * math.asin(math.sqrt(a))
            distance_km = 6371 * c  # earth radius in km
            distance_mi = round(distance_km * 0.621371, 2)
            if distance_mi > radius_km * 0.621371:
                continue  # skip if outside radius
        
        results.append({
            "id": rack.id,
            "name": rack.name,
            "latitude": rack.latitude,
            "longitude": rack.longitude,
            "capacity": rack.capacity,
            "available": rack.available,
            "type": rack.type,
            "covered": rack.covered,
            "accessibility": rack.accessibility,
            "is_available": rack.is_available,
            "distance": f"{distance_mi} mi" if distance_mi is not None else None,
        })
    
    # sort by distance if we have location
    if latitude is not None and longitude is not None:
        results.sort(key=lambda x: float(x["distance"].split()[0]) if x["distance"] else 999)
    
    return {"bike_racks": results}


@api.post("/bike-racks")
def add_bike_rack(request, payload: dict):
    """
    add a new bike rack to the database
    expects: name, latitude, longitude, capacity, type (optional), covered (optional), accessibility (optional)
    """
    try:
        name = payload.get("name")
        lat = payload.get("latitude")
        lon = payload.get("longitude")
        capacity = payload.get("capacity")
        
        if not all([name, lat, lon, capacity]):
            return {"error": "missing required fields: name, latitude, longitude, capacity"}
        
        # create the point geom if we have lat/lon
        geom = None
        if lat and lon:
            geom = Point(float(lon), float(lat), srid=4326)
        
        rack = BikeRack.objects.create(
            name=name,
            latitude=float(lat),
            longitude=float(lon),
            capacity=int(capacity),
            available=int(payload.get("available", 0)),
            type=payload.get("type"),
            covered=payload.get("covered", False),
            accessibility=payload.get("accessibility"),
            geom=geom
        )
        
        return {
            "id": rack.id,
            "name": rack.name,
            "latitude": rack.latitude,
            "longitude": rack.longitude,
            "capacity": rack.capacity,
            "available": rack.available,
            "message": "bike rack added successfully"
        }
    except Exception as e:
        return {"error": f"failed to add bike rack: {str(e)}"}


@api.delete("/bike-racks/{rack_id}")
def remove_bike_rack(request, rack_id: int):
    """
    remove a bike rack - actually just marks it as unavailable instead of deleting
    dont want to lose the data in case we need it later
    """
    try:
        rack = BikeRack.objects.get(id=rack_id)
        rack.is_available = False
        rack.save()
        return {"message": f"bike rack {rack_id} marked as unavailable", "id": rack_id}
    except BikeRack.DoesNotExist:
        return {"error": f"bike rack {rack_id} not found"}
    except Exception as e:
        return {"error": f"failed to remove bike rack: {str(e)}"}


# bike share endpoints
@api.get("/bike-shares")
def get_bike_shares(request, latitude: float = None, longitude: float = None, radius_km: float = 5.0):
    """
    get all bike share stations, optionally filtered by location
    same logic as bike racks basically
    """
    stations = BikeShare.objects.filter(is_active=True)
    
    if latitude is not None and longitude is not None:
        lat_delta = radius_km / 111.0
        lon_delta = radius_km / (111.0 * abs(latitude / 90.0))
        
        stations = stations.filter(
            latitude__gte=latitude - lat_delta,
            latitude__lte=latitude + lat_delta,
            longitude__gte=longitude - lon_delta,
            longitude__lte=longitude + lon_delta
        )
    
    results = []
    for station in stations:
        distance_mi = None
        if latitude is not None and longitude is not None:
            lat1_rad = math.radians(latitude)
            lat2_rad = math.radians(station.latitude)
            dlat = math.radians(station.latitude - latitude)
            dlon = math.radians(station.longitude - longitude)
            a = math.sin(dlat/2)**2 + math.cos(lat1_rad) * math.cos(lat2_rad) * math.sin(dlon/2)**2
            c = 2 * math.asin(math.sqrt(a))
            distance_km = 6371 * c
            distance_mi = round(distance_km * 0.621371, 2)
            if distance_mi > radius_km * 0.621371:
                continue
        
        results.append({
            "id": station.id,
            "name": station.station_name,
            "latitude": station.latitude,
            "longitude": station.longitude,
            "bikesAvailable": station.available_bikes,
            "docksAvailable": station.available_docks,
            "totalDocks": station.total_docks,
            "provider": station.provider,
            "distance": f"{distance_mi} mi" if distance_mi is not None else None,
        })
    
    if latitude is not None and longitude is not None:
        results.sort(key=lambda x: float(x["distance"].split()[0]) if x["distance"] else 999)
    
    return {"bike_share_stations": results}