import 'package:flutter/material.dart';
import 'package:frontend/api/api.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'models/trip.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

class TripView extends StatelessWidget {
  const TripView({super.key, required Trip trip});

  @override
  @override
  Widget build(BuildContext context) {
    final trip = ModalRoute.of(context)!.settings.arguments as Trip;
    Color textColor = Theme.of(context).colorScheme.onSurfaceVariant;
    Color headlineColor = Theme.of(context).colorScheme.onSurface;
    final tripP = Provider.of<TripProvider>(context);

    // List.generate(
    //     20,
    //     (i) => Trip(
    //           trip_id: i,
    //           trip_name: '$i',
    //           trip_plan_start_datetime: DateTime.parse(i),
    //           trip_plan_end_datetime: DateTime.fromMillisecondsSinceEpoch(i),
    //         ));
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: tripP.trips.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              trailing: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    tripP.deleteTrip(tripP.trips[index]);
                  }),
              title: Text(trip.trip_id.toString(),
                  style: TextStyle(color: headlineColor)),
              subtitle: Text(
                "date: ${tripP.trips[index].trip_plan_start_datetime}",
                style: TextStyle(fontSize: 15, color: textColor),
              ));
        },
      ),
    );
  }
}

// class TripView extends StatelessWidget {
//   const TripView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final tripP = Provider.of<tripProvider>(context);
//     Widget titleSection = Container(
//       padding: const EdgeInsets.all(32),
//       child: Row(
//         children: [
//           Expanded(
//             /*1*/
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /*2*/
//                 Container(
//                   padding: const EdgeInsets.only(bottom: 8),
//                   child: const Text(
//                     'Trip Name',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   'Trip Location',
//                   style: TextStyle(
//                     color: Colors.grey[500],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           /*3*/
//           Icon(
//             Icons.star,
//             color: Colors.red[500],
//           ),
//           const Text('41'),
//         ],
//       ),
//     );

//     Color containerColor = Theme.of(context).colorScheme.secondaryContainer;
//     Color background = Theme.of(context).colorScheme.background;
//     Color textColor = Theme.of(context).colorScheme.onBackground;
//     Color shadowColor = Theme.of(context).colorScheme.shadow;

//     Widget buttonSection = Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         _buildButtonColumn(textColor, Icons.call, 'CALL'),
//         _buildButtonColumn(textColor, Icons.near_me, 'ROUTE'),
//         _buildButtonColumn(textColor, Icons.share, 'SHARE'),
//       ],
//     );

//     Widget textSection = const Padding(
//       padding: EdgeInsets.all(32),
//       child: Text(
//         'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
//         'Alps. Situated 1,578 meters above sea level, it is one of the '
//         'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
//         'half-hour walk through pastures and pine forest, leads you to the '
//         'lake, which warms to 20 degrees Celsius in the summer. Activities '
//         'enjoyed here include rowing, and riding the summer toboggan run.',
//         softWrap: true,
//       ),
//     );

//     return Scaffold(
//       body: ListView(
//         children: [
//           Image.asset(
//             '/Users/addamvictorio/development/backpackcompanion/frontend/assets/images/ys.jpg',
//             fit: BoxFit.cover,
//           ),
//           titleSection,
//           buttonSection,
//           textSection,
//         ],
//       ),
//     );
//   }

//   Column _buildButtonColumn(Color color, IconData icon, String label) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(icon, color: color),
//         Container(
//           margin: const EdgeInsets.only(top: 8),
//           child: Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w400,
//               color: color,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

