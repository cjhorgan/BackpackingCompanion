import 'package:flutter/material.dart';
import 'package:frontend/api/api.dart';
import 'package:frontend/mealplan.dart';
import 'package:frontend/models/hiker.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/screens/createTrip.dart';
import 'package:frontend/screens/profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/mealplan.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'Inventory.dart';
import 'color_schemes.g.dart';
import 'tripView.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geojson/geojson.dart';
import 'package:map_elevation/map_elevation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_dragmarker/dragmarker.dart';
import 'package:flutter_map_line_editor/polyeditor.dart';

import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

import 'elevationData/kelsoElevation.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
    this.hiker,
    this.trip,
  }) : super(key: key);

  final Hiker? hiker;
  final Trip? trip;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic>? getHikers = [];

  final List<String> _filters = <String>[];
  @override
  Widget build(BuildContext context) {
    final tripP = Provider.of<TripProvider>(context);

    DateTime today = DateTime.now();
    DateTime time = DateTime.now();
    String formattedDate = DateFormat.MMMMEEEEd().format(today);
    String formattedTime = DateFormat.jm().format(today);
    final hiker = ModalRoute.of(context)!.settings.arguments as Hiker;
    final tripstart = tripP.getTrip(2).trip_plan_start_datetime;
    final tripEnd = tripP.getTrip(2).trip_plan_end_datetime;
    String tripstartDate = DateFormat.MMMd().format(tripstart);
    String tripEndDate = DateFormat.MMMd().format(tripEnd);

    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(formattedDate,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w400,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(-5.0, 5.0),
                    blurRadius: 2.0,
                    color: darkColorScheme.shadow,
                  ),
                ],
              )),
          Text(formattedTime,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(-5.0, 5.0),
                    blurRadius: 2.0,
                    color: darkColorScheme.shadow,
                  ),
                ],
              )),
          Container(
              padding: EdgeInsets.all(10),
              child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  elevation: 10,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text(tripP.getTrip(89).trip_name,
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w400,
                                          shadows: <Shadow>[
                                            Shadow(
                                              offset: Offset(-1.0, 1.0),
                                              blurRadius: 2.0,
                                              color: darkColorScheme.shadow,
                                            ),
                                          ],
                                        ))),
                                Stack(
                                    alignment: const Alignment(0, -1),
                                    children: [
                                      Icon(
                                        Icons.forest,
                                        size: 30,
                                        color: darkColorScheme.primary,
                                      ),
                                      IconButton(
                                        alignment: const Alignment(3, -3),
                                        icon: const Icon(
                                          Icons.add,
                                          size: 20,
                                        ),
                                        color: darkColorScheme.primary,
                                        tooltip: 'Increase volume by 10',
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FormWidgetsDemo(
                                                        hiker: hiker,
                                                      ),
                                                  settings: RouteSettings(
                                                      arguments: hiker)));
                                        },
                                      ),
                                    ])
                              ]),
                          // LinearProgressIndicator(
                          //   value: .5,
                          //   semanticsLabel: 'Linear progress indicator',
                          // ),

                          Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                              ),
                              elevation: 20,
                              child: Container(
                                  height: 150,
                                  decoration: const BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12)),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            'https://tile.openstreetmap.org/10/37/119.png'),
                                        fit: BoxFit.cover,
                                      )))),
                          Padding(padding: EdgeInsets.all(10)),
                          Divider(),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(tripstartDate,
                                    style: TextStyle(
                                      color: darkColorScheme.onSurface,
                                      fontSize: 20,
                                    )),
                                Text("To",
                                    style: TextStyle(
                                      color: darkColorScheme.onSurface,
                                      fontSize: 20,
                                    )),
                                Text(tripEndDate,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(-1.0, 1.0),
                                          blurRadius: 2.0,
                                          color: darkColorScheme.shadow,
                                        ),
                                      ],
                                    ))
                              ]),

                          Padding(padding: EdgeInsets.all(10)),
                          LinearProgressIndicator(
                            value: .5,
                            semanticsLabel: 'Linear progress indicator',
                          ),
                          Padding(padding: EdgeInsets.all(10)),

                          // Container(
                          //     margin: EdgeInsets.only(left: 5),
                          //     child: Text("Group",
                          //         style: TextStyle(
                          //           fontSize: 25,
                          //           fontWeight: FontWeight.w400,
                          //           shadows: <Shadow>[
                          //             Shadow(
                          //               offset: Offset(-1.0, 1.0),
                          //               blurRadius: 2.0,
                          //               color: darkColorScheme.shadow,
                          //             ),
                          //           ],
                          //         ))),
                          Stack(
                              alignment: const Alignment(0.6, 0.6),
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                  ),
                                  elevation: 30,
                                  child: Container(
                                      padding: EdgeInsets.all(5),
                                      child: Center(
                                          child: Wrap(
                                        children: actorWidgets.toList(),
                                      ))),
                                ),
                                // Icon(Icons.hiking_rounded)
                              ])
                        ]),
                  ))),
          // Container(
          //   child: Text("s"),
          // )
        ]);
  }

  Iterable<Widget> get actorWidgets {
    final hikerP = Provider.of<HikerProvider>(context);

    final tripP = Provider.of<TripProvider>(context);

    int? x = 89;

    final tripH = tripP.getTrip(x).trip_hikers;

    print(tripH);
    final List<Hiker> _cast =
        List.generate(tripH!.length, (i) => hikerP.getHiker(tripH[i]));
    ThemeData(useMaterial3: true, colorScheme: darkColorScheme);

    return _cast.map((Hiker hiker) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(children: [
          Text(hiker.hiker_first_name),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                    shape: CircleBorder(
                        side: BorderSide(
                            width: 1, color: darkColorScheme.outline)))
                .copyWith(elevation: ButtonStyleButton.allOrNull(20.0)),
            child: CircleAvatar(
                radius: 20,
                backgroundColor: darkColorScheme.surface,
                child:
                    Text(hiker.hiker_first_name[0] + hiker.hiker_last_name[0],
                        style: TextStyle(
                          color: darkColorScheme.primary,
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                        ))),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Profile(
                            hiker: hiker,
                          ),
                      settings: RouteSettings(arguments: hiker)));
              print('If you stand for nothing, Burr, what’ll you fall for?');
            },
          )
        ]),
      );
    });
  }
}
