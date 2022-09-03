import 'package:frontend/api/api.dart';
import 'package:frontend/models/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/hiker.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key, required this.hiker}) : super(key: key);
  final Hiker hiker;
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final todoTitleController = TextEditingController();
  final todoDesController = TextEditingController();
  final todohikeController = TextEditingController();

  void onAdd() {
    final hiker = ModalRoute.of(context)!.settings.arguments as Hiker;

    final String textVal = todoTitleController.text;
    final String desVal = todoDesController.text;
    final String hikerVal = todohikeController.text;
    if (textVal.isNotEmpty && desVal.isNotEmpty) {
      final Item item = Item(
        item_name: textVal,
        item_weight: double.parse(desVal),
        item_hiker: hiker.hiker_id,
      );
      print(item);
      Provider.of<ItemProvider>(context, listen: false).addItem(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Item')),
      body: ListView(
        children: [
          Container(
              child: Column(
            children: [
              TextField(
                controller: todoTitleController,
              ),
              TextField(
                controller: todoDesController,
              ),
              ElevatedButton(
                  child: Text('Add'),
                  onPressed: () {
                    onAdd();

                    Navigator.of(context).pop();
                  })
            ],
          ))
        ],
      ),
    );
  }
}
