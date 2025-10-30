class AppConstants {
  // App Info
  static const String appName = 'StreetSmart';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Fairfax County Safe Commute Assistant';
  
  // Map Settings
  static const double defaultZoom = 15.0;
  static const double minZoom = 10.0;
  static const double maxZoom = 20.0;
  
  // Location Settings
  static const double locationUpdateInterval = 10.0; // seconds
  static const double hazardRadiusMeters = 1000.0;
  static const double schoolRadiusMeters = 5000.0;
  static const double bikeStationRadiusMeters = 2000.0;
  
  // Crowdsource Settings
  static const int waitTimeValidMinutes = 30;
  static const int minWaitTimeReports = 3;
  
  // Walking Group Settings
  static const int maxGroupMembers = 10;
  static const int groupSearchRadiusMeters = 1000;
  
  // API Settings
  static const int apiTimeoutSeconds = 30;
  static const int maxRetries = 3;
  
  // Cache Settings
  static const int cacheExpiryMinutes = 15;
  
  // NLP Keywords for Hazard Detection
  static const List<String> hazardKeywords = [
    'accident', 'crash', 'collision', 'dangerous', 'hazard',
    'pothole', 'broken', 'unsafe', 'flooded', 'ice', 'snow',
    'construction', 'blocked', 'dark', 'no light', 'suspicious'
  ];
  
  // Default Fairfax County Location
  static const double defaultLatitude = 38.8462;
  static const double defaultLongitude = -77.3064;
}
