import 'package:frontend/api/api.dart';
import 'package:frontend/models/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final todoTitleController = TextEditingController();
  final todoDesController = TextEditingController();
  final todohikeController = TextEditingController();

  void onAdd() {
    final String textVal = todoTitleController.text;
    final String desVal = todoDesController.text;
    final String hikerVal = todohikeController.text;
    if (textVal.isNotEmpty && desVal.isNotEmpty) {
      final Item item = Item(
        item_name: textVal,
        item_weight: double.parse(desVal),
        item_hiker: int.parse(hikerVal),
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
              TextField(
                controller: todohikeController,
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
