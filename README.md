<h1 align="center">
  <br>
  Fit Watch
  <br>
</h1>

<h4 align="center">An all-in-one health and fitness tracking application built with <a href="https://flutter.dev" target="_blank">Flutter</a>.</h4>

<p align="center">
  <a href="#key-features">Key Features</a> •
  <a href="#tech-stack">Tech Stack</a> •
  <a href="#how-to-use">How To Use</a> •
  <a href="#project-structure">Project Structure</a> •
  <a href="#permissions-required">Permissions</a> 
</p>

---

## Key Features

- **Dynamic Dashboard:** A clean overview of your daily steps, burned calories, and covered distance.
- **Real-time Location Mapping:** We integrated MapTiler services and Geolocator so you can track your current location and fitness routes on an interactive map.
- **Custom Profile Capture:** Use your phone's camera right inside the app to capture and manage your profile photos.
- **Detailed Activity Logging:** Log your walks, runs, cycling sessions, and custom workouts. Everything is safely stored locally so it's snappy and reliable.
- **Weight Tracker & Analytics:** Keep an eye on your weight history. The app automatically calculates important metrics like your BMI for you.
- **Reliable Data Input:** We use `reactive_forms` under the hood. This means your data is validated instantly, preventing annoying bugs and ensuring nothing gets lost.
- **Smart Goals:** Set customizable goals for daily steps and water limits. The app remembers your choices.
- **Adaptive Design:** A modern, clean user interface that feels right at home on your device.

---

## Tech Stack

This project uses the following key technologies:

- **Framework:** [Flutter](https://flutter.dev/) for cross-platform visual consistency.
- **Database:** [SQLite](https://pub.dev/packages/sqflite) for fast, local data storage.
- **Preferences:** [SharedPreferences](https://pub.dev/packages/shared_preferences) to keep track of user settings.
- **Form Management:** [Reactive Forms](https://pub.dev/packages/reactive_forms) to handle user inputs smoothly.
- **Location Services:** [Flutter Map](https://pub.dev/packages/flutter_map) alongside [Geolocator](https://pub.dev/packages/geolocator) and `latlong2`.
- **Camera integration:** [Camera](https://pub.dev/packages/camera) API.

---

## Project Structure

```text
lib/
├── database/            # SQLite tables mapping, initialization, and data operations
├── models/              # System Data Models (User, Activity, Weight, Forms)
├── screens/             # Application UI pages (Home, Map, Settings, etc.)
├── widgets/             # Reusable UI components (Result cards, Goal progress bars)
├── location_service.dart# Geolocation permissions and logic
└── main.dart            # Standard entry point and theme configuration
```

---

## How To Use

### Prerequisites

To clone and run this application, you will need the [Flutter SDK](https://flutter.dev/docs/get-started/install) installed on your system. You will also need an IDE (like VS Code or Android Studio) and a valid [MapTiler API Key](https://cloud.maptiler.com/).

### Installation

1. Clone the repository to your local machine.
2. Open your terminal and navigate to the application directory:
   ```bash
   cd fit-watch-app
   ```
3. Fetch the required dependencies:
   ```bash
   flutter pub get
   ```
4. Configure your map by inserting your API Key in `lib/screens/map_screen.dart`:
   ```dart
   const String apiKey = "YOUR_KEY_HERE";
   ```
5. Run the app:
   ```bash
   flutter run
   ```

---

## Permissions Required

Fit Watch integrates closely with your device's hardware. You will need to ensure the following permissions are granted when prompted:

### Android
These permissions are required in your `AndroidManifest.xml`:
- `CAMERA`, `RECORD_AUDIO`
- `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`

### iOS
These native strings are required in your `Info.plist` file:
- `NSCameraUsageDescription`
- `NSLocationWhenInUseUsageDescription`
- `NSMicrophoneUsageDescription`

---
**Note:** This application was developed as part of the Mobile Applications Final Project. It focuses heavily on mobile performance, reliable local database structuring, and hardware connectivity.
