import 'package:flutter/material.dart';

class Hiker with ChangeNotifier {
  // ignore: non_constant_identifier_names
  int? hiker_id;
  final String hiker_first_name;
  final String hiker_last_name;
  final double? hiker_physical_weight;
  final int? hiker_age;
  final double? hiker_height_inch;
  final String hiker_natural_gender;
  final double? hiker_avg_speed_flat;
  final int? hiker_trips_completed;
  // final String Hiker_category;
  // final int Hiker_quantity;
  // final String Hiker_description;

  Hiker({
    this.hiker_id,
    required this.hiker_first_name,
    required this.hiker_last_name,
    required this.hiker_physical_weight,
    required this.hiker_age,
    required this.hiker_height_inch,
    required this.hiker_natural_gender,
    required this.hiker_avg_speed_flat,
    required this.hiker_trips_completed,
    // ignore: non_constant_identifier_names

    // required this.Hiker_quantity,
    //
    // required this.Hiker_description
  });

  factory Hiker.fromJson(Map<String, dynamic> json) {
    return Hiker(
        hiker_id: json['hiker_id'],
        hiker_age: json['hiker_age'],
        hiker_avg_speed_flat: json['hiker_avg_speed_flat'],
        hiker_first_name: json['hiker_first_name'],
        hiker_height_inch: json['hiker_height_inch'],
        hiker_last_name: json['hiker_last_name'],
        hiker_natural_gender: json['hiker_natural_gender'],
        hiker_trips_completed: json['hiker_trips_completed'],
        hiker_physical_weight: json['hiker_physical_weight']);

    // Hiker_category: json['Hiker_category'],
    // Hiker_quantity: json['Hiker_quantity'],
    // Hiker_description: json['Hiker_description'],
  }
  dynamic toJson() => {
        'hiker_id': hiker_id.toString(),
        'hiker_first_name': hiker_first_name,
        'hiker_last_name': hiker_last_name,
        'hiker_physical_weight': hiker_physical_weight,
        'hiker_age': hiker_age,
        'hiker_height_inch': hiker_height_inch,
        'hiker_natural_gender': hiker_natural_gender,
        'hiker_avg_speed_flat': hiker_avg_speed_flat,
        'hiker_trips_completed': hiker_trips_completed,
      };
}
