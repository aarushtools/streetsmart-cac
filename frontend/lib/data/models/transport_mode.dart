enum TravelMode {
  walking,
  biking,
  bus,
  driving;

  String get displayName {
    switch (this) {
      case TravelMode.walking:
        return 'Walking';
      case TravelMode.biking:
        return 'Biking';
      case TravelMode.bus:
        return 'Bus';
      case TravelMode.driving:
        return 'Driving';
    }
  }

  String get description {
    switch (this) {
      case TravelMode.walking:
        return 'Walk to school with safe paths';
      case TravelMode.biking:
        return 'Bike with dedicated lanes';
      case TravelMode.bus:
        return 'Take the school or metro bus';
      case TravelMode.driving:
        return 'Drive with traffic updates';
    }
  }

  String toJson() => name;
  
  static TravelMode fromJson(String json) {
    return TravelMode.values.firstWhere((mode) => mode.name == json);
  }
}

enum HazardType {
  traffic,
  collision,
  pothole,
  lighting,
  weather,
  construction,
  suspicious,
  other;

  String get displayName {
    switch (this) {
      case HazardType.traffic:
        return 'Traffic Jam';
      case HazardType.collision:
        return 'Accident/Collision';
      case HazardType.pothole:
        return 'Pothole/Road Damage';
      case HazardType.lighting:
        return 'Poor Lighting';
      case HazardType.weather:
        return 'Weather Hazard';
      case HazardType.construction:
        return 'Construction';
      case HazardType.suspicious:
        return 'Suspicious Activity';
      case HazardType.other:
        return 'Other';
    }
  }

  String toJson() => name;
  
  static HazardType fromJson(String json) {
    return HazardType.values.firstWhere((type) => type.name == json);
  }
}

enum HazardSeverity {
  low,
  medium,
  high;

  String get displayName {
    switch (this) {
      case HazardSeverity.low:
        return 'Low';
      case HazardSeverity.medium:
        return 'Medium';
      case HazardSeverity.high:
        return 'High';
    }
  }

  String toJson() => name;
  
  static HazardSeverity fromJson(String json) {
    return HazardSeverity.values.firstWhere((severity) => severity.name == json);
  }
}
