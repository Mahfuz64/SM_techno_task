import 'package:geolocator/geolocator.dart';

class LocationHelper {
  
  static Future<LocationPermission> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return permission;
      }
    }
    return permission;
  }

  
  static Future<Position> getCurrentPosition() async {
    final permission = await handleLocationPermission();

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } else {
      throw Exception('Location permissions not granted.');
    }
  }
}