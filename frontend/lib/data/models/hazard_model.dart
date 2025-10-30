import 'package:streetsmart/data/models/transport_mode.dart';

class Hazard {
  final String id;
  final double latitude;
  final double longitude;
  final HazardType type;
  final HazardSeverity severity;
  final String description;
  final DateTime reportedAt;
  final List<TravelMode> affectedModes;
  final int verificationCount;
  final String? reportedBy;
  final String? photoUrl;
  final bool isActive;

  Hazard({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.severity,
    required this.description,
    required this.reportedAt,
    required this.affectedModes,
    this.verificationCount = 1,
    this.reportedBy,
    this.photoUrl,
    this.isActive = true,
  });

  factory Hazard.fromJson(Map<String, dynamic> json) {
    return Hazard(
      id: json['id'].toString(),
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      type: HazardType.fromJson(json['type'] ?? 'other'),
      severity: HazardSeverity.fromJson(json['severity'] ?? 'low'),
      description: json['description'] ?? '',
      reportedAt: json['reported_at'] != null
          ? DateTime.parse(json['reported_at'])
          : DateTime.now(),
      affectedModes: (json['affected_modes'] as List<dynamic>?)
              ?.map((mode) => TravelMode.fromJson(mode))
              .toList() ??
          [],
      verificationCount: json['verification_count'] ?? 1,
      reportedBy: json['reported_by'],
      photoUrl: json['photo_url'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'type': type.toJson(),
      'severity': severity.toJson(),
      'description': description,
      'reported_at': reportedAt.toIso8601String(),
      'affected_modes': affectedModes.map((mode) => mode.toJson()).toList(),
      'verification_count': verificationCount,
      'reported_by': reportedBy,
      'photo_url': photoUrl,
      'is_active': isActive,
    };
  }

  bool affectsMode(TravelMode mode) {
    return affectedModes.contains(mode);
  }
}

class HazardSubmission {
  final double latitude;
  final double longitude;
  final HazardType type;
  final HazardSeverity severity;
  final String description;
  final List<TravelMode> affectedModes;
  final String? photoBase64;

  HazardSubmission({
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.severity,
    required this.description,
    required this.affectedModes,
    this.photoBase64,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'type': type.toJson(),
      'severity': severity.toJson(),
      'description': description,
      'affected_modes': affectedModes.map((mode) => mode.toJson()).toList(),
      'photo_base64': photoBase64,
    };
  }
}
