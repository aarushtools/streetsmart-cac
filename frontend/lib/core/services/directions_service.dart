import 'dart:async';
import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class RouteResult {
  final List<LatLng> points;
  final int distanceMeters;
  final int durationSeconds;

  RouteResult({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
  });
}

class DirectionsService {
  static const String orsApiKey = 'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6ImVkMzZjNTM5ODQ3MjQyNGNiZDQ5NTJiODMxMWUyMWY3IiwiaCI6Im11cm11cjY0In0=';

  static const String orsBaseUrl = 'https://api.openrouteservice.org/v2/directions/foot-walking/geojson';

  static Future<RouteResult> getDirections({
    required LatLng origin,
    required LatLng destination,
    String mode = 'walking',
  }) async {
    if (orsApiKey == 'YOUR_ORS_API_KEY' || orsApiKey.trim().isEmpty) {
      final fallback = <LatLng>[
        origin,
        destination,
      ];
      return RouteResult(points: fallback, distanceMeters: 0, durationSeconds: 0);
    }

    final body = jsonEncode({
      'coordinates': [
        [origin.longitude, origin.latitude],
        [destination.longitude, destination.latitude],
      ],
      'elevation': false,
      'instructions': true,
    });

    final resp = await http.post(
      Uri.parse(orsBaseUrl),
      headers: {
        'Authorization': orsApiKey,
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: body,
    );

    if (resp.statusCode != 200) {
      // Fallback: straight line if API fails
      final fallback = <LatLng>[origin, destination];
      return RouteResult(points: fallback, distanceMeters: 0, durationSeconds: 0);
    }

    final decoded = jsonDecode(resp.body) as Map<String, dynamic>;
    final features = (decoded['features'] as List).cast<Map<String, dynamic>>();
    if (features.isEmpty) {
      final fallback = <LatLng>[origin, destination];
      return RouteResult(points: fallback, distanceMeters: 0, durationSeconds: 0);
    }

    final feature = features.first;
    final geometry = feature['geometry'] as Map<String, dynamic>;
    final coords = (geometry['coordinates'] as List).cast<List>();

    final points = <LatLng>[];
    for (final c in coords) {
      // ORS: [lon, lat]
      if (c.length >= 2) {
        points.add(LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()));
      }
    }

    int distance = 0;
    int duration = 0;
    final props = feature['properties'] as Map<String, dynamic>;
    if (props.containsKey('summary')) {
      final summary = props['summary'] as Map<String, dynamic>;
      distance = (summary['distance'] as num?)?.toInt() ?? 0;
      duration = (summary['duration'] as num?)?.toInt() ?? 0;
    } else if (props.containsKey('segments')) {
      final segments = (props['segments'] as List).cast<Map<String, dynamic>>();
      if (segments.isNotEmpty) {
        distance = (segments.first['distance'] as num?)?.toInt() ?? 0;
        duration = (segments.first['duration'] as num?)?.toInt() ?? 0;
      }
    }

    return RouteResult(points: points, distanceMeters: distance, durationSeconds: duration);
  }
}
