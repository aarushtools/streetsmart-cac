import 'package:flutter/material.dart';
import 'package:streetsmart/core/constants/theme_constants.dart';
import 'package:streetsmart/data/models/transport_mode.dart';
import 'package:streetsmart/presentation/screens/hazards/hazards_page.dart';
import 'package:streetsmart/presentation/screens/walking/walking_groups_list_screen.dart';
import 'package:streetsmart/presentation/screens/walking/safe_paths_screen.dart';
import 'package:streetsmart/presentation/screens/biking/bike_racks_screen.dart';
import 'package:streetsmart/presentation/screens/biking/bike_share_screen.dart';
import 'package:streetsmart/presentation/screens/biking/bike_lanes_screen.dart';
import 'package:streetsmart/presentation/screens/bus/bus_times_screen.dart';
import 'package:streetsmart/presentation/screens/bus/nearby_stops_screen.dart';
import 'package:streetsmart/presentation/screens/bus/bus_routes_screen.dart';
import 'package:streetsmart/presentation/screens/wait_times/wait_times_screen.dart';
import 'package:streetsmart/presentation/screens/driving/traffic_screen.dart';
import 'package:streetsmart/presentation/screens/driving/dropoff_info_screen.dart';

class QuickActionsBar extends StatelessWidget {
  final TravelMode mode;

  const QuickActionsBar({
    super.key,
    required this.mode,
  });

  List<QuickAction> _getActionsForMode() {
    switch (mode) {
      case TravelMode.walking:
        return [
          QuickAction(
            icon: Icons.group,
            label: 'Walking Groups',
            color: ThemeConstants.walkingColor,
          ),
          QuickAction(
            icon: Icons.route,
            label: 'Safe Paths',
            color: ThemeConstants.walkingColor,
          ),
          QuickAction(
            icon: Icons.warning_amber,
            label: 'Hazards',
            color: ThemeConstants.warningColor,
          ),
        ];
      case TravelMode.biking:
        return [
          QuickAction(
            icon: Icons.pedal_bike,
            label: 'Bike Racks',
            color: ThemeConstants.bikingColor,
          ),
          QuickAction(
            icon: Icons.bike_scooter,
            label: 'Bike Share',
            color: ThemeConstants.bikingColor,
          ),
          QuickAction(
            icon: Icons.route,
            label: 'Bike Lanes',
            color: ThemeConstants.bikingColor,
          ),
        ];
      case TravelMode.bus:
        return [
          QuickAction(
            icon: Icons.schedule,
            label: 'Bus Times',
            color: ThemeConstants.busColor,
          ),
          QuickAction(
            icon: Icons.bus_alert,
            label: 'Nearby Stops',
            color: ThemeConstants.busColor,
          ),
          QuickAction(
            icon: Icons.map,
            label: 'Routes',
            color: ThemeConstants.busColor,
          ),
        ];
      case TravelMode.driving:
        return [
          QuickAction(
            icon: Icons.access_time,
            label: 'Wait Times',
            color: ThemeConstants.drivingColor,
          ),
          QuickAction(
            icon: Icons.traffic,
            label: 'Traffic',
            color: ThemeConstants.drivingColor,
          ),
          QuickAction(
            icon: Icons.school,
            label: 'Drop-off Info',
            color: ThemeConstants.drivingColor,
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final actions = _getActionsForMode();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(ThemeConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: actions.map((action) {
          return _QuickActionButton(action: action);
        }).toList(),
      ),
    );
  }
}

class QuickAction {
  final IconData icon;
  final String label;
  final Color color;

  QuickAction({
    required this.icon,
    required this.label,
    required this.color,
  });
}

class _QuickActionButton extends StatelessWidget {
  final QuickAction action;

  const _QuickActionButton({required this.action});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Walking mode actions
        if (action.label == 'Walking Groups') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WalkingGroupsListScreen()));
          return;
        }
        if (action.label == 'Safe Paths') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SafePathsScreen()));
          return;
        }
        if (action.label == 'Hazards') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HazardsPage()));
          return;
        }

        // Biking mode actions
        if (action.label == 'Bike Racks') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BikeRacksScreen()));
          return;
        }
        if (action.label == 'Bike Share') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BikeShareScreen()));
          return;
        }
        if (action.label == 'Bike Lanes') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BikeLanesScreen()));
          return;
        }

        // Bus mode actions
        if (action.label == 'Bus Times') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BusTimesScreen()));
          return;
        }
        if (action.label == 'Nearby Stops') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NearbyStopsScreen()));
          return;
        }
        if (action.label == 'Routes') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BusRoutesScreen()));
          return;
        }

        // Driving mode actions
        if (action.label == 'Wait Times') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WaitTimesScreen()));
          return;
        }
        if (action.label == 'Traffic') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TrafficScreen()));
          return;
        }
        if (action.label == 'Drop-off Info') {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DropoffInfoScreen()));
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${action.label} coming soon!')),
        );
      },
      borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: action.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                action.icon,
                color: action.color,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              action.label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
