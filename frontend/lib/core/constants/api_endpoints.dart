class ApiEndpoints {
  // Base URL - Update this to your backend URL
  static const String baseUrl = 'http://10.0.2.2:8000'; // Android emulator
  // static const String baseUrl = 'http://localhost:8000'; // iOS simulator
  // static const String baseUrl = 'http://YOUR_IP:8000'; // Physical device
  
  static const String apiPrefix = '/api';
  
  // Auth Endpoints
  static const String login = '$apiPrefix/auth/login';
  static const String register = '$apiPrefix/auth/register';
  static const String logout = '$apiPrefix/auth/logout';
  
  // Safe Routes Endpoints (from backend OSM data)
  static const String pedestrianWays = '$apiPrefix/pedestrian-ways';
  static const String safetyPoints = '$apiPrefix/safety-points';
  static const String safetyAreas = '$apiPrefix/safety-areas';
  
  // Crowdsource Endpoints
  static const String waitTimes = '$apiPrefix/wait-times';
  static const String submitWaitTime = '$apiPrefix/wait-times/submit';
  
  // Hazards Endpoints
  static const String hazards = '$apiPrefix/hazards';
  static const String submitHazard = '$apiPrefix/hazards/submit';
  static const String verifyHazard = '$apiPrefix/hazards/verify';
  
  // Comments Endpoints
  static const String comments = '$apiPrefix/comments';
  static const String submitComment = '$apiPrefix/comments/submit';
  
  // Walking Groups Endpoints
  static const String walkingGroups = '$apiPrefix/walking-groups';
  static const String createGroup = '$apiPrefix/walking-groups/create';
  static const String joinGroup = '$apiPrefix/walking-groups/join';
  static const String leaveGroup = '$apiPrefix/walking-groups/leave';
  
  // Schools Endpoints
  static const String schools = '$apiPrefix/schools';
  static const String schoolDetails = '$apiPrefix/schools';
  static const String schoolTraffic = '$apiPrefix/schools/traffic';
  
  // Bike Endpoints
  static const String bikeRacks = '$apiPrefix/bike-racks';
  static const String bikeShares = '$apiPrefix/bike-shares';
  
  // Bus Endpoints (HereComesTheBus integration)
  static const String busRoutes = '$apiPrefix/bus/routes';
  static const String busStops = '$apiPrefix/bus/stops';
  static const String busArrivals = '$apiPrefix/bus/arrivals';
  
  // Traffic Endpoints
  static const String trafficData = '$apiPrefix/traffic';
  static const String schoolDropoffTimes = '$apiPrefix/traffic/school-dropoff';
  
  // Helper method to build full URL
  static String buildUrl(String endpoint, [Map<String, dynamic>? queryParams]) {
    String url = baseUrl + endpoint;
    if (queryParams != null && queryParams.isNotEmpty) {
      url += '?';
      queryParams.forEach((key, value) {
        url += '$key=$value&';
      });
      url = url.substring(0, url.length - 1); // Remove trailing &
    }
    return url;
  }
}
