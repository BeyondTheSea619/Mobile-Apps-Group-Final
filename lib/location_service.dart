import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  // get current device location
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // check if GPS is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // check permission
    permission = await Geolocator.checkPermission();
    debugPrint("Permission: $permission");

    // request permission if denied
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      debugPrint("Updated Permission: $permission");

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    // permanently denied case
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return Future.error(
        'Permission permanently denied. Enable from settings.',
      );
    }

    // return current position
    return await Geolocator.getCurrentPosition();
  }
}