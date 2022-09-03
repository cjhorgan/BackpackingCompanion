import 'package:flutter/material.dart';
import 'package:frontend/BottomTrav.dart';
import 'package:frontend/models/hiker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:frontend/api/api.dart';
import 'package:frontend/models/trip.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinbox/material.dart'; // or flutter_spinbox.dart for both

class HikerForm extends StatefulWidget {
  const HikerForm({Key? key}) : super(key: key);

  @override
  _HikerFormState createState() => _HikerFormState();
}

class _HikerFormState extends State<HikerForm> {
  var weight = 0.0;
  var avgSpeed = 0.0;
  var height = 0.0;
  var tripsComp = 0;
  var age = 0;
  var gender = "M";
  // final _formKey = GlobalKey<FormState>();
  String firstName = '';
  String description = '';
  final hikerFNameController = TextEditingController();
  final hikerLNameController = TextEditingController();

  final tripStartDateController = TextEditingController();
  final tripEndController = TextEditingController();
  String dropdownValue = 'Male';
  DateTime date = DateTime.now();
  DateTime endDate = DateTime.now();
  double maxValue = 0;
  bool? brushedTeeth = false;
  bool enableFeature = false;
  void onAdd() {
    final firstNameVal = hikerFNameController.text;
    final lastNameVal = hikerLNameController.text;

    if (firstNameVal.isNotEmpty) {
      final Hiker hiker = Hiker(
        hiker_first_name: firstNameVal,
        hiker_last_name: lastNameVal,
        hiker_physical_weight: weight,
        hiker_height_inch: height,
        hiker_age: age,
        hiker_natural_gender: gender,
        hiker_avg_speed_flat: avgSpeed,
        hiker_trips_completed: tripsComp,
      );

      Provider.of<HikerProvider>(context, listen: false).addHiker(hiker);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Hiker'),
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
                            controller: hikerFNameController,
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
                            controller: hikerLNameController,
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
                        Padding(
                          child: SpinBox(
                            min: 1,
                            max: 100,
                            value: 50,
                            decoration: const InputDecoration(
                              hintText: 'Weight',
                              labelText: 'Weight',
                            ),
                            onChanged: (value) => weight = value,
                          ),
                          padding: const EdgeInsets.all(16),
                        ),
                        SpinBox(
                          min: 1,
                          max: 100,
                          value: 50,
                          decoration: const InputDecoration(
                            hintText: 'Age',
                            labelText: 'Age',
                          ),
                          onChanged: (value) => age = value.toInt(),
                        ),
                        SpinBox(
                          min: 50,
                          max: 100,
                          value: 50,
                          decoration: const InputDecoration(
                            hintText: 'Height',
                            labelText: 'Height',
                          ),
                          onChanged: (value) => height = value,
                        ),
                        SpinBox(
                          min: 1,
                          max: 100,
                          value: 50,
                          decoration: const InputDecoration(
                            hintText: 'Avg Speed',
                            labelText: 'Avg Speed',
                          ),
                          onChanged: (value) => avgSpeed = value,
                        ),
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
            Navigator.pop(context);
          }),
    );
  }
}
