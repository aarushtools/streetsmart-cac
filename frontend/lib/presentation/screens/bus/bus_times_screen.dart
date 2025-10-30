import 'package:flutter/material.dart';
import 'package:streetsmart/data/demo/demo_data.dart';
import 'package:streetsmart/core/constants/theme_constants.dart';

class BusTimesScreen extends StatelessWidget {
  const BusTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Times'),
        backgroundColor: ThemeConstants.busColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Real-time bus arrival predictions',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ...DemoData.busStops.map((stop) {
            final routes = (stop['routes'] as List<dynamic>).cast<String>();
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.directions_bus, color: ThemeConstants.busColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            stop['name'] as String,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.place, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          stop['distance'] as String,
                          style: TextStyle(color: Colors.grey[700], fontSize: 14),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    ...routes.expand((route) {
                      final arrivalsForRoute = DemoData.busArrivals
                          .where((arrival) => arrival['route'] == route)
                          .toList();
                      return arrivalsForRoute.map((arrival) {
                        final minutes = arrival['arrivalMinutes'] as int;
                        final color = minutes <= 5
                            ? Colors.red
                            : (minutes <= 10 ? Colors.orange : Colors.green);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: ThemeConstants.busColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        arrival['route'] as String,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        arrival['destination'] as String,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            arrival['scheduled'] == true
                                                ? Icons.schedule
                                                : Icons.warning_amber,
                                            size: 14,
                                            color: arrival['scheduled'] == true
                                                ? Colors.grey[600]
                                                : Colors.red,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            arrival['scheduled'] == true
                                                ? 'On schedule'
                                                : 'Delayed',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$minutes min',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                    }),
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
