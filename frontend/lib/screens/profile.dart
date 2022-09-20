import 'package:flutter/material.dart';
import 'package:frontend/color_schemes.g.dart';
import 'package:frontend/hikerList.dart';
import 'package:frontend/models/hiker.dart';

class Profile extends StatelessWidget {
  const Profile({super.key, required this.hiker});
  final Hiker hiker;

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

  Widget statsBox(
      String weight, String height, String age, String gender, String speed) {
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
                children: [
                  const Text(
                    "Weight:",
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(weight)
                ],
              ),
              const Divider(
                height: 20,
                indent: 2,
                endIndent: 2,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text(
                  "Age:",
                  style: TextStyle(fontSize: 15),
                ),
                Text(age)
              ]),
              const Divider(
                height: 20,
                indent: 2,
                endIndent: 2,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text(
                  "Gender:",
                  style: TextStyle(fontSize: 15),
                ),
                Text(gender)
              ]),
              const Divider(
                height: 20,
                indent: 2,
                endIndent: 2,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text(
                  "Hiker Speed:",
                  style: TextStyle(fontSize: 15),
                ),
                Text(speed)
              ]),
              Row(children: [
                iconButton(Icons.forest, 'Trips'),
                iconButton(Icons.backpack, 'Pack')
              ]),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hiker = ModalRoute.of(context)!.settings.arguments as Hiker;
    return Scaffold(
        backgroundColor: darkColorScheme.background,
        appBar: AppBar(
            title: Text(
          hiker.hiker_first_name,
        )),
        body: Column(
          children: [
            Container(
                margin: const EdgeInsets.only(
                    top: 20, left: 20, right: 20, bottom: 5),
                child: Center(
                  child: _buildStack(),
                )),
            Center(
                child:
                    Text(hiker.hiker_first_name + " " + hiker.hiker_last_name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ))),
            Container(
              margin: const EdgeInsets.only(
                  top: 10, left: 10, right: 10, bottom: 5),
              height: 400,
              child: statsBox(
                  hiker.hiker_physical_weight.toString(),
                  hiker.hiker_height_inch.toString(),
                  hiker.hiker_age.toString(),
                  hiker.hiker_natural_gender,
                  hiker.hiker_avg_speed_flat.toString()),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom()
                  .copyWith(elevation: ButtonStyleButton.allOrNull(10.0)),
              onPressed: () {
                Navigator.of(context)
                  ..pop()
                  ..pushReplacement(MaterialPageRoute(
                      builder: (context) => const HikerList()));

                // Pass the arguments as part of the RouteSettings. The
                // DetailScreen reads the arguments from these settings.
              },
              child: Text(
                'Sign Out',
                style: TextStyle(
                    color: darkColorScheme.onPrimaryContainer, fontSize: 20),
              ),
            ),
          ],
        ));
    throw UnimplementedError();
  }
}
