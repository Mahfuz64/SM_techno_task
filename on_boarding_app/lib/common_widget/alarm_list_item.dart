import 'package:flutter/material.dart';

class AlarmModel {
  final int id;
  final TimeOfDay time;
  final DateTime date;
  final bool isActive;
  final String destination;

  AlarmModel({
    required this.id,
    required this.time,
    required this.date,
    this.isActive = true,
    required this.destination,
  });

  AlarmModel copyWith({
    bool? isActive,
  }) {
    return AlarmModel(
      id: id,
      time: time,
      date: date,
      isActive: isActive ?? this.isActive,
      destination: destination,
    );
  }
}
