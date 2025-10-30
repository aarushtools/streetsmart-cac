import 'package:streetsmart/data/models/transport_mode.dart';

class WaitTime {
  final String id;
  final String locationId;
  final String locationName;
  final double latitude;
  final double longitude;
  final int waitMinutes;
  final DateTime timestamp;
  final TravelMode mode;
  final int reportCount;
  final String? userId;
  final String? notes;

  WaitTime({
    required this.id,
    required this.locationId,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.waitMinutes,
    required this.timestamp,
    required this.mode,
    this.reportCount = 1,
    this.userId,
    this.notes,
  });

  factory WaitTime.fromJson(Map<String, dynamic> json) {
    return WaitTime(
      id: json['id'].toString(),
      locationId: json['location_id'].toString(),
      locationName: json['location_name'] ?? 'Unknown Location',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      waitMinutes: json['wait_minutes'] ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      mode: TravelMode.fromJson(json['mode'] ?? 'driving'),
      reportCount: json['report_count'] ?? 1,
      userId: json['user_id'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location_id': locationId,
      'location_name': locationName,
      'latitude': latitude,
      'longitude': longitude,
      'wait_minutes': waitMinutes,
      'timestamp': timestamp.toIso8601String(),
      'mode': mode.toJson(),
      'report_count': reportCount,
      'user_id': userId,
      'notes': notes,
    };
  }

  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    return difference.inMinutes < 30;
  }
}

class WaitTimeSubmission {
  final String locationId;
  final String locationName;
  final double latitude;
  final double longitude;
  final int waitMinutes;
  final TravelMode mode;
  final String? notes;

  WaitTimeSubmission({
    required this.locationId,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.waitMinutes,
    required this.mode,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'location_id': locationId,
      'location_name': locationName,
      'latitude': latitude,
      'longitude': longitude,
      'wait_minutes': waitMinutes,
      'mode': mode.toJson(),
      'notes': notes,
    };
  }
}
