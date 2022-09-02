import 'package:flutter/material.dart';
import 'package:frontend/color_schemes.g.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  @override
  Widget _buildStack() {
    ThemeData(useMaterial3: true, colorScheme: darkColorScheme);
    return Stack(
      alignment: const Alignment(0, 1),
      children: [
        Container(
          decoration: ShapeDecoration(
              color: Colors.white,
              shape: CircleBorder(
                side: BorderSide(width: 10, color: darkColorScheme.outline),
              )),
          child: const CircleAvatar(
            backgroundImage: NetworkImage(
                'https://www.pngitem.com/pimgs/m/35-350426_profile-icon-png-default-profile-picture-png-transparent.png'),
            radius: 50,
          ),
        ),
        // Container(
        //   decoration: BoxDecoration(
        //     color: darkColorScheme.surface,
        //   ),
        //   child: const Text(
        //     'hiker_first_name',
        //     style: TextStyle(
        //       fontSize: 20,
        //       fontWeight: FontWeight.bold,
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget iconButton(IconData icon, String label) {
    return Column(children: [
      IconButton(icon: Icon(icon), onPressed: () {}),
      Text(label)
    ]);
  }

  Widget statsBox() {
    ThemeData(useMaterial3: true, colorScheme: darkColorScheme);
    return Card(
      elevation: 15,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: darkColorScheme.outline,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Hiker Info",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Weight:",
                    style: TextStyle(fontSize: 15),
                  ),
                  Text("hiker_physical_weight")
                ],
              ),
              const Divider(
                height: 20,
                indent: 2,
                endIndent: 2,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Age:",
                      style: TextStyle(fontSize: 15),
                    ),
                    Text("hiker_age")
                  ]),
              const Divider(
                height: 20,
                indent: 2,
                endIndent: 2,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Gender:",
                      style: TextStyle(fontSize: 15),
                    ),
                    Text("hiker_natural_gender")
                  ]),
              const Divider(
                height: 20,
                indent: 2,
                endIndent: 2,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Hiker Speed:",
                      style: TextStyle(fontSize: 15),
                    ),
                    Text("hiker_avg_speed_flat")
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [iconButton(Icons.forest, 'Trips')]),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: darkColorScheme.background,
        appBar: AppBar(
            title: const Text(
          'Hiker Name',
        )),
        body: Column(
          children: [
            Container(
                margin: const EdgeInsets.only(
                    top: 20, left: 20, right: 20, bottom: 5),
                child: Center(
                  child: _buildStack(),
                )),
            const Center(
                child: Text("hiker_first_name + hiker_last_name",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ))),
            Container(
              margin: const EdgeInsets.only(
                  top: 10, left: 10, right: 10, bottom: 5),
              height: 400,
              child: statsBox(),
            )
          ],
        ));
    throw UnimplementedError();
  }
}
