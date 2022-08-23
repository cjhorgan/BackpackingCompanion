import 'package:flutter/material.dart';
import 'package:frontend/Inventory.dart';
import 'package:frontend/home.dart';
import 'package:frontend/tripView.dart';
import 'dash.dart';
import 'color_schemes.g.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/api.dart';
import 'package:provider/provider.dart';
import 'tripView.dart';
import 'Inventory.dart';
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
    Home(),
    TripView(),
    Inventory(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color containerColor = Theme.of(context).colorScheme.secondaryContainer;
    Color background = Theme.of(context).colorScheme.surface;
    Color textColor = Theme.of(context).colorScheme.onBackground;
    Color shadowColor = Theme.of(context).colorScheme.shadow;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
        shadowColor: shadowColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor, size: 28),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              color: Colors.grey,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5, right: 16, bottom: 5),
            child: CircleAvatar(
                foregroundImage: const AssetImage(
                    "/Users/addamvictorio/development/backpackcompanion/frontend/assets/images/outline_account_circle_black_48dp.png"),
                backgroundColor: textColor),
          )
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.landscape),
            label: 'Trip',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.backpack),
            label: 'Inventory',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
