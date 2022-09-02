import 'package:flutter/material.dart';
import 'package:frontend/BottomTrav.dart';
import 'package:frontend/color_schemes.g.dart';
import 'package:frontend/layout.dart';
import 'package:intl/intl.dart' as intl;
import 'package:frontend/api/api.dart';
import 'package:frontend/models/trip.dart';
import 'package:provider/provider.dart';

class FormWidgetsDemo extends StatefulWidget {
  const FormWidgetsDemo({Key? key}) : super(key: key);

  @override
  _FormWidgetsDemoState createState() => _FormWidgetsDemoState();
}

class _FormWidgetsDemoState extends State<FormWidgetsDemo> {
  // final _formKey = GlobalKey<FormState>();
  String title = '';
  bool isError = false;
  String description = '';
  final tripNameController = TextEditingController();
  final tripStartDateController = TextEditingController();
  final tripEndController = TextEditingController();

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
    if (tripNameVal.isNotEmpty) {
      final Trip trip = Trip(
        trip_name: tripNameVal,
        trip_plan_start_datetime: date,
        trip_plan_end_datetime: endDate,
      );

      error = Provider.of<TripProvider>(context, listen: false).getError(trip);
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
        // Provider.of<TripProvider>(context, listen: false).addTrip(trip);
        Navigator.of(context).pop();
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyStatefulWidget()));
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...[
                        Text(
                          "Plan Your Trip!",
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
                      ].expand(
                        (widget) => [
                          widget,
                          const SizedBox(
                            height: 20,
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
          child: const Icon(
            Icons.add,
            size: 30,
          ),
          onPressed: () {
            onAdd();
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
                            width: 90,
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
                            width: 90,
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
