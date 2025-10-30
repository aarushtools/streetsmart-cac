import 'package:flutter/material.dart';
import 'package:streetsmart/data/models/transport_mode.dart';
import 'package:streetsmart/data/models/school_model.dart';

class TransportModeProvider extends ChangeNotifier {
  TravelMode _currentMode = TravelMode.walking;
  School? _selectedSchool;
  bool _isInitialized = false;

  TravelMode get currentMode => _currentMode;
  School? get selectedSchool => _selectedSchool;
  bool get isInitialized => _isInitialized;

  void setTravelMode(TravelMode mode) {
    _currentMode = mode;
    notifyListeners();
  }

  void setSelectedSchool(School? school) {
    _selectedSchool = school;
    notifyListeners();
  }

  void initialize(TravelMode mode, School? school) {
    _currentMode = mode;
    _selectedSchool = school;
    _isInitialized = true;
    notifyListeners();
  }

  void reset() {
    _currentMode = TravelMode.walking;
    _selectedSchool = null;
    _isInitialized = false;
    notifyListeners();
  }

  Color getModeColor() {
    switch (_currentMode) {
      case TravelMode.walking:
        return const Color(0xFF2196F3);
      case TravelMode.biking:
        return const Color(0xFFFF9800);
      case TravelMode.bus:
        return const Color(0xFFF44336);
      case TravelMode.driving:
        return const Color(0xFF4CAF50);
    }
  }

  IconData getModeIcon() {
    switch (_currentMode) {
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
}
