import 'package:flutter/material.dart';
import 'package:frontend/Inventory.dart';
import 'package:frontend/home.dart';
import 'package:frontend/layout.dart';
import 'package:frontend/screens/profile.dart';
import 'package:frontend/tripView.dart';
import 'dash.dart';
import 'color_schemes.g.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/api.dart';
import 'package:provider/provider.dart';
import 'tripView.dart';
import 'Inventory.dart';
import 'location.dart';
import 'home.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({Key? key}) : super(key: key);

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
    Location(),
    Inventory(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: darkColorScheme.onSurface,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications,
              color: darkColorScheme.onSurface,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5, right: 16, bottom: 5),
            child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()));
                },
                icon: Icon(
                  Icons.account_circle,
                  color: darkColorScheme.onSurface,
                )),
          )
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
            icon: Icon(Icons.forest),
            label: 'Trip',
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
