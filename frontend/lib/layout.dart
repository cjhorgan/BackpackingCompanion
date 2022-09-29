import 'package:flutter/material.dart';
import 'package:frontend/api/MealPlanProviders.dart';
import 'package:frontend/api/api.dart';
import 'package:frontend/home.dart';
import 'package:frontend/mealplan.dart';
import 'package:frontend/models/hiker.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/screens/createTrip.dart';
import 'package:frontend/screens/itemStorageViewer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/mealplan.dart';
import 'package:provider/provider.dart';
import 'Inventory.dart';
import 'color_schemes.g.dart';
import 'tripView.dart';
import 'globals.dart' as globals;
import 'package:collection/collection.dart';

class Layout extends StatefulWidget {
  const Layout({Key? key, this.trip, this.hiker}) : super(key: key);

  final Hiker? hiker;
  final Trip? trip;

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  Widget build(BuildContext context) {
    String s = ' ';

    final hiker = ModalRoute.of(context)!.settings.arguments as Hiker;
    final tripP = Provider.of<TripProvider>(context);
    final hikerP = Provider.of<HikerProvider>(context);
    final mealP = Provider.of<MealPlanProvider>(context);

    Trip? trip = tripP.getTrip(4);
    var mealPlan = mealP.mealplans[2];
    // .singleWhereOrNull(((mealplan) =>
    //     mealplan.mealplan_trip == trip!.trip_id!.toInt() &&
    //     mealplan.mealplan_hiker == hiker.hiker_id));

    List<dynamic> _hikers = [trip?.trip_hikers];
    List<Hiker> th = List.generate(
        _hikers.length, (index) => hikerP.getHiker(_hikers[index]));

    var name = trip?.trip_name;
    final bool tripo = globals.activeTrip;
    final invP = Provider.of<InventoryProvider>(context);

    var curInv = invP.inventorys.singleWhereOrNull(
        (inventory) => inventory.inventory_trip == trip?.trip_id!.toInt());
    ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        textTheme: GoogleFonts.aBeeZeeTextTheme());
    Color containerColor = Theme.of(context).colorScheme.secondaryContainer;
    // Color background = Theme.of(context).colorScheme.background;
    Color textColor = Theme.of(context).colorScheme.onBackground;
    Color shadowColor = Theme.of(context).colorScheme.shadow;
    return Scaffold(
        backgroundColor: darkColorScheme.background,
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   margin: const EdgeInsets.only(top: 10, left: 25),
            //   child: Text(
            //       style: GoogleFonts.roboto(
            //           textStyle: const TextStyle(
            //               fontSize: 30, fontWeight: FontWeight.w400)), (() {
            //     if (globals.activeTrip == false) {
            //       s = globals.activeTrip.toString();
            //       return s;
            //     } else {
            //       s = name;
            //       return s;
            //     }
            //   })()),
            // ),
            if (globals.activeTrip == true)
              Home(
                hiker: hiker,
              )
            // Card(
            //   shape: RoundedRectangleBorder(
            //     side: BorderSide(
            //       color: darkColorScheme.outline,
            //     ),
            //     borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
            //   ),
            //   elevation: 8,
            //   shadowColor: darkColorScheme.shadow,
            //   margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
            //   child: InkWell(
            //       splashColor: Colors.green.withAlpha(50),
            //       onTap: () {
            //         Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => FormWidgetsDemo(
            //                       hiker: hiker,
            //                     ),
            //                 settings: RouteSettings(arguments: hiker)));
            //         debugPrint('Card tapped.');
            //       },
            //       child: Container(
            //         padding: EdgeInsets.all(20),
            //         height: 200,
            //         width: double.infinity,
            //         child: const Center(
            //             child: Icon(
            //           Icons.hiking,
            //           size: 50,
            //         )),

            //         // child: Row(
            //         //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         //     crossAxisAlignment: CrossAxisAlignment.start,
            //         //     children: const [Text('1'), Text('2')])),
            //       )),
            // )
            else
              Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: darkColorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
                  ),
                  elevation: 8,
                  shadowColor: darkColorScheme.shadow,
                  margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
                  child: InkWell(
                    splashColor: Colors.green.withAlpha(50),
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => FormWidgetsDemo(
                      //               hiker: hiker,
                      //             ),
                      //         settings: RouteSettings(arguments: hiker)));
                      // debugPrint('Card tapped.');
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      height: 200,
                      width: double.infinity,
                      child: const Center(
                          child: Icon(
                        Icons.hiking,
                        size: 50,
                      )),

                      // child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: const [Text('1'), Text('2')])),
                    ),
                  )),
            // Container(
            //     margin: const EdgeInsets.only(left: 30),
            //     child: Text("Group",
            //         style: TextStyle(
            //           fontSize: 30,
            //           fontWeight: FontWeight.w400,
            //           shadows: <Shadow>[
            //             Shadow(
            //               offset: Offset(-5.0, 5.0),
            //               blurRadius: 2.0,
            //               color: darkColorScheme.shadow,
            //             ),
            //           ],
            //         ))),
            // Card(
            //   shape: RoundedRectangleBorder(
            //     side: BorderSide(
            //       color: darkColorScheme.outline,
            //     ),
            //     borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
            //   ),
            //   elevation: 8,
            //   shadowColor: darkColorScheme.shadow,
            //   margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
            //   child: Container(
            //     height: 100,
            //     width: double.infinity,
            //     child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceAround,
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: [
            //           for (int i = 0; i < th.length; i++)
            //             Text(th[i].hiker_first_name),
            //         ]),

            // child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: const [Text('1'), Text('2')])),
            //   ),
            // ),
            Container(
                // margin: const EdgeInsets.only(top: 5),
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Expanded(
                    child: Column(children: [
                      Container(
                          child: const Center(
                              child: Text("Pack",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w400,
                                  )))),
                      Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: darkColorScheme.outline,
                            ),
                            borderRadius:
                                BorderRadius.circular(20.0), //<-- SEE HERE
                          ),
                          elevation: 8,
                          shadowColor: darkColorScheme.shadow,
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 5),
                          child: InkWell(
                              splashColor: Colors.blue.withAlpha(50),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            (ItemStorageViewer())));
                                debugPrint('Card tapped.');
                              },
                              child: Container(
                                height: 120,

                                child: const Center(
                                    child: Icon(
                                  Icons.backpack,
                                  size: 30,
                                )),

                                // child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: const [Text('1'), Text('2')])),
                              )))
                    ]),
                  ),
                  Expanded(
                    child: Column(children: [
                      Container(
                          child: const Center(
                              child: Text("Meal",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w400,
                                  )))),
                      Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: darkColorScheme.outline,
                            ),
                            borderRadius:
                                BorderRadius.circular(20.0), //<-- SEE HERE
                          ),
                          elevation: 8,
                          shadowColor: darkColorScheme.shadow,
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 5),
                          child: InkWell(
                              splashColor: Colors.blue.withAlpha(50),
                              onTap: () {
                                print(mealPlan.mealplan_hiker);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => (MealPlanScreen(
                                              mealplan: mealPlan,
                                              curHiker: hiker,
                                              curTrip: trip,
                                              curInventory: curInv,
                                            ))));
                                debugPrint('Card tapped.');
                              },
                              child: Container(
                                height: 120,

                                child: const Center(
                                    child: Icon(
                                  Icons.local_dining,
                                  size: 30,
                                )),

                                // child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: const [Text('1'), Text('2')])),
                              )))
                    ]),
                  ),
                ])),
          ],
        )));
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
  }
}
