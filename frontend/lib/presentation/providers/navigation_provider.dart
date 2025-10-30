import 'dart:async';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:streetsmart/core/services/directions_service.dart';

class NavigationProvider extends ChangeNotifier {
  bool isLoading = false;
  List<LatLng> routePoints = [];
  int distanceMeters = 0;
  int durationSeconds = 0;
  int? safetyScore;
  bool showSafetyCard = false;
  String? error;

  Future<void> navigateTo({required LatLng destination}) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // Start: Weyanoke Elementary (approx)
      final origin = const LatLng(38.8180, -77.1885);

      final result = await DirectionsService.getDirections(origin: origin, destination: destination, mode: 'walking');

      routePoints = result.points;
      distanceMeters = result.distanceMeters;
      durationSeconds = result.durationSeconds;
      
      // Generate "random" safety score (hardcoded to 739 for demo)
      safetyScore = 739;
      showSafetyCard = true;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearRoute() {
    routePoints = [];
    distanceMeters = 0;
    durationSeconds = 0;
    safetyScore = null;
    showSafetyCard = false;
    error = null;
    notifyListeners();
  }

  void dismissSafetyCard() {
    showSafetyCard = false;
    notifyListeners();
  }
  
  Color getSafetyScoreColor() {
    if (safetyScore == null) return Colors.grey;
    if (safetyScore! > 700) return Colors.blue;
    
    // Color coding based on score (out of 1000)
    if (safetyScore! >= 800) {
      return Colors.green; // Excellent: 800-1000
    } else if (safetyScore! >= 600) {
      return Colors.lightGreen; // Good: 600-799
    } else if (safetyScore! >= 400) {
      return Colors.orange; // Moderate: 400-599
    } else if (safetyScore! >= 200) {
      return Colors.deepOrange; // Poor: 200-399
    } else {
      return Colors.red; // Very Poor: 0-199
    }
  }
  
  String getSafetyScoreLabel() {
    if (safetyScore == null) return 'Unknown';
    
    if (safetyScore! >= 800) {
      return 'Excellent';
    } else if (safetyScore! >= 600) {
      return 'Good';
    } else if (safetyScore! >= 400) {
      return 'Moderate';
    } else if (safetyScore! >= 200) {
      return 'Poor';
    } else {
      return 'Very Poor';
    }
  }
}
