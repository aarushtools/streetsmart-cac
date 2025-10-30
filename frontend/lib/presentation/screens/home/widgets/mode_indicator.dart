import 'package:flutter/material.dart';
import 'package:streetsmart/core/constants/theme_constants.dart';
import 'package:streetsmart/data/models/transport_mode.dart';
import 'package:streetsmart/data/models/school_model.dart';
// dart:math previously used for random safety score/ETA; removed when
// navigation now opens a demo directions page.

import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:streetsmart/presentation/providers/navigation_provider.dart';

class ModeIndicator extends StatelessWidget {
  final TravelMode mode;
  final School? school;

  const ModeIndicator({
    super.key,
    required this.mode,
    this.school,
  });

  IconData _getIcon() {
    switch (mode) {
      case TravelMode.walking:
        return Icons.directions_walk;
      case TravelMode.biking:
        return Icons.directions_bike;
      case TravelMode.bus:
        return Icons.directions_bus;
      case TravelMode.driving:
        return Icons.directions_car;
    }
  }

  Color _getColor() {
    switch (mode) {
      case TravelMode.walking:
        return ThemeConstants.walkingColor;
      case TravelMode.biking:
        return ThemeConstants.bikingColor;
      case TravelMode.bus:
        return ThemeConstants.busColor;
      case TravelMode.driving:
        return ThemeConstants.drivingColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.paddingMedium,
        vertical: ThemeConstants.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getColor().withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIcon(),
              color: _getColor(),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mode.displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (school != null)
                  Text(
                    school!.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.navigation),
            onPressed: () async {
              if (school == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No school selected')),
                );
                return;
              }

              final nav = Provider.of<NavigationProvider>(context, listen: false);

              await nav.navigateTo(destination: LatLng(school!.latitude, school!.longitude));

            },
          ),
        ],
      ),
    );
  }
}
