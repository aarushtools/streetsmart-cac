class BikeRack {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final int capacity;
  final String? type; // covered, uncovered, locker
  final String? accessibility;
  final bool isAvailable;

  BikeRack({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.capacity,
    this.type,
    this.accessibility,
    this.isAvailable = true,
  });

  factory BikeRack.fromJson(Map<String, dynamic> json) {
    return BikeRack(
      id: json['id'].toString(),
      name: json['name'] ?? 'Bike Rack',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      capacity: json['capacity'] ?? 5,
      type: json['type'],
      accessibility: json['accessibility'],
      isAvailable: json['is_available'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'capacity': capacity,
      'type': type,
      'accessibility': accessibility,
      'is_available': isAvailable,
    };
  }
}

class BikeShare {
  final String id;
  final String stationName;
  final double latitude;
  final double longitude;
  final int availableBikes;
  final int availableDocks;
  final int totalDocks;
  final bool isActive;
  final String? provider; // e.g., Capital Bikeshare

  BikeShare({
    required this.id,
    required this.stationName,
    required this.latitude,
    required this.longitude,
    required this.availableBikes,
    required this.availableDocks,
    required this.totalDocks,
    this.isActive = true,
    this.provider,
  });

  factory BikeShare.fromJson(Map<String, dynamic> json) {
    return BikeShare(
      id: json['id'].toString(),
      stationName: json['station_name'] ?? 'Bike Share Station',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      availableBikes: json['available_bikes'] ?? 0,
      availableDocks: json['available_docks'] ?? 0,
      totalDocks: json['total_docks'] ?? 0,
      isActive: json['is_active'] ?? true,
      provider: json['provider'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'station_name': stationName,
      'latitude': latitude,
      'longitude': longitude,
      'available_bikes': availableBikes,
      'available_docks': availableDocks,
      'total_docks': totalDocks,
      'is_active': isActive,
      'provider': provider,
    };
  }

  bool get hasBikesAvailable => availableBikes > 0;
  bool get hasDocksAvailable => availableDocks > 0;
}
