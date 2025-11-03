import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'package:on_boarding_app/features/alarms/alarm_screen.dart';
import '../../constants/app_constants.dart';

class LocationScreen extends StatefulWidget {
  
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String? _selectedLocation;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLocation = prefs.getString(AppConstants.locationKey);
    });
  }

  
  Future<String> _getCurrentCityName() async {
    bool serviceEnabled;
    LocationPermission permission;

    
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return 'Location services are disabled.';
    }

    
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'Location permission denied.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return 'Location permission permanently denied.';
    }

    
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      String city =
          place.locality ?? place.subAdministrativeArea ?? 'Unknown City';
      return city;
    } else {
      return 'Unknown Location';
    }
  }

  Future<void> _saveLocationAndNavigate(String location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.locationKey, location);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AlarmScreen(initialLocation: location),
        ),
      );
    }
  }

  
  Future<void> _handleCurrentLocation() async {
    setState(() => _isSaving = true);

    String cityName = await _getCurrentCityName();

    if (cityName.contains('denied') || cityName.contains('disabled')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(cityName)),
      );
    } else {
      await _saveLocationAndNavigate(cityName);
    }

    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: AppConstants.mainGradientBoxDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome! Your Smart Travel System',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Stay on schedule and enjoy every moment of your journey.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 40),
            Image.asset(
              'assets/location_bus.jpg',
              height: 200,
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                height: 200,
                child: Center(
                  child: Icon(Icons.location_on, size: 80, color: Colors.white54),
                ),
              ),
            ),
            const SizedBox(height: 40),

            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _handleCurrentLocation,
                icon: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location),
                label: const Text('Use Current Location'),
                style: AppConstants.primaryButtonStyle,
              ),
            ),
            const SizedBox(height: 20),

            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving
                    ? null
                    : () => _saveLocationAndNavigate('Home'),
                child: const Text('Home'),
                style: AppConstants.secondaryButtonStyle,
              ),
            ),
            const SizedBox(height: 20),

            if (_selectedLocation != null)
              Text(
                'Saved Location: $_selectedLocation',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
