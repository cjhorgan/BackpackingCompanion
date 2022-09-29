import 'package:flutter/services.dart';
import 'package:frontend/api/api.dart';
import 'package:frontend/models/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:frontend/screens/itemStorageViewer.dart';
import '../models/hiker.dart';

class AddItem extends StatefulWidget {
  final int index;
  // final Hiker hiker;
  // const AddItem({Key? key, required this.hiker}) : super(key: key);
  const AddItem({Key? key, required this.index}) : super(key: key);
  @override
  _AddItemState createState() => _AddItemState(index);
  // _AddItemState(hiker.hiker_first_name, hiker.hiker_last_name);
}

class _AddItemState extends State<AddItem> {
  final int index;
  _AddItemState(this.index);

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final weightController = TextEditingController(text: '0.0');
  List<bool> values = [false, false];
  bool visibility = false;
  // final String hikerIndexFirst;
  // final String hikerIndexLast;
  final String hikerIndexFirst = 'Jim';
  final String hikerIndexLast = 'Bob';

  final List<String> categories = <String>[
    "Miscellaneous",
    "Hiking Gear",
    "Medical",
    "Food",
    "Clothing"
  ];
  String dropValue = "Miscellaneous";

  // _AddItemState(this.hikerIndexFirst, this.hikerIndexLast);

  void showHikerSelect() {
    setState(() {
      if (values[0] == true || values[1] == true)
        visibility = true;
      else
        visibility = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hikersP = Provider.of<HikerProvider>(context);
    final String hikerDefaultName = hikerIndexFirst + ', ' + hikerIndexLast;

    List<String> hikerNames = [];
    int selectedHiker = 0;

    void onItemAdd() async {
      String name = nameController.text;
      double weight = double.parse(weightController.text);
      String desc;

      if (descriptionController.text.isNotEmpty) {
        desc = descriptionController.text;
      } else {
        desc = '';
      }

      bool ess = values[1];
      bool fav = values[0];
      int? i_hiker;

      if (ess || fav) {
        i_hiker = selectedHiker;
      } else {
        i_hiker = null;
      }

      if (name.isNotEmpty) {
        final Item item = Item(
          item_name: name,
          item_weight: weight,
          item_description: desc,
          isEssential: ess,
          isFavorite: fav,
          item_hiker: i_hiker,
          item_category: dropValue,
        );

        Provider.of<ItemProvider>(context, listen: false).addItem(item);
        print('item added');

        if (index == 1) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ItemStorageViewer()));
        } else {
          Navigator.pop(context);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text("Add an Item")),
      body:
          ListView(shrinkWrap: true, scrollDirection: Axis.vertical, children: <
              Widget>[
        Container(
            margin: EdgeInsets.all(20.0),
            child: Column(children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Item Name'),
              ),
              TextFormField(
                  controller: weightController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.]'))
                  ],
                  decoration: InputDecoration(labelText: 'Item Weight (lbs)')),
              TextField(
                controller: descriptionController,
                decoration:
                    InputDecoration(labelText: 'Item Description (optional)'),
              )
            ])),
        Center(
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        child: Text('Item Category',
                            style: TextStyle(fontSize: 18)),
                      ),
                      SizedBox(
                          child: DropdownButton<String>(
                        value: dropValue,
                        icon: Icon(Icons.arrow_downward),
                        onChanged: (String? value) {
                          setState(() {
                            dropValue = value!;
                            print(value);
                          });
                        },
                        items: categories
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )),
                    ]))),
        VerticalDivider(width: 20),
        Table(columnWidths: {
          2: FlexColumnWidth(0.2)
        }, children: [
          TableRow(
            children: [
              Column(children: [
                Text('Add to Favorites?', style: TextStyle(fontSize: 15.0)),
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
                Text('Add to Essentials?', style: TextStyle(fontSize: 15.0)),
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
                child: Wrap(direction: Axis.vertical, children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                    child: Column(children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Choose the Hiker this item belongs to:',
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
      ]),
      floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            size: 20,
          ),
          onPressed: () {
            onItemAdd();
          }),
    );
  }
}

class RadioListBuilder extends StatefulWidget {
  final List<Hiker> hikers;
  final int def_val;
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
  int def_val;

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
                  widget.callback(def_val);
                },
                title: Text(hikerNames[index]),
              );
            }));
  }
}
