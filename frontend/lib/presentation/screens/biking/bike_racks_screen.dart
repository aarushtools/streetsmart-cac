import 'package:flutter/material.dart';
import 'package:streetsmart/data/demo/demo_data.dart';
import 'package:streetsmart/core/constants/theme_constants.dart';
import 'package:latlong2/latlong.dart';

class BikeRacksScreen extends StatelessWidget {
  const BikeRacksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bike Racks'),
        backgroundColor: ThemeConstants.bikingColor,
      ),
      body: DemoData.bikeRacks.isEmpty
          ? const Center(
              child: Text(
                'No bike racks available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Find secure bike parking near your destination',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                ...DemoData.bikeRacks.map((rack) {
                  final capacity = rack['capacity'] as int;
                  final available = rack['available'] as int;
                  final percentage = (available / capacity * 100).round();
                  final color = percentage > 50
                      ? Colors.green
                      : (percentage > 20 ? Colors.orange : Colors.red);
                  final location = rack['location'] as LatLng;
                  final distance = rack['distance'] as String? ?? 'Distance unknown';
                  final covered = rack['covered'] as bool? ?? false;
                  final name = rack['name'] as String;

                  // Format location as readable address
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
                              Icon(Icons.pedal_bike,
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
                              if (covered)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.roofing,
                                          size: 14, color: Colors.blue),
                                      const SizedBox(width: 2),
                                      const Text(
                                        'Covered',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Capacity: $available/$capacity spots',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '$percentage% Available',
                                  style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
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
