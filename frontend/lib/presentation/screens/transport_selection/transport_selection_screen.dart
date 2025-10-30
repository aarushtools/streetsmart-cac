import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streetsmart/core/constants/theme_constants.dart';
import 'package:streetsmart/data/models/transport_mode.dart';
import 'package:streetsmart/data/models/school_model.dart';
import 'package:streetsmart/presentation/providers/transport_mode_provider.dart';
import 'package:streetsmart/presentation/screens/transport_selection/widgets/transport_mode_card.dart';
import 'package:streetsmart/presentation/screens/transport_selection/widgets/school_selector.dart';

class TransportSelectionScreen extends StatefulWidget {
  const TransportSelectionScreen({super.key});

  @override
  State<TransportSelectionScreen> createState() => _TransportSelectionScreenState();
}

class _TransportSelectionScreenState extends State<TransportSelectionScreen> {
  TravelMode? _selectedMode;
  School? _selectedSchool;
  
  // Mock school data - in production this would come from backend
  final List<School> _mockSchools = [
    School(
      id: '1',
      name: 'Thomas Jefferson High School',
      latitude: 38.8189,
      longitude: -77.1689,
      address: '6560 Braddock Rd, Alexandria, VA 22312',
      type: 'high',
    ),
    School(
      id: '2',
      name: 'Weyanoke Elementary School',
      latitude: 38.8180,
      longitude: -77.1885,
      address: '6520 Braddock Rd, Alexandria, VA 22312',
      type: 'Elem',
    )
  ];

  void _onModeSelected(TravelMode mode) {
    setState(() {
      _selectedMode = mode;
    });
  }

  void _onSchoolSelected(School? school) {
    setState(() {
      _selectedSchool = school;
    });
  }

  void _continue() {
    if (_selectedMode != null && _selectedSchool != null) {
      final provider = Provider.of<TransportModeProvider>(context, listen: false);
      provider.initialize(_selectedMode!, _selectedSchool);
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(ThemeConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Welcome to StreetSmart!',
                style: ThemeConstants.heading1,
              ),
              const SizedBox(height: 12),
              const Text(
                'Let\'s set up your safe commute',
                style: ThemeConstants.bodyLarge,
              ),
              const SizedBox(height: 40),
              
              // School Selection
              const Text(
                'Which school are you going to?',
                style: ThemeConstants.heading3,
              ),
              const SizedBox(height: 16),
              SchoolSelector(
                schools: _mockSchools,
                selectedSchool: _selectedSchool,
                onSchoolSelected: _onSchoolSelected,
              ),
              
              const SizedBox(height: 40),
              
              // Transport Mode Selection
              const Text(
                'How are you getting there today?',
                style: ThemeConstants.heading3,
              ),
              const SizedBox(height: 16),
              
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.0,
                children: [
                  TransportModeCard(
                    mode: TravelMode.walking,
                    isSelected: _selectedMode == TravelMode.walking,
                    onTap: () => _onModeSelected(TravelMode.walking),
                  ),
                  TransportModeCard(
                    mode: TravelMode.biking,
                    isSelected: _selectedMode == TravelMode.biking,
                    onTap: () => _onModeSelected(TravelMode.biking),
                  ),
                  TransportModeCard(
                    mode: TravelMode.bus,
                    isSelected: _selectedMode == TravelMode.bus,
                    onTap: () => _onModeSelected(TravelMode.bus),
                  ),
                  TransportModeCard(
                    mode: TravelMode.driving,
                    isSelected: _selectedMode == TravelMode.driving,
                    onTap: () => _onModeSelected(TravelMode.driving),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: (_selectedMode != null && _selectedSchool != null)
                      ? _continue
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeConstants.primaryColor,
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusMedium),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
