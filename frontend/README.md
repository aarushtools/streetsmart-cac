# StreetSmart - Safe Commute Assistant 🚶🚲🚌🚗

A Flutter mobile application for Fairfax County students and families to safely navigate to school using real-time crowdsourced data, hazard alerts, and multi-modal transportation support.

## 🎯 Mission

Supporting Rep. James Walkinshaw's Vision Zero initiative and pedestrian safety goals by providing a civic tech tool that reduces traffic injuries and promotes safe school routes in Fairfax County, Virginia.

## ✨ Key Features

- **Multi-Modal Transport:** Walking, Biking, School Bus, and Driving modes
- **Crowdsourced Wait Times:** Real-time school drop-off and pick-up wait times
- **Hazard Reporting:** Report and view safety hazards with categorization
- **Walking Groups:** Form groups for safer walks to school
- **Bike Infrastructure:** Find bike racks and Capital Bikeshare stations
- **Bus Tracking:** Integration with HereComesTheBus and WMATA
- **Community Comments:** Share tips and route suggestions

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (>=3.4.3)
- Google Maps API key
- Backend server running (see backend/README.md)

### Installation

1. **Install dependencies:**
```bash
cd frontend
flutter pub get
```

2. **Configure Google Maps:**
   - Get API key from [Google Cloud Console](https://console.cloud.google.com/)
   - Add to `android/app/src/main/AndroidManifest.xml` (replace `YOUR_API_KEY_HERE`)
   - For iOS, configure in `ios/Runner/AppDelegate.swift`

3. **Update backend URL in `lib/core/constants/api_endpoints.dart`:**
   - Android Emulator: `http://10.0.2.2:8000`
   - iOS Simulator: `http://localhost:8000`
   - Physical Device: `http://YOUR_COMPUTER_IP:8000`

4. **Run the app:**
```bash
flutter run
```

## 📱 User Flow

1. **Splash Screen** → Branding and initialization
2. **Transport Selection** → Choose school + transport mode
3. **Home Screen** → Interactive map with mode-specific features
4. **Quick Actions** → Access features based on travel mode

## 🏗️ Project Structure

```
lib/
├── core/
│   └── constants/          # App constants, API endpoints, theme
├── data/
│   ├── models/             # Data models (School, Hazard, WaitTime, etc.)
│   ├── repositories/       # Data access layer
│   └── services/           # API services
└── presentation/
    ├── providers/          # State management (Provider)
    ├── screens/            # App screens
    └── widgets/            # Reusable components
```

## 🔧 Technology Stack

- **Flutter** - Cross-platform framework
- **Provider** - State management
- **Google Maps Flutter** - Interactive maps
- **Geolocator** - Location services
- **Dio/HTTP** - Networking
- **Hive** - Local storage

## 📝 Important Notes

- **Google Maps API Key Required:** The app won't display maps without a valid API key
- **Backend Required:** The app connects to a Django backend for data
- **Permissions:** Location permissions required for full functionality


## 🌐 Backend Integration

This frontend connects to a Django backend with PostGIS for GIS data from OpenStreetMap. See `backend/README.md` for setup instructions.

## 📄 License

[Add appropriate license]

## 🙏 Acknowledgments

Built to support Vision Zero and pedestrian safety initiatives in Fairfax County, Virginia.
