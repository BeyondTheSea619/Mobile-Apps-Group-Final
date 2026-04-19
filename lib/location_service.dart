import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

// this class handles getting the device location
// it checks permissions and GPS before trying to get position
class LocationService {
  // get current device location
  // main function that gets current location of the user
  // it also handle all the permission stuff automatically
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // check if GPS is enabled
    // first checking if GPS is turned on or not on the device
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // check permission
    permission = await Geolocator.checkPermission();

    // request permission if denied
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    // permanently denied case
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Permission permanently denied. Enable from settings.',
      );
    }

    try {
      // trying to get current position, if it takes too long then timeout
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      // fallback to last known position
      Position? lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        return lastKnown;
      }
      return Future.error('Could not get current location. Check emulator GPS settings.');
    }
  }
}