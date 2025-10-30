import 'package:latlong2/latlong.dart';

/// seed data for the streetsmart app

class DemoData {
  // Wait Time Reports
  static final List<Map<String, dynamic>> waitTimes = [
    {
      'id': '1',
      'schoolName': 'Thomas Jefferson High School',
      'transportMode': 'driving',
      'waitMinutes': 12,
      'reportedAt': DateTime.now().subtract(const Duration(minutes: 5)),
      'reportedBy': 'Parent A',
      'location': 'Main drop-off',
    },
    {
      'id': '2',
      'schoolName': 'Thomas Jefferson High School',
      'transportMode': 'bus',
      'waitMinutes': 8,
      'reportedAt': DateTime.now().subtract(const Duration(minutes: 15)),
      'reportedBy': 'Student B',
      'location': 'Bus loop',
    },
    {
      'id': '3',
      'schoolName': 'Thomas Jefferson High School',
      'transportMode': 'walking',
      'waitMinutes': 3,
      'reportedAt': DateTime.now().subtract(const Duration(hours: 1)),
      'reportedBy': 'Walker C',
      'location': 'Crosswalk entrance',
    },
    {
      'id': '4',
      'schoolName': 'Thomas Jefferson High School',
      'transportMode': 'driving',
      'waitMinutes': 18,
      'reportedAt': DateTime.now().subtract(const Duration(hours: 2)),
      'reportedBy': 'Parent D',
      'location': 'Side entrance',
    },
    {
      'id': '5',
      'schoolName': 'Thomas Jefferson High School',
      'transportMode': 'biking',
      'waitMinutes': 2,
      'reportedAt': DateTime.now().subtract(const Duration(hours: 3)),
      'reportedBy': 'Cyclist E',
      'location': 'Bike racks',
    },
  ];

  // Walking Groups
  static final List<Map<String, dynamic>> walkingGroups = [
    {
      'id': '1',
      'name': 'Morning Braddock Walkers',
      'description': 'Walking group for students living near Braddock Rd',
      'meetTime': '7:15 AM',
      'meetLocation': 'Braddock & Commonwealth',
      'memberCount': 8,
      'isActive': true,
    },
    {
      'id': '2',
      'name': 'Afternoon Commons Crew',
      'description': 'After-school walking group heading towards King St',
      'meetTime': '3:45 PM',
      'meetLocation': 'School main entrance',
      'memberCount': 12,
      'isActive': true,
    },
    {
      'id': '3',
      'name': 'West End Walkers',
      'description': 'Students from the west side neighborhoods',
      'meetTime': '7:30 AM',
      'meetLocation': 'Seminary Rd intersection',
      'memberCount': 6,
      'isActive': true,
    },
  ];

  // Community Comments
  static final List<Map<String, dynamic>> comments = [
    {
      'id': '1',
      'author': 'Sarah M.',
      'content': 'The new crosswalk lights make it so much safer!',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'likes': 15,
      'category': 'safety',
    },
    {
      'id': '2',
      'author': 'Mike T.',
      'content': 'Looking for carpooling partners from Alexandria area',
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'likes': 8,
      'category': 'carpool',
    },
    {
      'id': '3',
      'author': 'Jennifer L.',
      'content': 'Bus 401 has been running late this week',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'likes': 23,
      'category': 'transit',
    },
    {
      'id': '4',
      'author': 'David K.',
      'content': 'Great bike lane improvements on Braddock!',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'likes': 31,
      'category': 'biking',
    },
    {
      'id': '5',
      'author': 'Lisa P.',
      'content': 'Watch out for construction on Seminary Rd',
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
      'likes': 42,
      'category': 'alert',
    },
  ];

  // Bike Racks
  static final List<Map<String, dynamic>> bikeRacks = [
    {
      'id': '1',
      'name': 'Main Entrance Racks',
      'location': LatLng(38.8189, -77.1689),
      'capacity': 24,
      'available': 8,
      'covered': true,
      'distance': '0.1 mi',
    },
    {
      'id': '2',
      'name': 'Athletic Building',
      'location': LatLng(38.8180, -77.1685),
      'capacity': 16,
      'available': 12,
      'covered': false,
      'distance': '0.2 mi',
    },
    {
      'id': '3',
      'name': 'Library Side',
      'location': LatLng(38.8195, -77.1692),
      'capacity': 12,
      'available': 3,
      'covered': true,
      'distance': '0.15 mi',
    },
    {
      'id': '4',
      'name': 'Student Parking Lot',
      'location': LatLng(38.8175, -77.1680),
      'capacity': 20,
      'available': 15,
      'covered': false,
      'distance': '0.3 mi',
    },
  ];

  // Bike Share Stations
  static final List<Map<String, dynamic>> bikeShareStations = [
    {
      'id': '1',
      'name': 'Braddock Road Metro',
      'location': LatLng(38.8139, -77.0533),
      'bikesAvailable': 7,
      'docksAvailable': 12,
      'distance': '2.1 mi',
    },
    {
      'id': '2',
      'name': 'King Street Metro',
      'location': LatLng(38.8065, -77.0609),
      'bikesAvailable': 3,
      'docksAvailable': 15,
      'distance': '3.4 mi',
    },
    {
      'id': '3',
      'name': 'Seminary Road',
      'location': LatLng(38.8210, -77.1450),
      'bikesAvailable': 12,
      'docksAvailable': 8,
      'distance': '0.8 mi',
    },
  ];

  // Bus Stops
  static final List<Map<String, dynamic>> busStops = [
    {
      'id': '1',
      'name': 'Braddock Rd & TJ',
      'location': LatLng(38.8189, -77.1695),
      'routes': ['401', '402'],
      'distance': '0.1 mi',
    },
    {
      'id': '2',
      'name': 'Braddock Rd & Commonwealth',
      'location': LatLng(38.8150, -77.1580),
      'routes': ['401', '402', '403'],
      'distance': '0.5 mi',
    },
    {
      'id': '3',
      'name': 'Seminary Rd & Braddock',
      'location': LatLng(38.8220, -77.1650),
      'routes': ['402', '405'],
      'distance': '0.3 mi',
    },
  ];

  // Bus Arrival Times
  static final List<Map<String, dynamic>> busArrivals = [
    {
      'route': '401',
      'destination': 'Pentagon',
      'arrivalMinutes': 3,
      'scheduled': true,
    },
    {
      'route': '401',
      'destination': 'Pentagon',
      'arrivalMinutes': 23,
      'scheduled': true,
    },
    {
      'route': '402',
      'destination': 'King St Metro',
      'arrivalMinutes': 8,
      'scheduled': true,
    },
    {
      'route': '402',
      'destination': 'King St Metro',
      'arrivalMinutes': 28,
      'scheduled': true,
    },
    {
      'route': '403',
      'destination': 'Alexandria',
      'arrivalMinutes': 12,
      'scheduled': false, // Delayed
    },
  ];

  // Traffic Conditions
  static final List<Map<String, dynamic>> trafficIncidents = [
    {
      'id': '1',
      'type': 'congestion',
      'severity': 'moderate',
      'location': 'Braddock Rd near 495',
      'description': 'Heavy traffic, expect 10 min delay',
      'reportedAt': DateTime.now().subtract(const Duration(minutes: 15)),
    },
    {
      'id': '2',
      'type': 'construction',
      'severity': 'low',
      'location': 'Seminary Rd',
      'description': 'Lane closure, minor delays',
      'reportedAt': DateTime.now().subtract(const Duration(hours: 2)),
    },
  ];

  // Safe Paths (walking routes)
  static final List<Map<String, dynamic>> safePaths = [
    {
      'id': '1',
      'name': 'Braddock Road Path',
      'description': 'Well-lit sidewalks with crosswalks',
      'safetyScore': 850,
      'distance': '1.2 mi',
      'features': ['Street lights', 'Crosswalks', 'Sidewalks'],
    },
    {
      'id': '2',
      'name': 'Seminary Green Route',
      'description': 'Residential streets with lower traffic',
      'safetyScore': 720,
      'distance': '1.5 mi',
      'features': ['Quiet streets', 'Sidewalks', 'Residential'],
    },
    {
      'id': '3',
      'name': 'Commonwealth Connector',
      'description': 'Direct route with bike lanes',
      'safetyScore': 680,
      'distance': '1.0 mi',
      'features': ['Bike lanes', 'Traffic signals', 'Bus stops'],
    },
  ];

  // Drop-off Zone Info
  static final List<Map<String, dynamic>> dropOffInfo = [
    {
      'location': 'Main Drop-off Circle',
      'description': 'Primary parent drop-off zone with designated lanes. Please follow staff directions.',
      'hours': '7:00 AM - 8:00 AM, 2:30 PM - 3:30 PM',
      'rules': [
        'Stay in your vehicle',
        'Follow staff directions',
        'Keep traffic moving - no parking',
        'Use passenger side for student exit',
      ],
    },
    {
      'location': 'Side Entrance (West)',
      'description': 'Alternative drop-off with less traffic. Best for quick drop-offs.',
      'hours': '7:00 AM - 8:00 AM, 2:30 PM - 3:30 PM',
      'rules': [
        'Maximum 2-minute wait',
        'Pull forward to allow others',
        'No U-turns in drop-off zone',
        'Watch for pedestrians',
      ],
    },
    {
      'location': 'Bus Loop (North)',
      'description': 'Dedicated area for school buses only. No private vehicles allowed.',
      'hours': '7:15 AM - 7:45 AM, 2:45 PM - 3:15 PM',
      'rules': [
        'School buses only',
        'No parking or stopping',
        'Do not block bus lanes',
        'Alternative routes available',
      ],
    },
  ];
}
