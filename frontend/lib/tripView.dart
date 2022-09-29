import 'package:flutter/material.dart';
import 'package:frontend/api/api.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'models/hiker.dart';
import 'models/item.dart';

import 'color_schemes.g.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

class TripList extends StatelessWidget {
  const TripList({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).colorScheme.onSurfaceVariant;
    Color headlineColor = Theme.of(context).colorScheme.onSurface;
    final tripP = Provider.of<TripProvider>(context);
    final hiker = ModalRoute.of(context)!.settings.arguments as Hiker;
    final hikerP = Provider.of<HikerProvider>(context);
    int? hikerID = hiker.hiker_id;
    List.generate(
        20,
        (i) => Item(
              item_id: i,
              item_hiker: hikerID,
              item_weight: i.toDouble(),
              item_name: '$i',
              isEssential: true,
              isFavorite: false,
              item_description: '',
              item_category: '',
            ));
    return Scaffold(
      backgroundColor: darkColorScheme.background,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
      appBar: AppBar(
        title: const Text('Choose Trip'),
      ),
      body: Scrollbar(
          child: SingleChildScrollView(
              child: ListView.builder(
        shrinkWrap: true,
        itemCount: tripP.trips.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              elevation: 20,
              child: (ListTile(
                  trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {}),
                  title: Text(tripP.trips[index].trip_name,
                      style: TextStyle(color: headlineColor)),
                  subtitle: Text(
                    "id: ${tripP.trips[index].trip_id}",
                    style: TextStyle(fontSize: 15, color: textColor),
                  ),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) =>
                    //           DetailScreen(todo: tripP.trips[index])),
                    // );
                    /* react to the tile being tapped */
                  })));
        },
      ))),
      floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            size: 30,
          ),
          onPressed: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => AddItemScreen(
            //               hiker: hiker,
            //             ),
            //         settings: RouteSettings(arguments: hiker)));
          }),
    );
  }
}

class ItemView extends StatelessWidget {
  const ItemView({super.key});

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    'Area',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Location',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          /*3*/
          Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          const Text('41'),
        ],
      ),
    );

    Color color = Theme.of(context).primaryColor;

    Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn(color, Icons.call, 'CALL'),
        _buildButtonColumn(color, Icons.near_me, 'ROUTE'),
        _buildButtonColumn(color, Icons.share, 'SHARE'),
      ],
    );

    Widget textSection = const Padding(
      padding: EdgeInsets.all(32),
      child: Text(
        'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
        'Alps. Situated 1,578 meters above sea level, it is one of the '
        'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
        'half-hour walk through pastures and pine forest, leads you to the '
        'lake, which warms to 20 degrees Celsius in the summer. Activities '
        'enjoyed here include rowing, and riding the summer toboggan run.',
        softWrap: true,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Name'),
      ),
      body: ListView(
        children: [
          Image.asset(
            '/Users/addamvictorio/development/backpackcompanion/frontend/assets/images/ys.jpg',
            fit: BoxFit.cover,
          ),
          titleSection,
          buttonSection,
          textSection,
        ],
      ),
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class DetailScreen extends StatelessWidget {
  // In the constructor, require a Todo.
  const DetailScreen({super.key, required this.todo});

  // Declare a field that holds the Todo.
  final Item todo;

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.item_name),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(children: [
            Text(todo.item_weight.toString()),
            Text(todo.item_hiker.toString()),
          ])),
    );
  }
}
