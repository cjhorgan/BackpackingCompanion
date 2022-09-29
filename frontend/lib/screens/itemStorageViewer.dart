import 'package:flutter/services.dart';
import 'package:frontend/api/api.dart';
import 'package:frontend/models/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/models/item.dart';
import 'package:frontend/screens/addItem.dart';
import 'package:frontend/screens/editItem.dart';

class ItemStorageViewer extends StatefulWidget {
  const ItemStorageViewer({Key? key}) : super(key: key);

  @override
  _ItemStorageViewerState createState() => _ItemStorageViewerState();
}

class _ItemStorageViewerState extends State<ItemStorageViewer> {
  void _onEdit() {}

  List<Item> hike_items = [];
  List<Item> med_items = [];
  List<Item> food_items = [];
  List<Item> clot_items = [];
  List<Item> misc_items = [];
  List<Item> ess_items = [];

  List<String> titles = [
    "Essential Items",
    "Hiking Gear",
    "Medical",
    "Food",
    "Clothing",
    "Miscellaneous"
  ];

  List<List<Item>> all_items = [];
  Map<String, String> hiker_info = {};
  int global_hero_index = 0;

  @override
  Widget build(BuildContext context) {
    var itemsP = Provider.of<ItemProvider>(context);
    var hikersP = Provider.of<HikerProvider>(context);
    var i = 0;
    itemsP.items.forEach((item) {
      // if (item.isEssential) {
      //   ess_items.add(item);
      // } else {
      var category = item.item_category;
      switch (category) {
        case "Hiking Gear":
          {
            hike_items.add(item);
            i++;
            print('1');
          }
          break;

        case "Medical":
          {
            med_items.add(item);
            print('2');
          }
          break;

        case "Food":
          {
            food_items.add(item);
            print('3');
          }
          break;

        case "Clothing":
          {
            clot_items.add(item);
            print('4');
          }
          break;

        case "Miscellaneous":
          {
            misc_items.add(item);
            print('5');
          }
          break;
      }
    });

    all_items = [
      ess_items,
      hike_items,
      med_items,
      food_items,
      clot_items,
      misc_items
    ];

    print('im dumb');

    print(all_items);

    hikersP.hikers.forEach((hiker) {
      String name = hiker.hiker_first_name + ' ' + hiker.hiker_last_name;
      String id = hiker.hiker_id.toString();
      List<dynamic> temp = [name, id];
      hiker_info[id] = name;
    });

    print('hello');

    return Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
            shrinkWrap: true,
            itemCount: all_items.length,
            itemBuilder: (BuildContext context, int index) {
              if (all_items[index].isEmpty) {
                return ListTile(
                    title: Text('No ' + titles[index] + ' in database'));
              } else if (titles[index] == "Essential Items") {
                return ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(titles[index]),
                    children: <Widget>[
                      Column(
                        children: _buildEssentialList(all_items[index],
                            hiker_info, context, global_hero_index),
                      )
                    ]);
              } else {
                return ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(titles[index]),
                    children: <Widget>[
                      Column(
                        children:
                            _buildExpandableList(all_items[index], context),
                      )
                    ]);
              }
            }),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddItem(index: 1)));
            }));
  }
}

_buildEssentialList(List<Item> items, Map<String, String> hiker_info,
    BuildContext context, int hero_index) {
  List<Widget> contents = [];
  items.sort((a, b) => a.item_hiker.compareTo(b.item_hiker));

  for (var i = 0; i < items.length; i++) {
    String? cur_hiker = hiker_info[items[i].item_hiker.toString()];

    contents.add(ListTile(
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
                      builder: (context) =>
                          EditItem(item_id: items[i].item_id)));
            },
            child: const Text("edit")),
      ),
      title: Text(items[i].item_name),
      subtitle: Text(cur_hiker!),
      trailing: SizedBox(
          height: 20,
          width: 20,
          child: FittedBox(
            child: ElevatedButton.icon(
                icon: Icon(Icons.delete),
                label: Text(''),
                onPressed: () {},
                style: ElevatedButton.styleFrom(primary: Colors.red)),
          )),
    ));
  }
  return contents;
}

_buildExpandableList(List<Item> items, BuildContext context) {
  var i = 0;
  List<Widget> content = [];
  items.forEach((item) {
    content.add(Card(
        child: ListTile(
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
                            builder: (context) =>
                                EditItem(item_id: item.item_id)));
                  },
                  child: Text("edit")),
            ),
            title: Text(item.item_name),
            trailing: Container(
                height: 20,
                width: 20,
                child: FittedBox(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    onPressed: () {},
                    child: Text("delete"),
                  ),
                )))));
  });
  return content;
}
