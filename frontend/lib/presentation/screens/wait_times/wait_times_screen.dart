import 'package:flutter/material.dart';
import 'package:streetsmart/data/demo/demo_data.dart';
import 'package:streetsmart/core/constants/theme_constants.dart';
import 'package:streetsmart/presentation/screens/wait_times/submit_wait_time_screen.dart';

class WaitTimesScreen extends StatelessWidget {
  const WaitTimesScreen({super.key});

  Color _getModeColor(String mode) {
    switch (mode) {
      case 'walking':
        return ThemeConstants.walkingColor;
      case 'biking':
        return ThemeConstants.bikingColor;
      case 'bus':
        return ThemeConstants.busColor;
      case 'driving':
        return ThemeConstants.drivingColor;
      default:
        return Colors.grey;
    }
  }

  IconData _getModeIcon(String mode) {
    switch (mode) {
      case 'walking':
        return Icons.directions_walk;
      case 'biking':
        return Icons.directions_bike;
      case 'bus':
        return Icons.directions_bus;
      case 'driving':
        return Icons.directions_car;
      default:
        return Icons.access_time;
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final duration = DateTime.now().difference(timestamp);
    if (duration.inMinutes < 60) {
      return '${duration.inMinutes}m ago';
    } else if (duration.inHours < 24) {
      return '${duration.inHours}h ago';
    } else {
      return '${duration.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wait Times'),
        backgroundColor: ThemeConstants.primaryColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: DemoData.waitTimes.length,
        itemBuilder: (context, index) {
          final wait = DemoData.waitTimes[index];
          final mode = wait['transportMode'] as String;
          final color = _getModeColor(mode);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getModeIcon(mode),
                  color: color,
                  size: 24,
                ),
              ),
              title: Text(
                '${wait['waitMinutes']} min wait',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(wait['location'] as String),
                  Text(
                    'Reported by ${wait['reportedBy']} • ${_getTimeAgo(wait['reportedAt'] as DateTime)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SubmitWaitTimeScreen()),
          );
        },
        backgroundColor: ThemeConstants.primaryColor,
        icon: const Icon(Icons.add),
        label: const Text('Report Wait Time'),
      ),
    );
  }
}
