import 'package:flutter/material.dart';
import 'package:frontend/BottomTrav.dart';
import 'package:frontend/color_schemes.g.dart';
import 'package:frontend/layout.dart';
import 'package:intl/intl.dart' as intl;
import 'package:frontend/api/api.dart';
import 'package:frontend/models/trip.dart';
import 'package:provider/provider.dart';

class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);

  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  // final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image:
                        NetworkImage("https://goo.gl/maps/piYutJ1odjW8SpQf8"),
                    fit: BoxFit.cover,
                  ),
                ))));
  }
}
