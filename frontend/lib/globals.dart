library globals;

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:frontend/BottomTrav.dart';
import 'package:frontend/color_schemes.g.dart';
import 'package:frontend/hikerList.dart';
import 'package:frontend/layout.dart';
import 'package:frontend/tripView.dart';
import 'package:intl/intl.dart' as intl;
import 'package:frontend/api/api.dart';
import 'package:frontend/models/trip.dart';
import 'package:provider/provider.dart';

import '../models/hiker.dart';
import 'package:frontend/models/trip.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'api/MealPlanProviders.dart';
import 'api/api.dart';

bool activeTrip = true;
int? tripID = 4;
final List<dynamic> hikers = [];

class GlobalVariable extends StatefulWidget {
  const GlobalVariable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => TripProvider()),
        ChangeNotifierProvider(create: (_) => HikerProvider()),
        ChangeNotifierProvider(create: (_) => MealProvider()),
        ChangeNotifierProvider(create: (_) => FoodItemProvider()),
        ChangeNotifierProvider(create: (_) => ItemQuantityProvider()),
        ChangeNotifierProvider(create: (_) => MealDayProvider()),
        ChangeNotifierProvider(create: (_) => MealScheduleProvider()),
        ChangeNotifierProvider(create: (_) => MealPlanProvider()),
      ],
    );
  }

  _GlobalVariableState createState() => _GlobalVariableState();
}

class _GlobalVariableState extends State<GlobalVariable> {
  //final int tripId;
  //const _GlobalVariableState({super.key});

  @override
  void initState() {
    super.initState();

    final tripP = Provider.of<TripProvider>(context, listen: false);
    print("Trip num: ${tripP.trips.length}");

    var trip = tripP.trips
        .firstWhereOrNull((element) => element.trip_hikers == [hikers]);

    @override
    void dispose() {
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      // TODO: implement build
      throw UnimplementedError();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
