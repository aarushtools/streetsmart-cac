import 'package:latlong2/latlong.dart';
import 'package:streetsmart/data/models/bike_model.dart';
import 'package:streetsmart/data/demo/demo_data.dart';

class BikeRackService {
  static Future<List<BikeRack>> getBikeRacks({
    double? latitude,
    double? longitude,
    double radiusKm = 5.0,
  }) async {
    final queryParams = <String, dynamic>{};
    if (latitude != null && longitude != null) {
      queryParams['latitude'] = latitude.toString();
      queryParams['longitude'] = longitude.toString();
      queryParams['radius_km'] = radiusKm.toString();
    }
    
    // final url = ApiEndpoints.buildUrl(ApiEndpoints.bikeRacks, queryParams);
    // final response = await http.get(Uri.parse(url));
    final racks = <BikeRack>[];
    for (final rackData in DemoData.bikeRacks) {
      final loc = rackData['location'] as LatLng;
      racks.add(BikeRack(
        id: rackData['id'].toString(),
        name: rackData['name'] as String,
        latitude: loc.latitude,
        longitude: loc.longitude,
        capacity: rackData['capacity'] as int,
        type: rackData['covered'] == true ? 'covered' : 'uncovered',
        isAvailable: true,
      ));
    }
    
    return racks;
  }

  static Future<BikeRack> addBikeRack({
    required String name,
    required double latitude,
    required double longitude,
    required int capacity,
    String? type,
    bool covered = false,
    String? accessibility,
  }) async {
    // final url = ApiEndpoints.baseUrl + ApiEndpoints.bikeRacks;
    // final payload = {
    //   'name': name,
    //   'latitude': latitude,
    //   'longitude': longitude,
    //   'capacity': capacity,
    //   if (type != null) 'type': type,
    //   'covered': covered,
    //   if (accessibility != null) 'accessibility': accessibility,
    // };
    // final response = await http.post(Uri.parse(url), body: jsonEncode(payload));
    
    return BikeRack(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      latitude: latitude,
      longitude: longitude,
      capacity: capacity,
      type: type,
      isAvailable: true,
    );
  }

  static Future<bool> removeBikeRack(String rackId) async {
    // final url = '${ApiEndpoints.baseUrl}${ApiEndpoints.bikeRacks}/$rackId';
    // await http.delete(Uri.parse(url));
    return true;
  }
}


class BikeShareService {
  static Future<List<BikeShare>> getBikeShareStations({
    double? latitude,
    double? longitude,
    double radiusKm = 5.0,
  }) async {
    // final url = ApiEndpoints.buildUrl(ApiEndpoints.bikeShares, {
    //   if (latitude != null) 'latitude': latitude.toString(),
    //   if (longitude != null) 'longitude': longitude.toString(),
    // });
    // final response = await http.get(Uri.parse(url));
    
    final stations = <BikeShare>[];
    for (final s in DemoData.bikeShareStations) {
      final loc = s['location'] as LatLng;
      final bikes = s['bikesAvailable'] as int;
      final docks = s['docksAvailable'] as int;
      stations.add(BikeShare(
        id: s['id'].toString(),
        stationName: s['name'] as String,
        latitude: loc.latitude,
        longitude: loc.longitude,
        availableBikes: bikes,
        availableDocks: docks,
        totalDocks: bikes + docks,
        isActive: true,
        provider: 'Capital Bikeshare',
      ));
    }
    
    return stations;
  }
}
