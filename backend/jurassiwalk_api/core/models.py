from django.contrib.gis.db import models


"""
Note:
srid=3857 for all models, consistent with web mercator
Thus, all units are meters, where relevant (i.e. geom)
"""

class PedestrianWay(models.Model):
    way_id = models.BigIntegerField(primary_key=True)
    name = models.TextField(blank=True, null=True)
    highway = models.TextField(blank=True, null=True)
    lit = models.TextField(blank=True, null=True)
    sidewalk = models.TextField(blank=True, null=True)
    surface = models.TextField(blank=True, null=True)
    geom = models.LineStringField(srid=3857, blank=True, null=True)
    daytime_safety_score = models.FloatField(blank=True, null=True)
    nighttime_safety_score = models.FloatField(blank=True, null=True)
    reasons = models.JSONField(blank=True, null=True)
    source = models.BigIntegerField(blank=True, null=True)
    target = models.BigIntegerField(blank=True, null=True)

    class Meta:
        db_table = 'safety_osm_lines'

class SafetyPoint(models.Model):
    node_id = models.BigIntegerField(primary_key=True)
    name = models.TextField(blank=True, null=True)
    amenity = models.TextField(blank=True, null=True)
    shop = models.TextField(blank=True, null=True)
    highway = models.TextField(blank=True, null=True)
    opening_hours = models.TextField(blank=True, null=True)
    geom = models.PointField(srid=3857, blank=True, null=True)

    class Meta:
        db_table = 'safety_osm_points'

class SafetyArea(models.Model):
    way_id = models.BigIntegerField(primary_key=True)
    name = models.TextField(blank=True, null=True)
    amenity = models.TextField(blank=True, null=True)
    shop = models.TextField(blank=True, null=True)
    landuse = models.TextField(blank=True, null=True)
    opening_hours = models.TextField(blank=True, null=True)
    geom = models.PolygonField(srid=3857, blank=True, null=True)

    class Meta:
        db_table = 'safety_osm_polygons'


# bike storage racks model - stores all the bike racks people can lock up at
class BikeRack(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.TextField()  # like "Main Entrance Racks" or whatever
    latitude = models.FloatField()
    longitude = models.FloatField()
    capacity = models.IntegerField()  # how many bikes can fit
    available = models.IntegerField(default=0)  # how many spots are free right now
    type = models.TextField(blank=True, null=True)  # covered, uncovered, locker etc
    covered = models.BooleanField(default=False)  # is it covered or not
    accessibility = models.TextField(blank=True, null=True)  # accessibility info if any
    is_available = models.BooleanField(default=True)  # is the rack itself available (might be broken or removed)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    # geom field using postgis point for spatial queries later maybe
    geom = models.PointField(srid=4326, blank=True, null=True)
    
    class Meta:
        db_table = 'bike_racks'
        indexes = [
            models.Index(fields=['latitude', 'longitude']),  # for nearby queries
        ]

    def __str__(self):
        return f"{self.name} ({self.available}/{self.capacity})"


# bike share stations - capital bikeshare or similar
class BikeShare(models.Model):
    id = models.AutoField(primary_key=True)
    station_name = models.TextField()
    latitude = models.FloatField()
    longitude = models.FloatField()
    available_bikes = models.IntegerField(default=0)
    available_docks = models.IntegerField(default=0)
    total_docks = models.IntegerField()  # bikes + docks should = total
    is_active = models.BooleanField(default=True)
    provider = models.TextField(blank=True, null=True)  # capital bikeshare, lime, etc
    last_updated = models.DateTimeField(auto_now=True)
    geom = models.PointField(srid=4326, blank=True, null=True)
    
    class Meta:
        db_table = 'bike_share_stations'
        indexes = [
            models.Index(fields=['latitude', 'longitude']),
        ]

    def __str__(self):
        return f"{self.station_name} - {self.available_bikes} bikes"