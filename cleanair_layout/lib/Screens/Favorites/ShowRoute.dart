import 'dart:async';
import 'package:cleanair_layout/BusinessLogic/Maps/gmaps.dart';
import 'package:cleanair_layout/Screens/Profile/add_elements/airpollutionwidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cleanair_layout/BusinessLogic/database/db.dart';
import 'package:cleanair_layout/BusinessLogic/locationPollution/colorpollution.dart';
import 'package:flutter/material.dart';

class RouteShower extends StatefulWidget {
  final route_path;

  RouteShower(@required this.route_path);

  @override
  RouteState createState() => RouteState(route_path);
}

class RouteState extends State<RouteShower> {
  int color_count;
  Completer<GoogleMapController> _controller = Completer();
  Set<Polyline> _polylines = Set<Polyline>();
  String id;
  var co, pm25, no2, o3, no, pm10,so2,nh3;
  String googleAPIKey = "AIzaSyBOupgrKvCmQn5B3a3Vjn6WgG7FrpNU8f0";
  List<LatLng> polylineCoordinates = [];

  RouteState(route_path) {
    id = route_path;
    co = 0;
    pm25 = 0;
    no2 = 0;
    o3 = 0;
    no=0;
    pm10 = 0;
    so2 = 0;
    nh3 = 0;
    color_count = 0;
  }

  @override
  void initState() {
    super.initState();
    // create an instance of Location
  }

  void setRoute() async {
    print("Route");
    int zeros = 0;
    var smt = await DB.path_query(int.parse(id));
    print("setRoute: ${smt[0]["aqi"]}");
    color_count = smt[0]["aqi"];
    print(smt);
    for (var item in smt) {
      //могу в асинхронной написать сетстейт
      co += item['co'];
      no2 += item['no2'];
      pm25 += item['pm25'];
      o3 += item['o3'];
      no += item['no'];
      pm10 += item['pm10'];
      so2 += item['so2'];
      nh3 += item['nh3'];
      polylineCoordinates.add(LatLng(
          item['latitude'],
          item['longitude'])); // если заработает то получается возвращаемый тип ~ список словарей
    }
    co /= (smt.length - zeros);
    no2 /= (smt.length - zeros);
    pm25 /= (smt.length - zeros);
    o3 /= (smt.length - zeros);
    no /= smt.length;
    pm10 /= smt.length;
    so2 /= smt.length;
    nh3 /= smt.length;
  }

  Future<void> setPolylines() async {
    await setRoute();
    print("setting route ${polylineCoordinates.length}");
    //setState(() { бесконечный цикл может проблема в сетстейте
    _polylines.clear();
    print("color_count ${color_count}");
    List<dynamic> category = [Colors.green[400],
      Colors.yellow[700],
      Colors.amber,
      Colors.deepOrange,
      Colors.red,
      Colors.purple[900]];
    var color_route = category[color_count-1];
    print("color_count ${color_route}");
    print("adding a polyline");
    _polylines.add(Polyline(
        width: 5, // set the width of the polylines
        polylineId: PolylineId("TryAgain"),
        color: color_route,
        points: polylineCoordinates));
    //});
  }

  Widget build(BuildContext context) {
    final APIWork ap = new APIWork();

    Stream <int> getColor() async* {
      yield* Stream.periodic(Duration(seconds: 10), (_) {
        return ap.returnColor();
      }).asyncMap((event) async => event);
    }

    Stream<Map<String, dynamic>> getMeasure() async* {
      yield* Stream.periodic(Duration(seconds: 10), (_) {
        return ap.getMeasures();
      }).asyncMap((event) async => event);
    }
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Map"/*,style: TextStyle(color: Colors.black),*/),
          //backgroundColor: Color(0xFFE0F7FA),
        ),
        body: FutureBuilder<dynamic>(
            future: setPolylines(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StreamBuilder<Map<String, dynamic>>(
                                stream: getMeasure(),
                                builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                                  if (snapshot.hasData) {
                                    return Container(
                                      child: GridView.count(
                                        crossAxisCount: 4,
                                        childAspectRatio: 2,
                                        children: [
                                          ParameterPollution(
                                            snapshot: snapshot.data['co'],
                                            data: 'co',
                                          ),
                                          ParameterPollution(
                                            snapshot: snapshot.data['no'],
                                            data: 'no',
                                          ),
                                          ParameterPollution(
                                            snapshot: snapshot.data['no2'],
                                            data: 'no2',
                                          ),
                                          ParameterPollution(
                                            snapshot: snapshot.data['o3'],
                                            data: 'o3',
                                          ),
                                          ParameterPollution(
                                            snapshot: snapshot.data['so2'],
                                            data: 'so2',
                                          ),
                                          ParameterPollution(
                                            snapshot: snapshot.data['pm2_5'],
                                            data: 'pm2.5',
                                          ),
                                          ParameterPollution(
                                            snapshot: snapshot.data['pm10'],
                                            data: 'pm10',
                                          ),
                                          ParameterPollution(
                                            snapshot: snapshot.data['nh3'],
                                            data: 'nh3',
                                          ),
                                        ],
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Container(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 80),
                                        child: Text(
                                          'The data will be soon!\nWait a few seconds',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 140),
                                          child: CircularProgressIndicator(),
                                        )
                                    );
                                  }
                                },
                              ),
                            ],
                          ),),
                    ],
                  );
              }
              return null; // unreachable
            }));
  }
}
