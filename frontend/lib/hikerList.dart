import 'package:flutter/material.dart';
import 'package:frontend/BottomTrav.dart';
import 'package:frontend/api/api.dart';
import 'package:frontend/models/hiker.dart';
import 'package:frontend/screens/profile.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'models/item.dart';
import 'package:frontend/screens/addItem.dart';
import 'package:frontend/models/trip.dart';
import 'screens/createHiker.dart';
import 'package:invert_colors/invert_colors.dart';
import 'color_schemes.g.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

class HikerList extends StatelessWidget {
  const HikerList({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).colorScheme.onSurfaceVariant;
    Color headlineColor = Theme.of(context).colorScheme.onSurface;
    final hikerP = Provider.of<HikerProvider>(context);
    final tripP = Provider.of<TripProvider>(context);

    List.generate(
        20,
        (i) => Hiker(
              hiker_id: i,
              hiker_age: i,
              hiker_avg_speed_flat: i.toDouble(),
              hiker_first_name: '$i',
              hiker_height_inch: i.toDouble(),
              hiker_last_name: '$i',
              hiker_natural_gender: '$i',
              hiker_physical_weight: i.toDouble(),
              hiker_trips_completed: i,
            ));
    return Scaffold(

        // floatingActionButton: FloatingActionButton(
        //   onPressed: _incrementCounter,
        //   tooltip: 'Increment',
        //   child: const Icon(Icons.add),
        // ),

        body: Center(
            heightFactor: 1.3,
            child: Scrollbar(
                child: SingleChildScrollView(
              child: Column(children: [
                const Image(
                    isAntiAlias: true,
                    filterQuality: FilterQuality.medium,
                    height: 300,
                    color: Color.fromARGB(255, 255, 255, 255),
                    image: AssetImage(
                      'assets/images/logoBC_trans.png',
                    )),
                Container(
                    margin:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 0),
                    child: (ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: hikerP.hikers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            elevation: 10,
                            child: Column(children: [
                              ListTile(
                                  contentPadding: EdgeInsets.only(
                                      top: 5, bottom: 5, left: 5),
                                  title: Text(
                                      hikerP.hikers[index].hiker_first_name +
                                          " " +
                                          hikerP.hikers[index].hiker_last_name,
                                      style: TextStyle(
                                          color: headlineColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500)),
                                  // subtitle: Text(
                                  //   hikerP.hikers[index].hiker_last_name,
                                  //   style:
                                  //       TextStyle(fontSize: 15, color: textColor),
                                  // ),
                                  leading: Container(
                                      margin: EdgeInsets.only(left: 5),
                                      decoration: ShapeDecoration(
                                          shape: CircleBorder(
                                              side: BorderSide(
                                                  width: 2,
                                                  color: darkColorScheme
                                                      .onSurface))),
                                      child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor:
                                              darkColorScheme.surface,
                                          child: Text(
                                              hikerP.hikers[index]
                                                      .hiker_first_name[0] +
                                                  hikerP.hikers[index]
                                                      .hiker_last_name[1],
                                              style: TextStyle(
                                                color:
                                                    darkColorScheme.onSurface,
                                                fontSize: 25,
                                                fontWeight: FontWeight.w500,
                                              )))),
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BottomNav(
                                                  hiker: hikerP.hikers[index],
                                                ), // Pass the arguments as part of the RouteSettings. The
                                            // DetailScreen reads the arguments from these settings.
                                            settings: RouteSettings(
                                              arguments: hikerP.hikers[index],
                                            )));

                                    /* react to the tile being tapped */
                                  })
                            ]));
                      },
                    ))),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20),
                  child: TextButton.icon(
                      label: Text(
                        "Create Hiker",
                        style: TextStyle(fontSize: 25),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const HikerForm()));
                      },
                      icon: Icon(
                        Icons.add,
                        size: 25,
                        color: darkColorScheme.primary,
                      )),
                ),
              ]),

              // floatingActionButton: ElevatedButton(
              //     child: const Icon(
              //       Icons.add,
              //       size: 50,
              //     ),
              //     onPressed: () {
              //       Navigator.of(context)
              //           .push(MaterialPageRoute(builder: (ctx) => const HikerForm()));
              //     }),
            ))));
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
      body: Container(
          child: Row(children: [
        Text(todo.item_weight.toString()),
        Text(todo.item_hiker.toString()),
      ])),
    );
  }
}
