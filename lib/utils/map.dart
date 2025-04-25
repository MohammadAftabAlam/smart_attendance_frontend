import 'dart:math';

import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();

  Future<bool> checkCollegeLocation() async {
    try {
      // Enable location services if not enabled
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return false;
      }

      // Check location permission
      PermissionStatus permission = await _location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await _location.requestPermission();
        if (permission != PermissionStatus.granted) return false;
      }

      // Get current location
      final locationData = await _location.getLocation();

      // College coordinates (replace with your college's actual coordinates)
      const double collegeLat = 12.9716;
      const double collegeLng = 77.5946;

      // Check if user is within 100 meters of college
      return _calculateDistance(
          locationData.latitude!,
          locationData.longitude!,
          collegeLat,
          collegeLng
      ) < 100;
    } catch (e) {
      print("Location error: $e");
      return false;
    }
  }

  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    // Haversine formula to calculate distance in meters
    const R = 6371e3; // Earth radius in meters
    final phi1 = lat1 * pi / 180;
    final phi2 = lat2 * pi / 180;
    final deltaPhi = (lat2 - lat1) * pi / 180;
    final deltaLambda = (lng2 - lng1) * pi / 180;

    final a = pow(sin(deltaPhi / 2),2) + cos(phi1) * cos(phi2) * pow(sin(deltaLambda / 2),2);
   final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }
}