import 'package:flutter/material.dart';
import 'package:frontend/Inventory.dart';
import 'package:frontend/Mapping.dart';
import 'package:frontend/calendar.dart';
import 'package:frontend/home.dart';
import 'package:frontend/layout.dart';
import 'package:frontend/screens/profile.dart';
import 'package:frontend/tripView.dart';
import 'color_schemes.g.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/api.dart';
import 'package:provider/provider.dart';
import 'models/hiker.dart';
import 'tripView.dart';
import 'Inventory.dart';
import 'location.dart';
import 'home.dart';
import 'package:frontend/models/trip.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({Key? key, this.hiker, this.trip}) : super(key: key);
  final Hiker? hiker;
  final Trip? trip;

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MyStatefulWidget();
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Layout(),
    Mapping(),
    Inventory(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      final hiker = ModalRoute.of(context)!.settings.arguments as Hiker;
      (context) => Layout(hiker: hiker);
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hiker = ModalRoute.of(context)!.settings.arguments as Hiker;
    // final trip = ModalRoute.of(context)!.settings.arguments as Trip;

    setState(() {
      final hiker = ModalRoute.of(context)!.settings.arguments as Hiker;
      (context) => Layout(hiker: hiker);
    });

    final hikerP = Provider.of<HikerProvider>(context);
    int? hikerID = hiker.hiker_id;
    ThemeData(useMaterial3: true, colorScheme: darkColorScheme);
    Color containerColor = Theme.of(context).colorScheme.secondaryContainer;
    // Color background = Theme.of(context).colorScheme.surface;
    Color textColor = Theme.of(context).colorScheme.onBackground;
    Color shadowColor = Theme.of(context).colorScheme.shadow;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkColorScheme.background,
        iconTheme: IconThemeData(color: textColor, size: 28),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TableEventsExample(),
                      settings: RouteSettings(arguments: hiker)));
            },
            icon: Icon(
              Icons.forest,
              color: darkColorScheme.onSurface,
            ),
          ),
          Container(
              margin: const EdgeInsets.only(top: 5, right: 16, bottom: 5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                        shape: CircleBorder(
                            side: BorderSide(
                                width: 1, color: darkColorScheme.onSurface)))
                    .copyWith(elevation: ButtonStyleButton.allOrNull(20.0)),
                child: CircleAvatar(
                    backgroundColor: darkColorScheme.tertiary,
                    child: Text(
                        hiker.hiker_first_name[0] + hiker.hiker_last_name[0],
                        style: TextStyle(
                          color: darkColorScheme.background,
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                        ))),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Profile(
                                hiker: hiker,
                              ),
                          settings: RouteSettings(arguments: hiker)));
                  print(
                      'If you stand for nothing, Burr, what’ll you fall for?');
                },
              ))
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: darkColorScheme.surface,
        elevation: 15,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_pin),
            label: 'Navigation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Inventory',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: darkColorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}
