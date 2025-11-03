import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../constants/app_constants.dart';

class AlarmScreen extends StatefulWidget {
  final String initialLocation;
  const AlarmScreen({super.key,required this.initialLocation});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  String _currentLocation = "Add your location";
  bool _isLoadingLocation = false;
  bool flag=false;

  List<Map<String, dynamic>> alarms = [];

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
    _currentLocation = widget.initialLocation;
    
  }
  Future<void> _fetchCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentLocation = "Location service disabled";
        _isLoadingLocation = false;
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _currentLocation = "Permission denied";
          _isLoadingLocation = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentLocation = "Permission permanently denied";
        _isLoadingLocation = false;
      });
      return;
    }

    
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      setState(() {
        _currentLocation =
            "${place.locality ?? place.subAdministrativeArea ?? 'Unknown City'}, ${place.country ?? ''}";
            flag=true;
      });
    } else {
      setState(() {
        _currentLocation = "Unknown location";
      });
    }

    setState(() {
      _isLoadingLocation = false;
    });
  }


  Future<void> _addNewAlarm() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: "Select Alarm Time",
    );

    if (pickedTime != null) {
      DateTime now = DateTime.now();
      DateTime alarmDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      setState(() {
        alarms.add({
          "time": pickedTime.format(context),
          "date":
              "${_formatDate(alarmDateTime)}", 
          "isActive": true,
        });
      });
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    const weekdays = [
      "Mon",
      "Tue",
      "Wed",
      "Thu",
      "Fri",
      "Sat",
      "Sun",
    ];
    return "${weekdays[date.weekday - 1]} ${date.day} ${months[date.month - 1]} ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.scaffoldColor,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 16),
        decoration: AppConstants.mainGradientBoxDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Location',
              style: AppConstants.subheadingStyle.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _fetchCurrentLocation,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppConstants.cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: AppConstants.primaryColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _isLoadingLocation
                            ? "Fetching current location..."
                            : _currentLocation,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Alarms',
              style: AppConstants.subheadingStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: alarms.isEmpty
                  ? const Center(
                      child: Text(
                        "No Alarms Set\nTap + to add one",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: alarms.length,
                      itemBuilder: (context, index) {
                        final alarm = alarms[index];
                        return _buildAlarmCard(
                          alarm["time"],
                          alarm["date"],
                          alarm["isActive"],
                          index,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: flag?_addNewAlarm: _fetchCurrentLocation,
        backgroundColor: const Color.fromARGB(255, 98, 69, 242),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAlarmCard(
      String time, String date, bool isActive, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 29, 27, 54),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              time,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ]),
          Switch(
            value: isActive,
            activeColor: AppConstants.primaryColor,
            onChanged: (value) {
              setState(() {
                alarms[index]["isActive"] = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
