import 'package:intl/intl.dart';

class Trip {
  // ignore: non_constant_identifier_names
  int? trip_id;
  final String trip_name;
  final List<dynamic>? trip_hikers;
  final DateTime trip_plan_start_datetime;
  final DateTime trip_plan_end_datetime;
  final bool? trip_is_active;
  final bool? trip_is_complete;
  // final String Trip_category;
  // final int Trip_quantity;
  // final String Trip_description;

  Trip({
    this.trip_hikers,
    required this.trip_name,
    required this.trip_plan_start_datetime,
    required this.trip_plan_end_datetime,
    required this.trip_is_active,
    required this.trip_is_complete,
    // ignore: non_constant_identifier_names
    this.trip_id,
    // required this.Trip_quantity,
    //
    // required this.Trip_description
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
        trip_id: json['trip_id'],
        trip_name: json['trip_name'],
        trip_plan_start_datetime:
            DateTime.parse(json['trip_plan_start_datetime'].toString()),
        trip_hikers: json['trip_hikers'],
        trip_is_active: json['trip_is_active'],
        trip_is_complete: json['trip_is_complete'],
        trip_plan_end_datetime:
            DateTime.parse(json['trip_plan_end_datetime'].toString()));

    // Trip_quantity: json['Trip_quantity'],
    // Trip_description: json['Trip_description'],
  }
  dynamic toJson() => {
        'trip_id': trip_id,
        'trip_name': trip_name,
        'trip_plan_start_datetime': trip_plan_start_datetime.toString(),
        'trip_plan_end_datetime': trip_plan_end_datetime.toString(),
        'trip_hikers': trip_hikers,
        'trip_is_active': trip_is_active,
        'trip_is_complete': trip_is_complete
      };
}
