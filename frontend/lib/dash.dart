import 'package:flutter/material.dart';
import 'package:frontend/trip.dart';
import 'Inventory.dart';
import 'color_schemes.g.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color containerColor = Theme.of(context).colorScheme.secondaryContainer;
    Color background = Theme.of(context).colorScheme.background;
    Color textColor = Theme.of(context).colorScheme.onBackground;
    Color shadowColor = Theme.of(context).colorScheme.shadow;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Trips",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(10.0, 10.0),
                          blurRadius: 3.0,
                          color: shadowColor,
                        ),
                        Shadow(
                          offset: Offset(10.0, 10.0),
                          blurRadius: 8.0,
                          color: shadowColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: 15.0,
                    )
                  ],
                  color: containerColor,
                ),
                padding: const EdgeInsets.all(80),
                margin: const EdgeInsets.only(bottom: 10),
                height: 200.0,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Trip()),
                    );
                  },
                  icon: ImageIcon(
                    const AssetImage(
                        '/Users/addamvictorio/development/backpackcompanion/frontend/assets/images/outline_landscape_black_48dp.png'),
                    color: textColor,
                  ),
                ),
              ),

              // const SizedBox(
              //   height: 20,
              // ),
              // const SizedBox(
              //   height: 15,
              // ),
              // const SizedBox(
              //   height: 15,
              // ),
              Text(
                "Gear",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(10.0, 10.0),
                      blurRadius: 3.0,
                      color: shadowColor,
                    ),
                    Shadow(
                      offset: Offset(10.0, 10.0),
                      blurRadius: 8.0,
                      color: shadowColor,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: 15.0,
                    )
                  ],
                  color: containerColor,
                ),
                padding: const EdgeInsets.all(80),
                margin: const EdgeInsets.only(bottom: 10),
                height: 200.0,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Inventory()),
                    );
                  },
                  icon: ImageIcon(
                    const AssetImage(
                        '/Users/addamvictorio/development/backpackcompanion/frontend/assets/outline_backpack_black_48dp.png'),
                    color: textColor,
                  ),
                ),
              ),

              const Text("Meals",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
              Container(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: 15.0,
                    )
                  ],
                  color: containerColor,
                ),
                padding: const EdgeInsets.all(80),
                height: 200.0,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Inventory()),
                    );
                  },
                  icon: ImageIcon(
                    const AssetImage(
                        '/Users/addamvictorio/development/backpackcompanion/frontend/assets/outline_backpack_black_48dp.png'),
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(icon: Icon(Icons.menu), onPressed: () {}),
            Spacer(),
            IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
