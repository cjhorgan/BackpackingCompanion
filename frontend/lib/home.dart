import 'package:flutter/material.dart';
import 'package:frontend/api/api.dart';
import 'package:frontend/mealplan.dart';
import 'package:frontend/models/hiker.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/screens/createTrip.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/mealplan.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'Inventory.dart';
import 'color_schemes.g.dart';
import 'tripView.dart';
import 'globals.dart' as globals;

class Home extends StatefulWidget {
  const Home({Key? key, this.trip, this.hiker}) : super(key: key);

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
    DateTime today = DateTime.now();
    DateTime time = DateTime.now();
    String formattedDate = DateFormat.MMMMEEEEd().format(today);
    String formattedTime = DateFormat.jm().format(today);
    final hiker = ModalRoute.of(context)!.settings.arguments as Hiker;

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
                                    child: Text("Trip",
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
                                            'https://media.wired.com/photos/59269cd37034dc5f91bec0f1/191:100/w_1280,c_limit/GoogleMapTA.jpg'),
                                        fit: BoxFit.cover,
                                      )))),
                          Padding(padding: EdgeInsets.all(10)),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Start",
                                    style: TextStyle(
                                      color: darkColorScheme.onSurface,
                                      fontSize: 20,
                                    )),
                                Text("To",
                                    style: TextStyle(
                                      color: darkColorScheme.onSurface,
                                      fontSize: 20,
                                    )),
                                Text("End",
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
                          Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                            ),
                            elevation: 30,
                            child: Container(
                                padding: EdgeInsets.all(5),
                                child: Center(
                                    child: Wrap(
                                  children: actorWidgets.toList(),
                                ))),
                          ),
                        ]),
                  ))),
          // Container(
          //   child: Text("s"),
          // )
        ]);
  }

  Iterable<Widget> get actorWidgets {
    final hikerP = Provider.of<HikerProvider>(context);
    final List<Hiker> _cast = List.generate(
        hikerP.hikers.length,
        (i) => Hiker(
              hiker_id: hikerP.hikers[i].hiker_id,
              hiker_age: hikerP.hikers[i].hiker_age,
              hiker_avg_speed_flat: hikerP.hikers[i].hiker_avg_speed_flat,
              hiker_first_name: hikerP.hikers[i].hiker_first_name,
              hiker_height_inch: i.toDouble(),
              hiker_last_name: hikerP.hikers[i].hiker_last_name,
              hiker_natural_gender: '$i',
              hiker_physical_weight: i.toDouble(),
              hiker_trips_completed: i,
            ));
    List<int?> hikerTrip = [];
    ThemeData(useMaterial3: true, colorScheme: darkColorScheme);

    final tripP = Provider.of<TripProvider>(context);

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
                backgroundColor: darkColorScheme.surface,
                child:
                    Text(hiker.hiker_first_name[0] + hiker.hiker_last_name[0],
                        style: TextStyle(
                          color: darkColorScheme.primary,
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                        ))),
            onPressed: () {
              print('If you stand for nothing, Burr, what’ll you fall for?');
            },
          )
        ]),
      );
    });
  }
}
