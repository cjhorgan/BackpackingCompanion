import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geojson/geojson.dart';
import 'package:map_elevation/map_elevation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_dragmarker/dragmarker.dart';
import 'package:flutter_map_line_editor/polyeditor.dart';

import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

import 'elevationData/kelsoElevation.dart';

class Mapping extends StatefulWidget {
  const Mapping({Key? key}) : super(key: key);

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Mapping> {
  final mapController = MapController();
  final lines = <Polyline>[];
  //final marker = <Marker>[];
  ElevationPoint? hoverPoint;
  final kelso = LatLng(34.8922621, -115.6989714);
  final mary = LatLng(34.9443528, -115.5133921);
  PolyEditor? polyEditor;
  String url = '';
  List<Polyline> polyLines = [];
  var testPolyline = Polyline(color: Colors.deepOrange, points: []);

  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    locationPermissionRequest();

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use `MapController` as needed
      mapController.move(kelso, 2);
    });
    polyEditor = PolyEditor(
      addClosePathMarker: false,
      points: testPolyline.points,
      pointIcon: const Icon(Icons.crop_square, size: 23),
      intermediateIcon: const Icon(Icons.lens, size: 15, color: Colors.grey),
      // callbackRefresh: () => {
      //   setState(() {
      //     processLines();
      //   })
      // },
    );

    polyLines.add(testPolyline);
  }

  Future<void> processLines() async {
    final data = await rootBundle
        .loadString('frontend/assets/geojson/southmojave.geojson');
    final geojson = GeoJson();
    geojson.processedLines.listen((GeoJsonLine line) {
      setState(() => lines.add(Polyline(
          color: Colors.blue,
          strokeWidth: 2.0,
          points: line.geoSerie!.toLatLng())));
    });
    geojson.endSignal.listen((_) => geojson.dispose());
    unawaited(geojson.parse(data, verbose: false));
  }

  /* Load GeoJson Markers
  Future<void> processMarkers () async {
    final data = await rootBundle
        .loadString('assets/geojson/southmojave.geojson');
    final geojson = GeoJson();
    geojson.processedPoints.listen((GeoJsonPoint marker) {
      setState(() => markers.add(Marker(
          builder: (context) => FlutterLogo(),
          width: 50,
          height: 50,
          point: markers.geoPoint!.toLatLng())));
    });
    geojson.endSignal.listen((_) => geojson.dispose());
    unawaited(geojson.parse(data, verbose: true));
  }
  */

  Future<void> locationPermissionRequest() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    Tile t;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Mapping'),
          actions: [
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
                var count = 0;
                if (count == 0) {
                  mapController.move(kelso, 3);
                  count++;
                } else {
                  mapController.move(mary, 3);
                }
              },
              icon: const Icon(Icons.search),
            )
          ],
        ),
        body: Builder(builder: (BuildContext context) {
          return Center(
              child: Container(
                  child: Column(
            children: [
              Flexible(
                  child: Screenshot(
                controller: screenshotController,
                child: FlutterMap(
                  mapController: MapController(),
                  options: MapOptions(
                    center: kelso,
                    zoom: 10,
                    plugins: [
                      const LocationMarkerPlugin(),
                      DragMarkerPlugin(),
                    ],
                  ),
                  layers: [
                    TileLayerOptions(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c']),
                    PolylineLayerOptions(polylines: lines),
                    MarkerLayerOptions(markers: [
                      if (hoverPoint != null)
                        Marker(
                            point: hoverPoint!.latLng,
                            width: 8,
                            height: 8,
                            builder: (BuildContext context) => Container(
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(8))))
                    ]),
                    LocationMarkerLayerOptions(),
                  ],
                ),
              )),
              FloatingActionButton(
                  child: const Icon(Icons.download),
                  onPressed: () {
                    screenshotController.capture(pixelRatio: 2.0);

                    print(Map);
                  }),
              /*
                  FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () {
                      setState(() { 
                      });
                    }
                  ),
                  */
              ElevatedButton(
                child: const Text('Show Elevation'),
                onPressed: () {
                  Scaffold.of(context).showBottomSheet<void>(
                    (BuildContext context) {
                      return Container(
                        height: 200,
                        color: Colors.grey,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                color: Colors.white.withOpacity(0.6),
                                margin: const EdgeInsets.all(10.0),
                                width: 400.0,
                                height: 130.0,
                                child: NotificationListener<
                                    ElevationHoverNotification>(
                                  onNotification: (ElevationHoverNotification
                                      notification) {
                                    setState(() {
                                      hoverPoint = notification.position;
                                    });
                                    return true;
                                  },
                                  child: Elevation(
                                    getPoints(),
                                    color: Colors.grey,
                                    elevationGradientColors:
                                        ElevationGradientColors(
                                            gt10: Colors.green,
                                            gt20: Colors.orangeAccent,
                                            gt30: Colors.redAccent),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                  child: const Text('Close Elevation'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  })
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            ],
          )));
        }));
  }
}

Future<void> searchGeoJSON() async {
  final geo = GeoJson();
  await geo.searchInFile("southmojave.geojson",
      query: GeoJsonQuery(
        matchCase: false,
        property: "name",
      ),
      verbose: true);
  List<GeoJsonFeature> result = geo.features;
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = [
    "Kelso Dunes Trail",
    "Silver Peak Trail",
    "Hole-in-the-Wall Rings Trail",
    "Mary Beal Nature Trail",
    "Barber Peak Trail",
    "North Mid Hills Trail",
    "Rock Spring Trail",
    "Kessler Peak Trail",
    "New York Mountain Trail"
  ];

// first overwrite to
// clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

// second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

// third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var trail in searchTerms) {
      if (trail.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(trail);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            close(context, null);
          },
        );
      },
    );
  }

// last overwrite to show the
// querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var trail in searchTerms) {
      if (trail.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(trail);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            close(context, null);
          },
        );
      },
    );
  }
}
