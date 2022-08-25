import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:frontend/api/api.dart';
import 'package:frontend/models/trip.dart';
import 'package:provider/provider.dart';

class HikerForm extends StatefulWidget {
  const HikerForm({Key? key}) : super(key: key);

  @override
  _HikerFormState createState() => _HikerFormState();
}

class _HikerFormState extends State<HikerForm> {
  // final _formKey = GlobalKey<FormState>();
  String firstName = '';
  String description = '';
  final tripNameController = TextEditingController();
  final tripStartDateController = TextEditingController();
  final tripEndController = TextEditingController();
  String dropdownValue = 'Male';
  DateTime date = DateTime.now();
  DateTime endDate = DateTime.now();
  double maxValue = 0;
  bool? brushedTeeth = false;
  bool enableFeature = false;
  void onAdd() {
    String tripNameVal = tripNameController.text;
    final String startVal = tripStartDateController.text;
    final String endVal = tripEndController.text;
    if (tripNameVal.isNotEmpty) {
      final Trip trip = Trip(
        trip_name: tripNameVal,
        trip_plan_end_datetime: endDate,
        trip_plan_start_datetime: date,
      );
      print(trip);
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
                padding: const EdgeInsets.all(25),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...[
                        Column(children: [
                          TextFormField(
                            controller: tripNameController,
                            decoration: const InputDecoration(
                              filled: true,
                              hintText: 'First Name...',
                              labelText: 'First Name',
                            ),
                            onChanged: (value) {
                              setState(() {
                                firstName = value;
                              });
                            },
                          ),
                          TextFormField(
                            controller: tripNameController,
                            decoration: const InputDecoration(
                              filled: true,
                              hintText: 'Last Name...',
                              labelText: 'Last Name',
                            ),
                            onChanged: (value) {
                              setState(() {
                                firstName = value;
                              });
                            },
                          ),
                        ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Sex',
                                style: Theme.of(context).textTheme.bodyText1),
                            DropdownButton<String>(
                                value: dropdownValue,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style: const TextStyle(),
                                underline: Container(
                                  height: 2,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                },
                                items: <String>[
                                  'Male',
                                  'Female'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList()),
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
