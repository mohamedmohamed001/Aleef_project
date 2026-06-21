import 'package:aleef/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class PickLocationResult {
  final double latitude;
  final double longitude;

  const PickLocationResult({
    required this.latitude,
    required this.longitude,
  });
}

class PickLocationScreen extends StatefulWidget {
  const PickLocationScreen({super.key});

  @override
  State<PickLocationScreen> createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  final MapController _mapController = MapController();

  static const LatLng _defaultLocation = LatLng(30.0444, 31.2357); // Cairo

  LatLng _selectedLocation = _defaultLocation;

  bool _isLoading = true;
  bool _hasPickedLocation = false;

  String? _message =
      'Tap on the map to choose your clinic location, or allow location access to detect it automatically.';

  bool _isValidLatLng(double? lat, double? lng) {
    if (lat == null || lng == null) return false;
    if (lat.isNaN || lng.isNaN) return false;
    if (lat.isInfinite || lng.isInfinite) return false;
    if (lat < -90 || lat > 90) return false;
    if (lng < -180 || lng > 180) return false;
    return true;
  }

  LatLng _safeLatLng(double? lat, double? lng) {
    if (_isValidLatLng(lat, lng)) {
      return LatLng(lat!, lng!);
    }

    return _defaultLocation;
  }

  bool _isValidPoint(LatLng point) {
    return _isValidLatLng(point.latitude, point.longitude);
  }

  @override
  void initState() {
    super.initState();

    _isLoading = false;
    _message =
    'Tap on the map to choose your clinic location, or press the location button to use your current location.';
  }

  Future<void> _initLocation() async {
    try {
      setState(() {
        _message =
        'Tap on the map to choose your clinic location, or allow location access to detect it automatically.';
      });

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _message =
          'Location service is turned off. You can still tap on the map to choose your clinic location manually.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        final shouldAskPermission = await _showLocationPermissionInfoDialog();

        if (!shouldAskPermission) {
          if (!mounted) return;
          setState(() {
            _isLoading = false;
            _message = 'Tap on the map to choose your clinic location manually.';
          });
          return;
        }

        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _message =
          'Location permission was denied. You can still tap on the map to choose your clinic location manually.';
        });
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _message =
          'Location permission is permanently denied. Please enable it from settings or choose your clinic location manually.';
        });

        _showOpenSettingsDialog();
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final currentLocation = _safeLatLng(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;
      setState(() {
        _selectedLocation = currentLocation;
        _hasPickedLocation = true;
        _isLoading = false;
        _message = null;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_isValidPoint(currentLocation)) {
          _mapController.move(currentLocation, 15);
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _message =
        'Could not detect your current location. Tap on the map to choose your clinic location manually.';
      });
    }
  }

  Future<void> _goToCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please turn on location service first'),
          ),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        final shouldAskPermission = await _showLocationPermissionInfoDialog();

        if (!shouldAskPermission) return;

        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission denied'),
          ),
        );
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        _showOpenSettingsDialog();
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 8),
      );

      final currentLocation = _safeLatLng(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;
      setState(() {
        _selectedLocation = currentLocation;
        _hasPickedLocation = true;
        _message = null;
      });

      if (_isValidPoint(currentLocation)) {
        _mapController.move(currentLocation, 16);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not get current location'),
        ),
      );
    }
  }

  Future<bool> _showLocationPermissionInfoDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: AppColors.primary,
              ),
              SizedBox(width: 8.w),
              const Expanded(
                child: Text('Allow Location Access'),
              ),
            ],
          ),
          content: const Text(
            'ALEEF needs your location to help you select your clinic location faster. '
                'You can also choose the location manually from the map.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Choose manually'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Allow'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  void _showOpenSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: const Text('Location Permission Required'),
          content: const Text(
            'Location permission is permanently denied. Please enable it from app settings, '
                'or choose your clinic location manually from the map.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Choose manually'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                Navigator.pop(context);
                await Geolocator.openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  void _confirmLocation() {
    if (!_hasPickedLocation || !_isValidPoint(_selectedLocation)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your clinic location first'),
        ),
      );
      return;
    }

    Navigator.pop(
      context,
      PickLocationResult(
        latitude: _selectedLocation.latitude,
        longitude: _selectedLocation.longitude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final LatLng safeSelectedLocation = _isValidPoint(_selectedLocation)
        ? _selectedLocation
        : _defaultLocation;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F7),
      appBar: AppBar(
        title: Text(
          'Pick Clinic Location',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black87,
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: safeSelectedLocation,
              initialZoom: 15,
              minZoom: 3,
              maxZoom: 18,
              onTap: (tapPosition, point) {
                if (!_isValidPoint(point)) return;

                setState(() {
                  _selectedLocation = point;
                  _hasPickedLocation = true;
                  _message = null;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.aleef',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: safeSelectedLocation,
                    width: 52.w,
                    height: 52.h,
                    child: Icon(
                      Icons.location_on_rounded,
                      color: AppColors.primary,
                      size: 44.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),

          if (_isLoading)
            Container(
              color: Colors.white.withOpacity(0.75),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),

          if (_message != null && !_isLoading)
            Positioned(
              top: 14.h,
              left: 16.w,
              right: 16.w,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 12.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Text(
                  _message!,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

          Positioned(
            right: 16.w,
            bottom: 100.h,
            child: FloatingActionButton(
              heroTag: 'current_location_btn',
              backgroundColor: Colors.white,
              elevation: 5,
              onPressed: _goToCurrentLocation,
              child: Icon(
                Icons.my_location_rounded,
                color: AppColors.primary,
                size: 23.sp,
              ),
            ),
          ),

          Positioned(
            left: 16.w,
            right: 16.w,
            bottom: 24.h,
            child: SizedBox(
              height: 56.h,
              child: ElevatedButton.icon(
                onPressed: _confirmLocation,
                icon: Icon(
                  Icons.check_circle_outline_rounded,
                  size: 19.sp,
                ),
                label: Text(
                  'Confirm Location',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}