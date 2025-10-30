class WalkingGroup {
  final String id;
  final String name;
  final String organizerId;
  final String? organizerName;
  final double startLatitude;
  final double startLongitude;
  final double endLatitude;
  final double endLongitude;
  final String? startLocationName;
  final String? endLocationName;
  final DateTime departureTime;
  final int memberCount;
  final int maxMembers;
  final List<String> memberIds;
  final String? description;
  final bool isActive;

  WalkingGroup({
    required this.id,
    required this.name,
    required this.organizerId,
    this.organizerName,
    required this.startLatitude,
    required this.startLongitude,
    required this.endLatitude,
    required this.endLongitude,
    this.startLocationName,
    this.endLocationName,
    required this.departureTime,
    required this.memberCount,
    this.maxMembers = 10,
    this.memberIds = const [],
    this.description,
    this.isActive = true,
  });

  factory WalkingGroup.fromJson(Map<String, dynamic> json) {
    return WalkingGroup(
      id: json['id'].toString(),
      name: json['name'] ?? 'Walking Group',
      organizerId: json['organizer_id'].toString(),
      organizerName: json['organizer_name'],
      startLatitude: (json['start_latitude'] ?? 0.0).toDouble(),
      startLongitude: (json['start_longitude'] ?? 0.0).toDouble(),
      endLatitude: (json['end_latitude'] ?? 0.0).toDouble(),
      endLongitude: (json['end_longitude'] ?? 0.0).toDouble(),
      startLocationName: json['start_location_name'],
      endLocationName: json['end_location_name'],
      departureTime: json['departure_time'] != null
          ? DateTime.parse(json['departure_time'])
          : DateTime.now(),
      memberCount: json['member_count'] ?? 0,
      maxMembers: json['max_members'] ?? 10,
      memberIds: (json['member_ids'] as List<dynamic>?)
              ?.map((id) => id.toString())
              .toList() ??
          [],
      description: json['description'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'organizer_id': organizerId,
      'organizer_name': organizerName,
      'start_latitude': startLatitude,
      'start_longitude': startLongitude,
      'end_latitude': endLatitude,
      'end_longitude': endLongitude,
      'start_location_name': startLocationName,
      'end_location_name': endLocationName,
      'departure_time': departureTime.toIso8601String(),
      'member_count': memberCount,
      'max_members': maxMembers,
      'member_ids': memberIds,
      'description': description,
      'is_active': isActive,
    };
  }

  bool get isFull => memberCount >= maxMembers;
  
  bool get isDepartingSoon {
    final now = DateTime.now();
    final difference = departureTime.difference(now);
    return difference.inMinutes <= 15 && difference.inMinutes >= 0;
  }
}

class WalkingGroupRequest {
  final String name;
  final double startLatitude;
  final double startLongitude;
  final double endLatitude;
  final double endLongitude;
  final String? startLocationName;
  final String? endLocationName;
  final DateTime departureTime;
  final int maxMembers;
  final String? description;

  WalkingGroupRequest({
    required this.name,
    required this.startLatitude,
    required this.startLongitude,
    required this.endLatitude,
    required this.endLongitude,
    this.startLocationName,
    this.endLocationName,
    required this.departureTime,
    this.maxMembers = 10,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'start_latitude': startLatitude,
      'start_longitude': startLongitude,
      'end_latitude': endLatitude,
      'end_longitude': endLongitude,
      'start_location_name': startLocationName,
      'end_location_name': endLocationName,
      'departure_time': departureTime.toIso8601String(),
      'max_members': maxMembers,
      'description': description,
    };
  }
}
