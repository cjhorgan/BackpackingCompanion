import 'package:flutter/material.dart';
import 'package:frontend/screens/createTrip.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Inventory.dart';
import 'color_schemes.g.dart';
import 'tripView.dart';

class Layout extends StatelessWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            Container(
                margin: const EdgeInsets.only(top: 10, left: 25),
                child: Text("Current Trip",
                    style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                    )))),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FormWidgetsDemo()));
                    debugPrint('Card tapped.');
                  },
                  child: Container(
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
                  )),
            ),
            Container(
                margin: const EdgeInsets.only(left: 30),
                child: Text("Group",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(-5.0, 5.0),
                          blurRadius: 2.0,
                          color: darkColorScheme.shadow,
                        ),
                      ],
                    ))),
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
              child: Container(
                height: 100,
                width: double.infinity,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(Icons.account_circle_sharp),
                      Icon(Icons.account_circle_sharp),
                      Icon(Icons.account_circle_sharp),
                      Icon(Icons.account_circle_sharp)
                    ]),

                // child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: const [Text('1'), Text('2')])),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 5),
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
                                    debugPrint('Card tapped.');
                                  },
                                  child: Container(
                                    height: 150,

                                    child: const Center(
                                        child: Icon(
                                      Icons.backpack,
                                      size: 50,
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
                              child: Container(
                                height: 150,

                                child: const Center(
                                    child: Icon(
                                  Icons.local_dining,
                                  size: 50,
                                )),

                                // child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: const [Text('1'), Text('2')])),
                              ))
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
