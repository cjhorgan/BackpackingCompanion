import 'package:flutter/material.dart';
import 'package:frontend/api/api.dart';
import 'package:provider/provider.dart';
import '../models/hiker.dart';
import '../models/trip.dart';
import '../models/item.dart';
import 'package:frontend/screens/editItem.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Inventory> getInventory(int tripId, int hikerId) async {
  final response = await http
      .get(Uri.parse('http://127.0.0.1:8000/inventory/${tripId}/${hikerId}'));

  if (response.statusCode == 200) {
    var inv;
    try {
      var data = jsonDecode(response.body) as List;
      inv = data.map<Inventory>((json) => Inventory.fromJson(json)).toList();
    } catch (e) {
      print(e);
    }
    return inv[0];
  } else {
    throw Exception('Failed to load inventory');
  }
}

class InventoryViewer extends StatefulWidget {
  final int trip_id;
  final int hiker_id;
  const InventoryViewer(
      {Key? key, required this.trip_id, required this.hiker_id})
      : super(key: key);

  @override
  _InventoryViewerState createState() =>
      _InventoryViewerState(trip_id, hiker_id);
}

class _InventoryViewerState extends State<InventoryViewer> {
  int trip_id;
  int hiker_id;

  _InventoryViewerState(this.trip_id, this.hiker_id);

  late Future<Inventory> _inv;

  void initState() {
    super.initState();
    try {
      _inv = getInventory(trip_id, hiker_id);
    } catch (e) {
      print(e);
    }
    print(_inv);
  }

  int _inv_id = -1;

  @override
  Widget build(BuildContext context) {
    print('building');
    return Scaffold(
        appBar: AppBar(title: Text('Inventory Viewer')),
        body: FutureBuilder<Inventory>(
          future: _inv,
          builder: (BuildContext context, AsyncSnapshot<Inventory> snapshot) {
            List<List<String>> hike_items = [];
            List<List<String>> med_items = [];
            List<List<String>> food_items = [];
            List<List<String>> clot_items = [];
            List<List<String>> misc_items = [];

            List<List<List<String>>> items = [];

            String title = '';

            List<String> categories = [
              "Hiking Gear",
              "Medical",
              "Food",
              "Clothing",
              "Miscellaneous"
            ];

            List<Widget> children;
            if (snapshot.hasData) {
              try {
                _inv_id = snapshot.data!.inventory_id!;
                final List<dynamic>? inv_items =
                    snapshot.data!.inventory_items!;
                print(inv_items);

                inv_items!.forEach((quant) {
                  var cat = quant['item']['item_category'];
                  List<String> temp_item = [];
                  var temp_name = quant['item']['item_name'].toString();
                  var temp_quantity = quant['item_quantity'].toString();
                  var temp_description = quant['item']['item_description'];
                  var temp_id = quant['item']['item_id'];
                  temp_item.add(temp_name);
                  temp_item.add(temp_quantity);
                  temp_item.add(temp_description);
                  temp_item.add(temp_id);

                  switch (cat) {
                    case "Hiking Gear":
                      {
                        hike_items.add(temp_item);
                      }
                      break;

                    case "Medical":
                      {
                        med_items.add(temp_item);
                      }
                      break;

                    case "Food":
                      {
                        food_items.add(temp_item);
                      }
                      break;

                    case "Clothing":
                      {
                        clot_items.add(temp_item);
                      }
                      break;

                    case "Miscellaneous":
                      {
                        misc_items.add(temp_item);
                      }
                      break;
                  }
                });

                items = [
                  hike_items,
                  med_items,
                  food_items,
                  clot_items,
                  misc_items
                ];

                print(items);
              } catch (e) {
                print(e);
              }
              title = snapshot.data!.inventory_name;
              items = [
                hike_items,
                med_items,
                food_items,
                clot_items,
                misc_items
              ];
              children = <Widget>[
                Center(child: Text(title)),
                Center(
                    child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      initiallyExpanded: true,
                      title: Text(categories[index]),
                      children: <Widget>[
                        Column(
                          children: _buildExpandableList(items[index], context),
                        )
                      ],
                    );
                  },
                )),
              ];
            } else if (snapshot.hasError) {
              children = <Widget>[
                Text('${snapshot.error}'),
                Text('${snapshot.data}'),
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
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            // if (_inv_id != -1) {
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => AddItemToInv(inv_id: _inv_id)));
            // }
          },
        ));
  }
}

_buildExpandableList(List<List<String>> list, BuildContext context) {
  List<Widget> content = [];

  list.forEach((item) {
    int? id = int.parse(item[3]);
    print(item[2]);
    content.add(ListTile(
      leading: ButtonTheme(
        minWidth: 20.0,
        height: 20.0,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              minimumSize: Size(10, 10),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditItem(item_id: id)));
            },
            child: Text("edit")),
      ),
      title: Tooltip(
          message: 'Item Description: ' + item[2], child: Text(item[0])),
      subtitle: RichText(
          text: TextSpan(
              text: 'Amount:    ',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10),
              children: <TextSpan>[
            TextSpan(text: item[1], style: TextStyle(fontSize: 15)),
          ])),
      trailing: Container(
          height: 20,
          width: 20,
          child: FittedBox(
              child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.red[900],
            child: const SizedBox.expand(
                child: FittedBox(
              child: Icon(Icons.delete),
            )),
          ))),
    ));
  });
  return content;
}
