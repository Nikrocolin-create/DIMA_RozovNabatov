import 'dart:convert';

import 'package:cleanair_layout/BusinessLogic/exceptions/503Unavailable.dart';
import 'package:cleanair_layout/BusinessLogic/database/db.dart';
import 'package:cleanair_layout/BusinessLogic/locationPollution/colorpollution.dart';
import 'package:cleanair_layout/BusinessLogic/locationPollution/location_polution.dart';
import 'package:cleanair_layout/constants.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(42.747932, -71.167889);
const LatLng DEST_LOCATION = LatLng(37.335685, -122.0605916);

class GMap extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => GMapState();
}

class ResponseParameters {
  var lat;
  var lon;
  Map<dynamic, dynamic> params;

  ResponseParameters(lt, ln, par) {
    lat = lt;
    lon = ln;
    params = par;
  }
}

Future<Map<dynamic, dynamic>> use_future(String url) async {

  var response = await http.get(url);

  if (response.statusCode == 200) {
    var value = json.decode(response.body)['list']; //json parser
    var value2 = json.decode(response.body)['coord'];

    ResponseParameters l = ResponseParameters(
        value2['lat'],
        value2['lon'],
        value[0]['components']
    );
    return l.params;
  } else {
    throw new ServiceUnavailableException("Service is down: ${response.statusCode}");
  }
}

class GMapState extends State<GMap> {
  APIWork color_return = new APIWork();
  Completer<GoogleMapController> _controller = Completer();
  bool start_run = true;
  bool action = false;
  int path_id;
  Set<Circle> _circles = Set<Circle>();
  //List<dynamic> cached_pollution;
  Map<dynamic, dynamic> cached_pollution;
  int reduce_calls=1;//уменьшить количество вызов api, счетчик
  List<LocationPollution> pol_path = [];
  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>(); // for my drawn routes on the map
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  String googleAPIKey = "AIzaSyBOupgrKvCmQn5B3a3Vjn6WgG7FrpNU8f0";
  LocationData
      currentLocation; // the user's initial location and current location as it moves
  LocationData destinationLocation; // a reference to the destination location
  Location location; // wrapper around the location API

  @override
  void initState() {
    super.initState();
    // create an instance of Location
    location = new Location();
    polylinePoints = PolylinePoints();
    get_max_id();
    location.onLocationChanged.listen((LocationData cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      currentLocation = cLoc;
      get_pollution();
      updatePinOnMap();
    });
    // set custom marker pins
    // set the initial location
    setInitialLocation();
  }
  
  void get_max_id() async {
    List<dynamic> newList;
    newList = await DB.max_query();
    if (newList.isNotEmpty) 
      if (this.mounted) {
        setState(() {
          path_id = newList.last['max(path)'] + 1;
        });
      } else {
        return;
      }
    else
      if (this.mounted) {
        setState(() {
          path_id = 1;
        });
      } else {
        return ;
      }
  }

  void get_pollution() async {
    
    reduce_calls++;
    if (!start_run && (reduce_calls % 2 == 0)) {
      DB.query("location_pollution");
      Map<dynamic, dynamic> newList;
      try{
        print("coordinates=${currentLocation.latitude},${currentLocation.longitude}");
      
           newList = await use_future("http://api.openweathermap.org/data/2.5/air_pollution?lat=${currentLocation.latitude}"+
                               "&lon=${currentLocation.longitude}&appid=$cleanAirAPIKey");

            cached_pollution = newList;

            pol_path.add(
              LocationPollution(
                path: path_id,
                latitude: currentLocation.latitude+0.0001*reduce_calls,
                longitude: currentLocation.longitude+0.0001*reduce_calls,
                o3: newList['o3'].toDouble(),
                pm25: newList['pm2_5'].toDouble(),
                co: newList['co'].toDouble(),
                no2: newList['no2'].toDouble(),
                no: newList['no'].toDouble(),
                so2: newList['so2'].toDouble(),
                pm10: newList['pm10'].toDouble(),
                nh3: newList['nh3'].toDouble(),
              )
            );
            print(pol_path);
      } catch(e) {
        
        newList = cached_pollution;
        if (cached_pollution == null)
          pol_path.add(LocationPollution(
            path: path_id,
            latitude: currentLocation.latitude+0.0001*reduce_calls,
            longitude: currentLocation.longitude+0.0001*reduce_calls,
            o3: 0.0,
            pm25: 0.0,
            co: 0.0,
            no2: 0.0,
            no: 0.0,
            so2: 0.0,
            pm10: 0.0,
            nh3: 0.0
        ));
        else
          pol_path.add(LocationPollution(
            path: path_id,
            latitude: currentLocation.latitude+0.0001*reduce_calls,
            longitude: currentLocation.longitude+0.0001*reduce_calls,
                o3: newList['o3'].toDouble(),
                pm25: newList['pm2_5'].toDouble(),
                co: newList['co'].toDouble(),
                no2: newList['no2'].toDouble(),
                no: newList['no'].toDouble(),
                so2: newList['so2'].toDouble(),
                pm10: newList['pm10'].toDouble(),
                nh3: newList['nh3'].toDouble(),
          ));
      }
      polylineCoordinates.add(LatLng(currentLocation.latitude+0.0001*reduce_calls,currentLocation.longitude+0.0001*reduce_calls));
      print(polylineCoordinates);
    }

  }



  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    currentLocation = await location.getLocation();
  }


  void setPolylines() async {
    if (this.mounted) {
      setState(() {
        _polylines.clear();
        print("adding a polyline");
        _polylines.add(Polyline(
          width: 5, // set the width of the polylines
          polylineId: PolylineId("poly"),
          color: Colors.red,
          points: polylineCoordinates));
      });
    } else {
      return ;
    }
  }

  void setCircles() async {
    int i = await color_return.returnColor();
    List<dynamic> category = [Colors.green[400],
      Colors.yellow[700],
      Colors.amber,
      Colors.deepOrange,
      Colors.red,
      Colors.purple[900]];
    if (this.mounted) {
      setState(() {
        _circles.clear();
        print("adding a circle");
        print(LatLng(currentLocation.latitude,currentLocation.longitude));
        _circles.add(
          Circle(
            circleId: CircleId("circle"),
            center: LatLng(currentLocation.latitude,currentLocation.longitude),
            radius: 100,
            strokeWidth: 5,
            strokeColor: category[i],
            fillColor: category[i].withOpacity(0.5)),
        );
      });
    } else {
      return ;
    }
  }

  void updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    if (this.mounted) {
      setState(() {
        // updated position
        var pinPosition =
        LatLng(currentLocation.latitude, currentLocation.longitude);

        // the trick is to remove the marker (by id)
        // and add it again at the updated location

      });
    } else {
      return ;
    }
  }
  
  void showPinsOnMap() {
    print("Setting polylines\n");
    setPolylines();
    setCircles();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION);
    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING);
    }
    return Scaffold(
        appBar: new AppBar(
          title: Text('Maps', style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white,
          elevation: 1.2,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        body: Column(
          children: [
            Expanded(
                flex: 7,
                child: GoogleMap(
                    myLocationEnabled: true,
                    compassEnabled: true,
                    tiltGesturesEnabled: false,
                    markers: _markers,
                    polylines: _polylines,
                    circles: _circles,
                    mapType: MapType.normal,
                    initialCameraPosition: initialCameraPosition,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      // my map has completed being created;
                      // i'm ready to show the pins on the map
                      showPinsOnMap();
                    })),
            Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () async {
                      if (this.mounted) {
                        setState(() {
                          start_run = !start_run;
                        });
                      } else {
                        return ;
                      }
                      if (start_run) {
                        action = await _asyncConfirmDialog(context);
                        if (action) {
                          setState(() {
                            path_id += 1;
                          });
                          var que = await DB.query("location_pollution");
                          print(que);
                          for (LocationPollution item in pol_path) {
                            await DB.insert('location_pollution', item);
                          }
                          print('Id has changed');
                          print(path_id);
                          action = false;
                          pol_path.clear(); //очищаем проделанный путь
                          polylineCoordinates.clear();
                          reduce_calls=1;
                        }
                      }
                    },
                    child: (start_run) ? Text('Start') : Text('Stop'),
                    color: (start_run) ? kPrimaryColor : Colors.red,
                    textColor: Colors.white,
                  ),
                )),
          ],
        ));
  }
}

Future _asyncConfirmDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Save the route?'),
        content: const Text(
            'You can watch it after'),
        actions: [
          FlatButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          )
        ],
      );
    },
  );
}