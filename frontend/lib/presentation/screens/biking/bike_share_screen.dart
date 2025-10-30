import 'package:flutter/material.dart';
import 'package:streetsmart/data/demo/demo_data.dart';
import 'package:streetsmart/core/constants/theme_constants.dart';
import 'package:latlong2/latlong.dart';

class BikeShareScreen extends StatelessWidget {
  const BikeShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bike Share Stations'),
        backgroundColor: ThemeConstants.bikingColor,
      ),
      body: DemoData.bikeShareStations.isEmpty
          ? const Center(
              child: Text(
                'No bike share stations available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Capital Bikeshare stations near you',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ...DemoData.bikeShareStations.map((station) {
                  final availableBikes = station['bikesAvailable'] as int;
                  final availableDocks = station['docksAvailable'] as int;
                  final totalDocks = availableBikes + availableDocks;
                  final location = station['location'] as LatLng;
                  final distance = station['distance'] as String? ?? 'Distance unknown';
                  final name = station['name'] as String;

                  // Format location as readable coordinates
                  final locationString =
                      '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.directions_bike,
                                  color: ThemeConstants.bikingColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  locationString,
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                              Text(
                                distance,
                                style: TextStyle(
                                  color: ThemeConstants.bikingColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Icon(Icons.pedal_bike, color: Colors.green[700]),
                              const SizedBox(height: 4),
                              Text(
                                '$availableBikes',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Bikes',
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 60,
                          color: Colors.grey[300],
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Icon(Icons.lock_outline, color: Colors.blue[700]),
                              const SizedBox(height: 4),
                              Text(
                                '$availableDocks',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Docks',
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total: $totalDocks docks',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
