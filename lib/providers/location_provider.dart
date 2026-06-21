import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  double? lat;
  double? lng;

  bool isLoadingLocation = false;
  String? locationError;

  bool get hasLocation => lat != null && lng != null;

  Future<void> getUserLocation({
    bool requestPermission = false,
  }) async {
    debugPrint('GET USER LOCATION CALLED');

    if (isLoadingLocation) return;

    isLoadingLocation = true;
    locationError = null;
    notifyListeners();

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      debugPrint('PERMISSION BEFORE REQUEST => $permission');

      if (permission == LocationPermission.denied && requestPermission) {
        permission = await Geolocator.requestPermission();
        debugPrint('PERMISSION AFTER REQUEST => $permission');
      }

      if (permission == LocationPermission.denied) {
        locationError = 'Location permission is required to find nearby clinics';
        isLoadingLocation = false;
        notifyListeners();
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        locationError =
        'Location permission is blocked. Please enable it from app settings.';
        isLoadingLocation = false;
        notifyListeners();
        return;
      }

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      debugPrint('LOCATION SERVICE ENABLED => $serviceEnabled');

      if (!serviceEnabled) {
        locationError = 'Please turn on your device location';
        isLoadingLocation = false;
        notifyListeners();
        return;
      }

      final lastKnownPosition = await Geolocator.getLastKnownPosition();

      if (lastKnownPosition != null) {
        lat = lastKnownPosition.latitude;
        lng = lastKnownPosition.longitude;

        debugPrint('USER LAT FROM LAST KNOWN => $lat');
        debugPrint('USER LNG FROM LAST KNOWN => $lng');

        isLoadingLocation = false;
        notifyListeners();
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 15),
      );

      lat = position.latitude;
      lng = position.longitude;

      debugPrint('USER LAT FROM CURRENT => $lat');
      debugPrint('USER LNG FROM CURRENT => $lng');
    } catch (e) {
      locationError = 'Could not get user location';
      debugPrint('Get user location error: $e');
    }

    isLoadingLocation = false;
    notifyListeners();
  }

  Future<void> refreshLocation({
    bool requestPermission = false,
  }) async {
    lat = null;
    lng = null;
    locationError = null;
    notifyListeners();

    await getUserLocation(
      requestPermission: requestPermission,
    );
  }

  void clearLocation() {
    lat = null;
    lng = null;
    locationError = null;
    isLoadingLocation = false;
    notifyListeners();
  }

  Future<bool> checkLocationServiceAndClearIfOff() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    debugPrint('CHECK LOCATION SERVICE ENABLED => $serviceEnabled');

    if (!serviceEnabled) {
      lat = null;
      lng = null;
      locationError = 'Please turn on your device location';
      isLoadingLocation = false;
      notifyListeners();
      return false;
    }

    return true;
  }
}