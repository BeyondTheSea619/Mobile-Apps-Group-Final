# 🏋️ My Fitness App

A premium, all-in-one health and fitness tracking application built with **Flutter**. Track your daily activities, monitor your weight, and stay on top of your hydration goals with a sleek, modern UI.

---

## ✨ Key Features

- **📊 Dynamic Dashboard**: A gradient-powered overview of your daily steps, burned calories, and distance.
- **📍 Real-time Map**: Integrated MapTiler services to track your current location and fitness routes.
- **📸 Custom Camera**: Capture and manage your profile photos directly within the app.
- **🏃 Activity Logging**: Detailed tracking for Walking, Running, Cycling, and Workouts with local database storage.
- **⚖️ Weight Tracker**: Monitor your weight history and automatically calculate your BMI.
- **💧 Smart Goals**: Custom settings for daily step and water intake goals with persistent storage.
- **🌓 Adaptive Design**: Premium aesthetics with rounded layouts and glassmorphism elements.

---

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **Database**: [SQLite](https://pub.dev/packages/sqflite) (local persistence for high performance)
- **State Management**: [SharedPreferences](https://pub.dev/packages/shared_preferences) (for app settings and user preferences)
- **Maps**: [Flutter Map](https://pub.dev/packages/flutter_map) + [Geolocator](https://pub.dev/packages/geolocator)
- **Imaging**: [Camera](https://pub.dev/packages/camera) API

---

## 📁 Project Structure

```text
lib/
├── database/         # SQLite initialization and CRUD operations
├── models/           # Data models (User, Activity, Weight)
├── screens/          # Application pages (Home, Map, Settings, etc.)
├── widgets/          # Reusable UI components (Result cards, Goal progress)
├── location_service.dart # Geolocation permission and fetching
└── main.dart         # Entry point and theme configuration
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Android Studio / VS Code
- A valid [MapTiler API Key](https://cloud.maptiler.com/)

### Installation
1. Register and get your API Key from MapTiler.
2. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/fitness-app.git
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Insert your API Key in `lib/screens/map_screen.dart`:
   ```dart
   const String apiKey = "YOUR_KEY_HERE";
   ```
5. Run the application:
   ```bash
   flutter run
   ```

---

## 📱 Permissions Required

- **Android**: `CAMERA`, `RECORD_AUDIO`, `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`.
- **iOS**: `NSCameraUsageDescription`, `NSLocationWhenInUseUsageDescription`, `NSMicrophoneUsageDescription`.

---

## 👤 Author
Developed as part of the Mobile Applications Final Project.

---
*Note: This app is optimized for mobile performance and uses high-accuracy location tracking.*
