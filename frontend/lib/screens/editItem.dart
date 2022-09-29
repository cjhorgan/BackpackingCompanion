import 'package:flutter/services.dart';
import 'package:frontend/api/api.dart';
import 'package:frontend/models/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/hiker.dart';

Future<Item> getItem(int? item_id) async {
  final response =
      await http.get(Uri.parse('http://10.0.2.2:8000/item/${item_id}'));

  if (response.statusCode == 200) {
    return Item.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load item');
  }
}

class EditItem extends StatefulWidget {
  final int? item_id;
  const EditItem({Key? key, this.item_id}) : super(key: key);

  @override
  _EditItemState createState() => _EditItemState(item_id);
}

class _EditItemState extends State<EditItem> {
  late Future<Item> _item;
  List<bool> values = [false, false];
  bool visibility = false;
  int? selectedHiker;
  final nameController = TextEditingController();
  final weightController = TextEditingController();
  final descriptionController = TextEditingController();
  String dropValue = '';
  final int? item_id;

  _EditItemState(this.item_id);

  void initState() {
    super.initState();
    try {
      _item = getItem(widget.item_id);
    } catch (e) {
      print(e);
    }
  }

  void showHikerSelect() {
    setState(() {
      if (values[0] == true || values[1] == true)
        visibility = true;
      else
        visibility = false;
    });
  }

  void _submitPutItem() {
    String desc;
    if (descriptionController.text.isNotEmpty) {
      desc = descriptionController.text;
    } else {
      desc = '';
    }
    double? weight = double.parse(weightController.text);
    Item update;

    if (nameController.text.isNotEmpty) {
      final Item update = Item(
          item_name: nameController.text,
          item_weight: weight,
          item_description: desc,
          isEssential: values[1],
          isFavorite: values[0],
          item_hiker: selectedHiker,
          item_category: dropValue);

      // Provider.of<ItemProvider>(context, listen: false)
      //     .editItem(update, item_id);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hikersP = Provider.of<HikerProvider>(context);

    return Scaffold(
        appBar: AppBar(title: Text('Edit')),
        body: FutureBuilder<Item>(
            future: _item,
            builder: (BuildContext context, AsyncSnapshot<Item> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                final Item item = snapshot.data!;
                nameController.text = item.item_name;
                weightController.text = item.item_weight.toString();
                descriptionController.text = item.item_description;
                final List<String> categories = <String>[
                  "Miscellaneous",
                  "Hiking Gear",
                  "Medical",
                  "Food",
                  "Clothing",
                ];
                List<bool> values = [item.isFavorite, item.isEssential];
                if (values[0] || values[1]) {
                  visibility = true;
                } else {
                  visibility = false;
                }
                dropValue = item.item_category;

                children = <Widget>[
                  Center(
                      child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: <Widget>[
                        Container(
                            margin: EdgeInsets.all(20.0),
                            child: Column(children: <Widget>[
                              TextField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                    labelText: 'Item Name'),
                              ),
                              TextFormField(
                                  controller: weightController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9.]'))
                                  ],
                                  decoration: const InputDecoration(
                                      labelText: 'Item Weight (lbs)')),
                              TextField(
                                controller: descriptionController,
                                decoration: const InputDecoration(
                                    labelText: 'Item Description (optional)'),
                              )
                            ])),
                        Center(
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      const SizedBox(
                                        child: Text('Item Category',
                                            style: TextStyle(fontSize: 18)),
                                      ),
                                      SizedBox(
                                          width: 130,
                                          child:
                                              DropdownButtonFormField<String>(
                                            isExpanded: true,
                                            value: dropValue,
                                            icon: Icon(Icons.arrow_downward),
                                            onChanged: (String? value) {
                                              setState(() {
                                                dropValue = value!;
                                              });
                                            },
                                            onSaved: (String? value) {
                                              setState(() {
                                                dropValue = value!;
                                              });
                                            },
                                            items: categories
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: SizedBox(
                                                    width: 110,
                                                    child: Text(value),
                                                  ));
                                            }).toList(),
                                          )),
                                    ]))),
                        Table(columnWidths: {
                          2: FlexColumnWidth(0.2)
                        }, children: [
                          TableRow(
                            children: [
                              Column(children: [
                                Text('Favorite Item',
                                    style: TextStyle(fontSize: 15.0)),
                                Checkbox(
                                    checkColor: Colors.white,
                                    value: values[0],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        values[0] = value!;
                                        showHikerSelect();
                                      });
                                    })
                              ]),
                              Column(children: [
                                Text('Essential Item',
                                    style: TextStyle(fontSize: 15.0)),
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: values[1],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      values[1] = value!;
                                      showHikerSelect();
                                    });
                                  },
                                ),
                              ]),
                            ],
                          ),
                        ]),
                        Visibility(
                            visible: visibility,
                            child: Align(
                                alignment: Alignment.center,
                                child:
                                    Wrap(direction: Axis.vertical, children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.white)),
                                    child: Column(children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            'Choose the Hiker this item belongs to:',
                                            style: TextStyle(fontSize: 10.0)),
                                      ),
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: RadioListBuilder(
                                              hikers: hikersP.hikers,
                                              def_val: selectedHiker,
                                              callback: (def_val) {
                                                setState(() {
                                                  selectedHiker = def_val;
                                                });
                                              })),
                                    ]),
                                  ),
                                ])))
                      ]))
                ];
              } else if (snapshot.hasError) {
                children = <Widget>[
                  Text('${snapshot.error}'),
                  Text('${snapshot.data}')
                ];
              } else {
                children = const <Widget>[
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Loading...'),
                  ),
                ];
              }
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: children,
              ));
            }),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.thumb_up),
            onPressed: () {
              _submitPutItem();
            }));
  }
}

class RadioListBuilder extends StatefulWidget {
  final List<Hiker> hikers;
  final int? def_val;
  final Function(int) callback;
  const RadioListBuilder(
      {Key? key,
      required this.hikers,
      required this.def_val,
      required this.callback})
      : super(key: key);

  @override
  _RadioListBuilderState createState() =>
      _RadioListBuilderState(hikers, def_val);
}

class _RadioListBuilderState extends State<RadioListBuilder> {
  List<Hiker> hikers;
  int? def_val;

  List<String> getNames(List<Hiker> hikers) {
    List<String> results = [];
    for (var i = 0; i < hikers.length; i++) {
      String tempF = hikers[i].hiker_first_name;
      String tempL = hikers[i].hiker_last_name;
      String tempN = tempF + ' ' + tempL;
      results.add(tempN);
    }
    return results;
  }

  _RadioListBuilderState(this.hikers, this.def_val);
  @override
  Widget build(BuildContext context) {
    List<String> hikerNames = getNames(hikers);
    return SizedBox(
        width: MediaQuery.of(context).size.width * .5,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: hikerNames.length,
            itemBuilder: (context, index) {
              return RadioListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                value: index,
                groupValue: def_val,
                onChanged: (int? ind) {
                  setState(() => def_val = ind ?? 0);
                  widget.callback(def_val!);
                },
                title: Text(hikerNames[index]),
              );
            }));
  }
}
