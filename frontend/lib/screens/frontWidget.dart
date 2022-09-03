import 'package:frontend/api/api.dart';
import 'package:frontend/models/item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/hiker.dart';

class FrontWidget extends StatefulWidget {
  const FrontWidget({Key? key, required this.hiker}) : super(key: key);
  final Hiker hiker;
  @override
  _FrontWidgetState createState() => _FrontWidgetState();
}

class _FrontWidgetState extends State<FrontWidget> {
  final todoTitleController = TextEditingController();
  final todoDesController = TextEditingController();
  final todohikeController = TextEditingController();

  Widget textSection = const Padding(
    padding: EdgeInsets.all(10),
    child: Text(
      'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese',
      softWrap: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 10,
      child: ListView(
        children: [
          Container(
              child: Column(
            children: [
              textSection,
              ElevatedButton(
                  child: Text('Add'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          ))
        ],
      ),
    );
  }
}
