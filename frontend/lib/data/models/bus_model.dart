class BusRoute {
  final String id;
  final String routeNumber;
  final String routeName;
  final String? description;
  final String? agency; // FCPS, WMATA, etc.

  BusRoute({
    required this.id,
    required this.routeNumber,
    required this.routeName,
    this.description,
    this.agency,
  });

  factory BusRoute.fromJson(Map<String, dynamic> json) {
    return BusRoute(
      id: json['id'].toString(),
      routeNumber: json['route_number'] ?? '',
      routeName: json['route_name'] ?? 'Bus Route',
      description: json['description'],
      agency: json['agency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'route_number': routeNumber,
      'route_name': routeName,
      'description': description,
      'agency': agency,
    };
  }
}

class BusStop {
  final String id;
  final String stopName;
  final double latitude;
  final double longitude;
  final List<String> routeIds;
  final String? stopCode;

  BusStop({
    required this.id,
    required this.stopName,
    required this.latitude,
    required this.longitude,
    required this.routeIds,
    this.stopCode,
  });

  factory BusStop.fromJson(Map<String, dynamic> json) {
    return BusStop(
      id: json['id'].toString(),
      stopName: json['stop_name'] ?? 'Bus Stop',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      routeIds: (json['route_ids'] as List<dynamic>?)
              ?.map((id) => id.toString())
              .toList() ??
          [],
      stopCode: json['stop_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stop_name': stopName,
      'latitude': latitude,
      'longitude': longitude,
      'route_ids': routeIds,
      'stop_code': stopCode,
    };
  }
}

class BusArrival {
  final String routeId;
  final String routeNumber;
  final String routeName;
  final String stopId;
  final String stopName;
  final int minutesUntilArrival;
  final DateTime estimatedArrival;
  final String? vehicleId;

  BusArrival({
    required this.routeId,
    required this.routeNumber,
    required this.routeName,
    required this.stopId,
    required this.stopName,
    required this.minutesUntilArrival,
    required this.estimatedArrival,
    this.vehicleId,
  });

  factory BusArrival.fromJson(Map<String, dynamic> json) {
    return BusArrival(
      routeId: json['route_id'].toString(),
      routeNumber: json['route_number'] ?? '',
      routeName: json['route_name'] ?? 'Bus',
      stopId: json['stop_id'].toString(),
      stopName: json['stop_name'] ?? 'Bus Stop',
      minutesUntilArrival: json['minutes_until_arrival'] ?? 0,
      estimatedArrival: json['estimated_arrival'] != null
          ? DateTime.parse(json['estimated_arrival'])
          : DateTime.now(),
      vehicleId: json['vehicle_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'route_id': routeId,
      'route_number': routeNumber,
      'route_name': routeName,
      'stop_id': stopId,
      'stop_name': stopName,
      'minutes_until_arrival': minutesUntilArrival,
      'estimated_arrival': estimatedArrival.toIso8601String(),
      'vehicle_id': vehicleId,
    };
  }

  bool get isArriving => minutesUntilArrival <= 2;
  bool get isApproaching => minutesUntilArrival <= 5;
}
