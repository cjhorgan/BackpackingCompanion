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
import 'package:frontend/globals.dart' as globals;

import '../models/hiker.dart';

class FormWidgetsDemo extends StatefulWidget {
  const FormWidgetsDemo({Key? key, this.trip, this.hiker}) : super(key: key);
  final Hiker? hiker;

  final Trip? trip;
  @override
  _FormWidgetsDemoState createState() => _FormWidgetsDemoState();
}

class _FormWidgetsDemoState extends State<FormWidgetsDemo> {
  // final _formKey = GlobalKey<FormState>();
  String title = '';
  bool validTrip = false;
  bool isError = false;
  bool test = false;
  List<dynamic>? getHikers = [];

  final List<String> _filters = <String>[];

  String description = '';
  final tripNameController = TextEditingController();
  final tripStartDateController = TextEditingController();
  final tripEndController = TextEditingController();
  List<bool> selected = List.generate(20, (index) => false);

  TimeOfDay t = TimeOfDay.now();

  DateTime date = DateTime.now();
  DateTime endDate = DateTime.now();

  TimeOfDay tEnd = TimeOfDay.now();
  double maxValue = 0;
  bool? brushedTeeth = false;

  bool enableFeature = false;

  DateTime applied(DateTime dt, TimeOfDay time) {
    return DateTime(dt.year, dt.month, dt.day, time.hour, time.minute);
  }

  Future<void> onAdd() async {
    date = applied(date, t);
    endDate = applied(endDate, tEnd);
    Future<String> error;
    String tripNameVal = tripNameController.text;
    final String startVal = tripStartDateController.text;

    final String endVal = tripEndController.text;
    final hiker = ModalRoute.of(context)!.settings.arguments as Hiker;

    if (tripNameVal.isNotEmpty) {
      final Trip trip = Trip(
          trip_name: tripNameVal,
          trip_plan_start_datetime: date,
          trip_plan_end_datetime: endDate,
          trip_hikers: getHikers,
          trip_is_active: false,
          trip_is_complete: false);

      error = Provider.of<TripProvider>(context, listen: false).getError(trip);

      // trip.trip_hikers = hikers;

      final arr = error.toString().split('=');

      print(trip);
      print(date);
      print(await error);
      // print(await error);

      if (await error != '201') {
        isError = true;
        String errorMessage =
            Provider.of<TripProvider>(context, listen: false).getErrorMessage();
        _showMyDialog(errorMessage);
        print("error!");
        print(await error);
      } else {
        globals.activeTrip = true;
        globals.tripID = trip.trip_id;

        // ignore: use_build_context_synchronously
        Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (context) => BottomNav(
                      trip: trip,
                    ),
                settings: RouteSettings(arguments: trip)));
        // Provider.of<TripProvider>(context, listen: false).addTrip(trip);

        debugPrint('Card tapped.');
      }

      // Provider.of<TripProvider>(context, listen: false).addTrip(trip);
    }
  }

  Future<void> _showMyDialog(String s) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(s),
                Text('Please input correct dates'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Try again'),
              onPressed: () async {
                if (isError) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pop();
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => MyStatefulWidget()));
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Iterable<Widget> get actorWidgets {
  //   return _cast.map((ActorFilterEntry actor) {
  //     return Padding(
  //       padding: const EdgeInsets.all(4.0),
  //       child: FilterChip(
  //         avatar: CircleAvatar(child: Text(actor.initials)),
  //         label: Text(actor.name),
  //         selected: _filters.contains(actor.name),
  //         onSelected: (bool value) {
  //           setState(() {
  //             if (value) {
  //               _filters.add(actor.name);
  //             } else {
  //               _filters.removeWhere((String name) {
  //                 return name == actor.name;
  //               });
  //             }
  //           });
  //         },
  //       ),
  //     );
  //   });
  // }

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

    final tripP = Provider.of<TripProvider>(context);

    return _cast.map((Hiker hiker) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: FilterChip(
          elevation: 10,
          avatar: CircleAvatar(
              child:
                  Text(hiker.hiker_first_name[0] + hiker.hiker_last_name[0])),
          label: Text(hiker.hiker_first_name),
          selected: _filters.contains(hiker.hiker_first_name),
          selectedColor: darkColorScheme.primary,
          checkmarkColor: Color.fromARGB(0, 255, 86, 34),
          showCheckmark: false,
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _filters.add(hiker.hiker_first_name);
                getHikers?.add(hiker.hiker_id);
              } else {
                _filters.removeWhere((String name) {
                  return name == hiker.hiker_first_name;
                });
              }
            });
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final hiker = ModalRoute.of(context)!.settings.arguments as Hiker;
    final tripP = Provider.of<TripProvider>(context);

    ThemeData(useMaterial3: true, colorScheme: darkColorScheme);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Trip'),
      ),
      body: Form(
        // key: _formKey,
        child: Scrollbar(
          child: Align(
            alignment: Alignment.topCenter,
            child: Card(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: double.infinity),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...[
                        Text(
                          "Plan Your Trip",
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.grey[300],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: TextFormField(
                              controller: tripNameController,
                              decoration: const InputDecoration(
                                filled: true,
                                hintText: 'Trip Name...',
                                labelText: 'Trip',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  validTrip = true;
                                  title = value;
                                });
                              },
                            )),
                        _FormDatePicker(
                            date: date,
                            t: t,
                            label: "Start",
                            onChanged: (value) {
                              setState(() {
                                print("value: " + value.toString());
                                print(date);
                                date = value;
                                print("after:" + date.toString());
                              });
                            },
                            onChangedTime: (v) {
                              setState(() {
                                t = v;
                              });
                            }),
                        _FormDatePicker(
                            date: endDate,
                            t: tEnd,
                            label: "End",
                            onChanged: (value) {
                              setState(() {
                                endDate = value;
                              });
                            },
                            onChangedTime: (v) {
                              setState(() {
                                tEnd = v;
                              });
                            }),
                        // FilterChip(
                        //   avatar: CircleAvatar(child: Text("name")),
                        //   label: Text("name"),
                        //   selected: _filters.contains(actor.name),
                        //   onSelected: (bool value) {
                        //     setState(() {
                        //       if (value) {
                        //         _filters.add(actor.name);
                        //       } else {
                        //         _filters.removeWhere((String name) {
                        //           return name == actor.name;
                        //         });
                        //       }
                        //     });
                        //   },
                        // ),

                        Divider(
                          height: 10,
                        ),
                        Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                            ),
                            elevation: 10,
                            child: Container(
                                width: double.infinity,
                                child: Column(children: [
                                  Text("Choose Hikers",
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.grey[300])),
                                  Wrap(
                                    children: actorWidgets.toList(),
                                  ),
                                ]))),

                        // IconButton(
                        //     onPressed: () {
                        //       onAdd();
                        //     },
                        // icon: const Icon(Icons.person_outline_outlined))
                      ].expand(
                        (widget) => [
                          widget,
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 20,
          child: const Icon(
            Icons.add,
            size: 30,
          ),
          onPressed: () {
            setState(() {
              globals.activeTrip == true;
              globals.hikers == getHikers;
            });
            if (validTrip) {
              onAdd();
            } else {
              _showMyDialog("poi");
            }

            // Navigator.of(context).pop();
          }),
    );
  }
}

class _FormDatePicker extends StatefulWidget {
  final DateTime date;
  final TimeOfDay t;
  final String label;
  final ValueChanged<DateTime> onChanged;
  final ValueChanged<TimeOfDay> onChangedTime;

  const _FormDatePicker(
      {required this.date,
      required this.onChanged,
      required this.onChangedTime,
      required this.t,
      required this.label});

  @override
  State<_FormDatePicker> createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<_FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(children: [
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                widget.label,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            )
          ]),
          Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              elevation: 10,
              child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                      //   margin: const EdgeInsets.only(bottom: 10),
                      //   child: Text(
                      //     widget.label,
                      //     style: TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 25,
                      //     ),
                      //   ),
                      // ),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 10,
                              // Foreground color
                              onPrimary: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                              // Background color
                              primary: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                            ),
                            child: const Text('Choose Date'),
                            onPressed: () async {
                              var newDate = await showDatePicker(
                                context: context,
                                initialDate: widget.date,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );

                              // Don't change the date if the date picker returns null.
                              if (newDate == null) {
                                return;
                              }

                              widget.onChanged(newDate);
                            },
                          ),
                          Container(
                            width: 70,
                          ),
                          Text(
                            intl.DateFormat('yMd').format(widget.date),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                      Divider(height: 10),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 10,
                              // Foreground color
                              onPrimary: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                              // Background color
                              primary: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                            ),
                            child: const Text('Choose Time'),
                            onPressed: () async {
                              var newTime = await showTimePicker(
                                context: context,
                                initialTime: widget.t,
                              );

                              // Don't change the date if the date picker returns null.
                              if (newTime == null) {
                                return;
                              }
                              widget.onChangedTime(newTime);
                            },
                          ),
                          Container(
                            width: 70,
                          ),
                          Text(
                            widget.t.format(context),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      )
                    ],
                  ))),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: [
          //     const Padding(
          //       padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
          //     ),
          //     // Text(
          //     //   intl.DateFormat('yyyy-MM-dd').format(widget.date),
          //     //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          //     // ),
          //     const Padding(
          //       padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
          //     ),

          //     // ElevatedButton(
          //     //   style: ElevatedButton.styleFrom(
          //     //     elevation: 20,
          //     //     // Foreground color
          //     //     onPrimary: Theme.of(context).colorScheme.onSecondaryContainer,
          //     //     // Background color
          //     //     primary: Theme.of(context).colorScheme.secondaryContainer,
          //     //   ),
          //     //   child: const Text('Choose Date'),
          //     //   onPressed: () async {
          //     //     var newDate = await showDatePicker(
          //     //       context: context,
          //     //       initialDate: widget.date,
          //     //       firstDate: DateTime(1900),
          //     //       lastDate: DateTime(2100),
          //     //     );

          //     //     // Don't change the date if the date picker returns null.
          //     //     if (newDate == null) {
          //     //       return;
          //     //     }

          //     //     widget.onChanged(newDate);
          //     //   },
          //     // ),
          //     // ElevatedButton(
          //     //   style: ElevatedButton.styleFrom(
          //     //     elevation: 20,
          //     //     // Foreground color
          //     //     onPrimary: Theme.of(context).colorScheme.onSecondaryContainer,
          //     //     // Background color
          //     //     primary: Theme.of(context).colorScheme.secondaryContainer,
          //     //   ),
          //     //   child: const Text('Choose Time'),
          //     //   onPressed: () async {
          //     //     var newTime = await showTimePicker(
          //     //       context: context,
          //     //       initialTime: widget.t,
          //     //     );

          //     //     // Don't change the date if the date picker returns null.
          //     //     if (newTime == null) {
          //     //       return;
          //     //     }
          //     //     widget.onChangedTime(newTime);
          //     //   },
          //     // )
          //   ],
          // )
        ]);
  }
}
