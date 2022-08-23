import 'package:flutter/material.dart';
import 'package:frontend/api/api.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'dash.dart';
import 'color_schemes.g.dart';
import 'BottomTrav.dart';
import 'screens/createTrip.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    Color containerColor = Theme.of(context).colorScheme.surface;
    Color background = Theme.of(context).colorScheme.background;
    Color textColor = Theme.of(context).colorScheme.onSurface;
    Color shadowColor = Theme.of(context).colorScheme.shadow;
    // ··· Widget build(BuildContext context) {
    Widget tripOverview =
        Container(child: _buildCard("Location", 310, 110, 20, context));

    Color color = Theme.of(context).primaryColor;

    Widget packSection = _buildCard("Pack", 210, 10, 20, context);

    Widget hikersSection = _buildCard("Hikers", 110, 110, 20, context);

    return Scaffold(
      backgroundColor: background,
      body: ListView(children: [
        // Container(
        //   margin: const EdgeInsets.only(left: 10),
        //   child: Text(
        //     "Trip",
        //     style: TextStyle(
        //       fontSize: 26,
        //       fontWeight: FontWeight.bold,
        //       shadows: <Shadow>[
        //         Shadow(
        //           offset: Offset(10.0, 10.0),
        //           blurRadius: 3.0,
        //           color: shadowColor,
        //         ),
        //         Shadow(
        //           offset: Offset(10.0, 10.0),
        //           blurRadius: 8.0,
        //           color: shadowColor,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),

        tripOverview,
        hikersSection,
        packSection
      ]),
    );
  }
}

Widget headerText(String label, double x) {
  return Container(
      margin: const EdgeInsets.only(top: 15, left: 10),
      child: Stack(
        children: <Widget>[
          // Stroked text as border.
          Text(
            label,
            style: TextStyle(
              fontSize: x,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 6
                ..color = darkColorScheme.onInverseSurface,
            ),
          ),
          // Solid text as fill.
          Text(
            label,
            style: TextStyle(
              fontSize: x,
              color: darkColorScheme.onSurface,
            ),
          ),
        ],
      ));
// )Text(
//         label,
//         style: TextStyle(
//           fontSize: x,

//           foreground: Paint()
//             ..style = PaintingStyle.stroke
//             ..strokeWidth = 2
//             ..color = Color.fromARGB(255, 211, 3, 3),

//           fontWeight: FontWeight.bold,
//           // shadows: <Shadow>[
//           //   Shadow(
//           //     offset: Offset(10.0, 10.0),
//           //     blurRadius: 3.0,
//           //     color: darkColorScheme.shadow,
//           //   ),
//           //   Shadow(
//           //     offset: Offset(10.0, 10.0),
//           //     blurRadius: 8.0,
//           //     color: darkColorScheme.shadow,
//           //   ),
//           // ],
//         ),
//       ));
}

Container _buildContainer(
    String label, double x, double height, double width, BuildContext context) {
  ThemeData(useMaterial3: true, colorScheme: darkColorScheme);
  return Container(
      height: height,
      width: width,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child: Center(
                    child: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FormWidgetsDemo()));
                        }))),
            Container(
                margin: const EdgeInsets.only(bottom: 15, left: 10),
                child: headerText(label, x)),
          ]));
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

Widget _buildCard(
    String label, double x, double y, double size, BuildContext context) {
  ThemeData(useMaterial3: true, colorScheme: darkColorScheme);

  return SizedBox(
      height: x,
      width: y,
      child: Card(
          elevation: 1,
          color: darkColorScheme.surface,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: darkColorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(0),
          ),
          child: _buildContainer(label, size, x, y, context)));
}
