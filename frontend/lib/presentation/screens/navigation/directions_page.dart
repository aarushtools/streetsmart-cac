import 'package:flutter/material.dart';
import 'package:streetsmart/core/constants/theme_constants.dart';

class DirectionsPage extends StatelessWidget {
  const DirectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = <_DirectionStep>[
      _DirectionStep(header: '1 min (0.1 mile)', subheader: 'via Minor Ln', badge: 'Safest Route', location: 'Your location'),
      _DirectionStep(stepTitle: 'Head southeast', distance: '141 ft'),
      _DirectionStep(stepTitle: 'Turn left toward Minor Ln', distance: '177 ft'),
      _DirectionStep(stepTitle: 'Turn left onto Minor Ln', distance: '289 ft', note: ' Destination will be on the left'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Directions'),
        backgroundColor: ThemeConstants.walkingColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(steps[0].header ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(steps[0].subheader ?? '', style: const TextStyle(color: Colors.black54)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(steps[0].badge ?? '', style: const TextStyle(color: Colors.black54)),
                        Text(steps[0].location ?? '', style: const TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: steps.length - 1,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final s = steps[index + 1];
                  return ListTile(
                    title: Text(s.stepTitle ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (s.note != null) Text(s.note!, style: const TextStyle(color: Colors.black54)),
                        if (s.distance != null) Text(s.distance!, style: const TextStyle(color: Colors.black54)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DirectionStep {
  final String? header;
  final String? subheader;
  final String? badge;
  final String? location;
  final String? stepTitle;
  final String? distance;
  final String? note;

  _DirectionStep({this.header, this.subheader, this.badge, this.location, this.stepTitle, this.distance, this.note});
}
