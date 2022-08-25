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
        const CircleAvatar(
          backgroundImage: NetworkImage(
              'https://www.pngitem.com/pimgs/m/35-350426_profile-icon-png-default-profile-picture-png-transparent.png'),
          radius: 100,
        ),
        Container(
          decoration: BoxDecoration(
            color: darkColorScheme.surface,
          ),
          child: const Text(
            'hiker_first_name',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Item Name'),
        ),
        body: Column(
          children: [
            Container(
                margin: const EdgeInsets.only(
                    top: 20, left: 20, right: 20, bottom: 5),
                child: Center(
                  child: _buildStack(),
                )),
            Row(children: const [Text("dscdc")]),
          ],
        ));
    throw UnimplementedError();
  }
}
