class School {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String? address;
  final String? phone;
  final String? type; // elementary, middle, high
  final int? estimatedWaitMinutes;
  final int? crowdsourceCount;

  School({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.address,
    this.phone,
    this.type,
    this.estimatedWaitMinutes,
    this.crowdsourceCount,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'].toString(),
      name: json['name'] ?? 'Unknown School',
      latitude: (json['latitude'] ?? json['lat'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? json['lng'] ?? 0.0).toDouble(),
      address: json['address'],
      phone: json['phone'],
      type: json['type'],
      estimatedWaitMinutes: json['estimated_wait_minutes'],
      crowdsourceCount: json['crowdsource_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'phone': phone,
      'type': type,
      'estimated_wait_minutes': estimatedWaitMinutes,
      'crowdsource_count': crowdsourceCount,
    };
  }

  School copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
    String? address,
    String? phone,
    String? type,
    int? estimatedWaitMinutes,
    int? crowdsourceCount,
  }) {
    return School(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      type: type ?? this.type,
      estimatedWaitMinutes: estimatedWaitMinutes ?? this.estimatedWaitMinutes,
      crowdsourceCount: crowdsourceCount ?? this.crowdsourceCount,
    );
  }
}
