import 'package:flutter/material.dart';
import 'package:streetsmart/core/constants/theme_constants.dart';

class SubmitWaitTimeScreen extends StatefulWidget {
  const SubmitWaitTimeScreen({super.key});

  @override
  State<SubmitWaitTimeScreen> createState() => _SubmitWaitTimeScreenState();
}

class _SubmitWaitTimeScreenState extends State<SubmitWaitTimeScreen> {
  final _formKey = GlobalKey<FormState>();
  int _waitMinutes = 5;
  String _location = 'Main drop-off';
  String _transportMode = 'driving';

  final List<String> _locations = [
    'Main drop-off',
    'Side entrance',
    'Bus loop',
    'Bike racks',
    'Crosswalk entrance',
  ];

  final Map<String, IconData> _modes = {
    'walking': Icons.directions_walk,
    'biking': Icons.directions_bike,
    'bus': Icons.directions_bus,
    'driving': Icons.directions_car,
  };

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      // In a real app, this would submit to backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wait time reported! Thank you for contributing.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Wait Time'),
        backgroundColor: ThemeConstants.primaryColor,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Help the community by reporting current wait times',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            
            // Transport Mode Selection
            const Text(
              'Transport Mode',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: _modes.entries.map((entry) {
                final isSelected = _transportMode == entry.key;
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(entry.value, size: 18),
                      const SizedBox(width: 4),
                      Text(entry.key),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _transportMode = entry.key;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Location Dropdown
            const Text(
              'Location',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _location,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              items: _locations.map((location) {
                return DropdownMenuItem(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _location = value!;
                });
              },
            ),
            const SizedBox(height: 24),

            // Wait Time Slider
            const Text(
              'Wait Time',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '$_waitMinutes minutes',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: ThemeConstants.primaryColor,
                      ),
                    ),
                    Slider(
                      value: _waitMinutes.toDouble(),
                      min: 0,
                      max: 30,
                      divisions: 30,
                      label: '$_waitMinutes min',
                      onChanged: (value) {
                        setState(() {
                          _waitMinutes = value.toInt();
                        });
                      },
                    ),
                    const Text(
                      '0 min                                    30 min',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            ElevatedButton(
              onPressed: _submitReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeConstants.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Submit Report',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
