import 'package:flutter/material.dart';
import 'dart:convert'; 

class Alarm {
  final int id;
  final TimeOfDay time;
  final DateTime date;
  final bool isActive;
  final String destination;

  Alarm({
    required this.id,
    required this.time,
    required this.date,
    this.isActive = true,
    required this.destination,
  });

  
  DateTime get scheduledTime {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }
  

  Alarm copyWith({
    bool? isActive,
  }) {
    return Alarm(
      id: id,
      time: time,
      date: date,
      isActive: isActive ?? this.isActive,
      destination: destination,
    );
  }

  

  factory Alarm.fromJson(Map<String, dynamic> json) {
    
    final int minutes = json['timeMinutes'] as int;
    final int hour = minutes ~/ 60;
    final int minute = minutes % 60;

    return Alarm(
      id: json['id'] as int,
      time: TimeOfDay(hour: hour, minute: minute),
      date: DateTime.parse(json['date'] as String),
      isActive: json['isActive'] as bool,
      destination: json['destination'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    
    final int timeMinutes = time.hour * 60 + time.minute;

    return {
      'id': id,
      'timeMinutes': timeMinutes,
      'date': date.toIso8601String(),
      'isActive': isActive,
      'destination': destination,
    };
  }

  

  static String encode(List<Alarm> alarms) => json.encode(
        alarms
            .map<Map<String, dynamic>>((alarm) => alarm.toJson())
            .toList(),
      );

  static List<Alarm> decode(String alarmsString) =>
      (json.decode(alarmsString) as List<dynamic>)
          .map<Alarm>((item) => Alarm.fromJson(item as Map<String, dynamic>))
          .toList();
}
