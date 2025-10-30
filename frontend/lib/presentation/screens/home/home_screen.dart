import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streetsmart/core/constants/theme_constants.dart';
import 'package:streetsmart/presentation/providers/transport_mode_provider.dart';
import 'package:streetsmart/presentation/providers/navigation_provider.dart';
import 'package:streetsmart/presentation/screens/home/widgets/map_widget.dart';
import 'package:streetsmart/presentation/screens/home/widgets/mode_indicator.dart';
import 'package:streetsmart/presentation/screens/home/widgets/quick_actions_bar.dart';
import 'package:streetsmart/presentation/screens/home/widgets/safety_score_card.dart';
import 'package:streetsmart/presentation/screens/wait_times/wait_times_screen.dart';
import 'package:streetsmart/presentation/screens/wait_times/submit_wait_time_screen.dart';
import 'package:streetsmart/presentation/screens/hazards/hazards_page.dart';
import 'package:streetsmart/presentation/screens/community/community_hub_screen.dart';
import 'package:streetsmart/presentation/screens/community/add_comment_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to corresponding screens
    switch (index) {
      case 0: // Map
        // Already on home screen, do nothing
        break;
      case 1: // Wait Times
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const WaitTimesScreen()),
        );
        break;
      case 2: // Hazards
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const HazardsPage()),
        );
        break;
      case 3: // Community
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CommunityHubScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransportModeProvider>(context);
    
    return Scaffold(
      body: Stack(
        children: [
          // Map Widget (full screen)
          const MapWidget(),
          
          // Top overlay with mode indicator
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ModeIndicator(
                      mode: provider.currentMode,
                      school: provider.selectedSchool,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Safety Score Card (top overlay, dismissible)
          Positioned(
            top: 72,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Consumer<NavigationProvider>(
                builder: (context, nav, _) {
                  if (!nav.showSafetyCard || nav.safetyScore == null) {
                    return const SizedBox.shrink();
                  }
                  return const SafetyScoreCard();
                },
              ),
            ),
          ),
          
          // Bottom overlay with quick actions
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                QuickActionsBar(
                  mode: provider.currentMode,
                ),
                const SizedBox(height: 80), // Space for bottom navigation
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Wait Times',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Hazards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.comment),
            label: 'Community',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: provider.getModeColor(),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showReportDialog(context);
        },
        backgroundColor: provider.getModeColor(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _showReportDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(ThemeConstants.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Report',
              style: ThemeConstants.heading3,
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.access_time, color: ThemeConstants.primaryColor),
              title: const Text('Report Wait Time'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SubmitWaitTimeScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.warning, color: ThemeConstants.warningColor),
              title: const Text('Report Hazard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const HazardsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.comment, color: ThemeConstants.successColor),
              title: const Text('Add Comment'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddCommentScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
