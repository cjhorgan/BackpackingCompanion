import 'dart:math';

import 'package:dart_numerics/dart_numerics.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/api.dart';
import 'package:frontend/globals.dart';
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
import 'dart:convert';
import "dart:math" show pi;
import 'package:dart_numerics/dart_numerics.dart' as numerics;
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  const Home({Key? key, this.trip, this.hiker}) : super(key: key);

  final Hiker? hiker;
  final Trip? trip;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void getPos() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  double degToRadian(final double deg) => deg * (pi / 180.0);
  int long2tilex(double lon, int z) =>
      (((lon + 180.0) / 360.0 * (1 << z))).floor();
  int lat2tiley(double lat, int z) =>
      ((1.0 - asinh(tan(degToRadian(lat))) / pi) / 2.0 * (1 << z)).floor();

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
    Trip? p = tripP.getTrip(4);
    final tripstart = tripP.getTrip(4)?.trip_plan_start_datetime;
    final tripEnd = tripP.getTrip(4)?.trip_plan_end_datetime;
    String tripstartDate = DateFormat.MMMd().format(tripstart!);
    String tripEndDate = DateFormat.MMMd().format(tripEnd!);
    int zoom = 10;
    double lat_rad = 37.865101;
    double lon_deg = -119.538330;
    var y = lat2tiley(lat_rad, zoom);
    var x = long2tilex(lon_deg, zoom);

    String s = 'https://tile.openstreetmap.org/${zoom}/${x}/${y}.png';
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
                                    child: Text(p!.trip_name,
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
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      image: DecorationImage(
                                        image: NetworkImage(s),
                                        fit: BoxFit.cover,
                                      )))),
                          Padding(padding: EdgeInsets.all(10)),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Start",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w400,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(2.0, 2.0),
                                        blurRadius: 2.0,
                                        color: darkColorScheme.shadow,
                                      ),
                                    ],
                                  )),
                              Text("End",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w400,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(2.0, 2.0),
                                        blurRadius: 2.0,
                                        color: darkColorScheme.shadow,
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                          // Divider(),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(tripstartDate,
                                    style: TextStyle(
                                      color: darkColorScheme.onSurface,
                                      fontSize: 20,
                                    )),
                                Icon(
                                  Icons.east,
                                  size: 30,
                                  color: darkColorScheme.primary,
                                ),
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
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text("Group",
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

    // int? x = 89;

    final tripH = tripP.getTrip(4)?.trip_hikers;

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
