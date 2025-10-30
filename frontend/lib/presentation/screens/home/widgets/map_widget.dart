import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:streetsmart/core/constants/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:streetsmart/presentation/providers/navigation_provider.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final MapController _mapController = MapController();
  List<LatLng> _lastRoutePoints = [];

  void _fitBounds(List<LatLng> routePoints) {
    if (routePoints.isEmpty) return;

    double minLat = routePoints.first.latitude;
    double maxLat = routePoints.first.latitude;
    double minLng = routePoints.first.longitude;
    double maxLng = routePoints.first.longitude;

    for (final p in routePoints) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    final center = LatLng((minLat + maxLat) / 2, (minLng + maxLng) / 2);
    final latSpan = (maxLat - minLat).abs();
    final lngSpan = (maxLng - minLng).abs();
    // Rough zoom heuristic for flutter_map
    final span = latSpan > lngSpan ? latSpan : lngSpan;
    final zoom = span == 0 ? AppConstants.defaultZoom : (16 - (span * 12)).clamp(3.0, 18.0);

    _mapController.move(center, zoom);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, nav, _) {
        if (nav.routePoints.isNotEmpty && nav.routePoints != _lastRoutePoints) {
          _lastRoutePoints = List.from(nav.routePoints);
          Future.microtask(() => _fitBounds(nav.routePoints));
        }

        final polylinePoints = nav.routePoints;

        return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude),
            initialZoom: AppConstants.defaultZoom,
            backgroundColor: Colors.white,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'streetsmart.app',
              tileProvider: CancellableNetworkTileProvider(),
              panBuffer: 2,
              maxNativeZoom: 19,
              retinaMode: false,
            ),
            if (polylinePoints.isNotEmpty)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: polylinePoints,
                    strokeWidth: 6,
                    color: Colors.blue,
                  ),
                ],
              ),
            if (polylinePoints.isNotEmpty)
              MarkerLayer(
                markers: [
                  Marker(
                    point: polylinePoints.first,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.location_pin, color: Colors.red, size: 36),
                  ),
                  Marker(
                    point: polylinePoints.last,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.flag, color: Colors.green, size: 30),
                  ),
                ],
              ),
          ],
        ),
        
        // Show what would be on the map
        Positioned(
          bottom: 100,
          left: 16,
          right: 16,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Map Features Preview',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildFeatureRow(Icons.school, 'Schools nearby'),
                  _buildFeatureRow(Icons.warning, 'Hazard alerts'),
                  _buildFeatureRow(Icons.access_time, 'Wait times'),
                  _buildFeatureRow(Icons.route, 'Safe paths'),
                ],
              ),
            ),
          ),
        ),
      ],
        );
      },
    );

    /*
    NOTE: For non-web platforms (Android/iOS) we can show the real GoogleMap
    widget here once API keys are configured per platform. The web plugin
    requires the maps JS script to be present in web/index.html.
    Example configuration is documented in GOOGLE_MAPS_SETUP.md.
    */
  }

  

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
