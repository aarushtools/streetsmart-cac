import 'package:flutter/material.dart';
import 'package:streetsmart/core/constants/theme_constants.dart';
import 'package:streetsmart/data/models/transport_mode.dart';

class TransportModeCard extends StatelessWidget {
  final TravelMode mode;
  final bool isSelected;
  final VoidCallback onTap;

  const TransportModeCard({
    super.key,
    required this.mode,
    required this.isSelected,
    required this.onTap,
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
    final color = _getColor();
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIcon(),
              size: 64,
              color: isSelected ? color : Colors.grey[600],
            ),
            const SizedBox(height: 12),
            Text(
              mode.displayName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? color : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                mode.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
