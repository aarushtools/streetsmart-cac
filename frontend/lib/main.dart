import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streetsmart/core/constants/theme_constants.dart';
import 'package:streetsmart/presentation/providers/transport_mode_provider.dart';
import 'package:streetsmart/presentation/providers/navigation_provider.dart';
import 'package:streetsmart/presentation/screens/splash/splash_screen.dart';
import 'package:streetsmart/presentation/screens/transport_selection/transport_selection_screen.dart';
import 'package:streetsmart/presentation/screens/home/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StreetSmartApp());
}

class StreetSmartApp extends StatelessWidget {
  const StreetSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
  ChangeNotifierProvider(create: (_) => TransportModeProvider()),
  ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: MaterialApp(
        title: 'StreetSmart',
        debugShowCheckedModeBanner: false,
        theme: ThemeConstants.lightTheme,
        home: const SplashScreen(),
        routes: {
          '/transport-selection': (context) => const TransportSelectionScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
