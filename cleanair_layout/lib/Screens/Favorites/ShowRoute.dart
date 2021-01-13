import 'dart:async';
import 'package:cleanair_layout/BusinessLogic/Maps/gmaps.dart';
import 'package:cleanair_layout/Screens/Profile/add_elements/airpollutionwidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cleanair_layout/BusinessLogic/database/db.dart';
import 'package:flutter/material.dart';

class RouteShower extends StatefulWidget {
  final route_path;  
  RouteShower(this.route_path);

  @override
  RouteState createState() => RouteState(route_path);
}

class RouteState extends State<RouteShower> {
  
  int color_count;
  Future myFuture;
  Completer<GoogleMapController> _controller = Completer();
  Set<Polyline> _polylines = Set<Polyline>();
  String id;
  var co, pm25, no2, o3, no, pm10,so2,nh3;
  String googleAPIKey = "AIzaSyBOupgrKvCmQn5B3a3Vjn6WgG7FrpNU8f0";
  List<LatLng> polylineCoordinates = [];

  final List<dynamic> category = [Colors.green[400], 
                                  Colors.yellow[700],
                                  Colors.amber, 
                                  Colors.deepOrange, 
                                  Colors.red, 
                                  Colors.purple[900]];


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
    myFuture = setPolylines(); 
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

    var color_route = category[color_count - 1];
    print("color_count ${color_route}");
    print("adding a polyline");

    _polylines.add(Polyline(
        width: 5, // set the width of the polylines
        polylineId: PolylineId("TryAgain"),
        color: color_route,
        points: polylineCoordinates));
  }

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;


    return Scaffold(
        appBar: new AppBar(
            title: Text('Maps', style: TextStyle(color: Colors.black),),
            backgroundColor: Colors.white,
            elevation: 1.2,
            iconTheme: IconThemeData(
              color: Colors.black,
          ),
        ),
        body: FutureBuilder<dynamic>(
            future: myFuture,
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
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                    Container(
                                      height: size.height * 0.2,
                                      width: size.width * 0.99,
                                      child: GridView.count(
                                        crossAxisCount: 4,
                                        childAspectRatio: 3,
                                        children: [
                                          ParameterPollution(
                                            snapshot: this.co,
                                            data: 'co',
                                            padding: 0.0,
                                            color: Colors.black,
                                          ),
                                          ParameterPollution(
                                            snapshot: this.no,
                                            data: 'no',
                                            padding: 0.0,
                                            color: Colors.black,
                                          ),
                                          ParameterPollution(
                                            snapshot: this.no2,
                                            data: 'no2',
                                            padding: 0.0,
                                            color: Colors.black,
                                          ),
                                          ParameterPollution(
                                            snapshot: this.o3,
                                            data: 'o3',
                                            padding: 0.0,
                                            color: Colors.black,
                                          ),
                                          ParameterPollution(
                                            snapshot: this.so2,
                                            data: 'so2',
                                            padding: 0.0,
                                            color: Colors.black,
                                          ),
                                          ParameterPollution(
                                            snapshot: this.pm25,
                                            data: 'pm2.5',
                                            padding: 0.0,
                                            color: Colors.black,
                                          ),
                                          ParameterPollution(
                                            snapshot: this.pm10,
                                            data: 'pm10',
                                            padding: 0.0,
                                            color: Colors.black,
                                          ),
                                          ParameterPollution(
                                            snapshot: this.nh3,
                                            data: 'nh3',
                                            padding: 0.0,
                                            color: Colors.black,
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                          ),),
                    ],
                  );
              }
              return null; // unreachable
            }));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    this.no = 0;
    this.no2 = 0;
    this.o3 = 0;
    this.pm10 = 0;
    this.pm25 = 0;
    this.so2 = 0;
    this.co = 0;
    this.nh3 = 0;
  }
}
