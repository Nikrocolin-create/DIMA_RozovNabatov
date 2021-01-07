import 'dart:async';
import 'gmap.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'db.dart';
import 'Pages.dart';
import 'main.dart';

class RouteShower extends StatefulWidget {
  final route_path;

  RouteShower(@required this.route_path);

  @override
  RouteState createState() => RouteState(route_path);
}

class RouteState extends State<RouteShower> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Polyline> _polylines = Set<Polyline>();
  String id;
  var co, pm25, no2, o3;
  String googleAPIKey = "AIzaSyBOupgrKvCmQn5B3a3Vjn6WgG7FrpNU8f0";
  List<LatLng> polylineCoordinates = [];

  RouteState(route_path) {
    id = route_path;
    co=0; pm25=0; no2=0; o3=0;
  }

  @override
  void initState() {
    super.initState();
    // create an instance of Location
  }

  void setRoute() async {
    print("Route");
    var smt = await DB.path_query(int.parse(id));
    for (var item in smt) {
      //могу в асинхронной написать сетстейт
      print(no2.runtimeType);
      print(item['co']);
      co += item['co']; no2+=item['no2']; pm25+=item['pm25']; o3=item['o3'];
      polylineCoordinates.add(LatLng(
          item['latitude'],
          item['longitude'])); // если заработает то получается возвращаемый тип ~ список словарей
    }
    co/=smt.length;
    no2/=smt.length;
    pm25/=smt.length;
    o3/=smt.length;
  }

  Future<void> setPolylines() async {
    await setRoute();
    print("setting route ${polylineCoordinates.length}");
    //setState(() { бесконечный цикл может проблема в сетстейте
      _polylines.clear();
      print("adding a polyline");
      _polylines.add(Polyline(
          width: 8, // set the width of the polylines
          polylineId: PolylineId("TryAgain"),
          color: Colors.red,
          points: polylineCoordinates));
    //});
  }

  Widget build(BuildContext context) {

    return Scaffold(
        appBar: new AppBar(
          title: new Text("Map"),
          actions: [
            PopupMenuButton(
              onSelected: (String choice) {
                if (choice == "/")
                  Navigator.pushNamed(context, '/');
                else if (choice == '/my_routes')
                  Navigator.pushNamed(context, '/my_routes');
              },
              itemBuilder: (BuildContext context) {
                return Pages.choices.map((String choice) {
                  return PopupMenuItem(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: FutureBuilder<dynamic>(
            future: setPolylines(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('Uninitialized');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Text('Awaiting result...');
                case ConnectionState.done:
                  if (snapshot.hasError) throw snapshot.error;
                  CameraPosition initialCameraPosition = CameraPosition(
                      zoom: CAMERA_ZOOM,
                      tilt: CAMERA_TILT,
                      bearing: CAMERA_BEARING,
                      target: polylineCoordinates.last,);
                  print(_polylines.length);
                  print("setting route ${polylineCoordinates.length}");
                  return Column(
                    children: [
                      Expanded(
                          flex: 7,
                          child: GoogleMap(
                            myLocationEnabled: false,
                            compassEnabled: true,
                            tiltGesturesEnabled: false,
                            polylines: _polylines,
                            mapType: MapType.normal,
                            initialCameraPosition: initialCameraPosition,
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                          )),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text("o3-${o3}"),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text("co-${co}"),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text("pm25-${pm25}"),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.topCenter,
                                        child: Text("no2-${no2}"),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
              }
              return null; // unreachable
            }));
  }
}
