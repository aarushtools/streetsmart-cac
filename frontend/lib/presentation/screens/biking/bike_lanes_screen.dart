import 'package:flutter/material.dart';
import 'package:streetsmart/core/constants/theme_constants.dart';

class BikeLanesScreen extends StatelessWidget {
  const BikeLanesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lanes = [
      {
        'name': 'Chain Bridge Road Protected Lane',
        'type': 'Protected',
        'distance': '1.2 mi',
        'condition': 'Good',
        'icon': Icons.shield,
      },
      {
        'name': 'Old Courthouse Shared Lane',
        'type': 'Shared',
        'distance': '0.8 mi',
        'condition': 'Fair',
        'icon': Icons.swap_horiz,
      },
      {
        'name': 'Westpark Drive Bike Path',
        'type': 'Dedicated Path',
        'distance': '2.1 mi',
        'condition': 'Excellent',
        'icon': Icons.park,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bike Lanes'),
        backgroundColor: ThemeConstants.bikingColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Bike-friendly routes and dedicated lanes',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ...lanes.map((lane) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(lane['icon'] as IconData, color: ThemeConstants.bikingColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            lane['name'] as String,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: ThemeConstants.bikingColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                lane['type'] as String,
                                style: TextStyle(
                                  color: ThemeConstants.bikingColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.straighten, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(lane['distance'] as String),
                          ],
                        ),
                        Text(
                          lane['condition'] as String,
                          style: TextStyle(
                            color: lane['condition'] == 'Excellent' ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.bold,
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
