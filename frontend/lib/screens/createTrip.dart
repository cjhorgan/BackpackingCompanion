import 'package:flutter/material.dart';
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
      print(trip);
      print(date);
      print(await error);

      if (await error == 452) {}

      Provider.of<TripProvider>(context, listen: false).addTrip(trip);
    }
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
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...[
                        TextFormField(
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
                        ),
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
                            label: "End",
                            date: endDate,
                            t: tEnd,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Enable feature',
                                style: Theme.of(context).textTheme.bodyText1),
                            Switch(
                              value: enableFeature,
                              onChanged: (enabled) {
                                setState(() {
                                  enableFeature = enabled;
                                });
                              },
                            ),
                          ],
                        ),
                      ].expand(
                        (widget) => [
                          widget,
                          const SizedBox(
                            height: 24,
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
            Navigator.of(context).pop();
          }),
    );
  }
}

class _FormDatePicker extends StatefulWidget {
  final DateTime date;
  final TimeOfDay t;

  final ValueChanged<DateTime> onChanged;
  final ValueChanged<TimeOfDay> onChangedTime;
  final String label;

  const _FormDatePicker(
      {required this.date,
      required this.onChanged,
      required this.onChangedTime,
      required this.label,
      required this.t});

  @override
  State<_FormDatePicker> createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<_FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                widget.label,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                intl.DateFormat('yyyy-MM-dd').format(widget.date),
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                widget.t.format(context),
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ],
          ),
          Column(
            children: [
              TextButton(
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
              TextButton(
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
              )
            ],
          )
        ]);
  }
}
