import 'dart:async';
import "dart:convert";
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;


void main(){
  return runApp(MyApp());
}

void use_future(String url){
  get_res(url).then((value) {
    print("hello");
    print(value);
  });
}
LatLng get_loc(){
  Location().getLocation().then((l) {
    print("${l.latitude},${180.0+l.longitude}");
    return LatLng(l.latitude,180.0+l.longitude);
  });
}
//"https://www.myurl.com/api/v1/test/123/?param1=one&param2=two";
Future<String> get_res(url) async {
  // Location location = Location();
  // var p = await location.getLocation();
  // print("&coordinates=${p.latitude},${p.longitude}");
  // var p = await Geolocator().getCurrentPosition();
  // print("coordinates=${p.latitude.toString()},${p.longitude.toString()}");
  var response = await http.get(url);
  print(response.statusCode);
  if (response.statusCode == 200){
    print(json.decode(response.body));
  }

}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMS Client',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  Marker _marker;
  Timer _timer;
  int _markerIndex = 0;
  Location location = Location();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        location.getLocation().then((p) {
          use_future("https://api.openaq.org/v1/locations/?coordinates=${p.latitude},${p.longitude}&radius=20000");
          _marker = Marker(
            width: 80.0,
            height: 80.0,
            point: get_loc(),
            builder: (ctx) => Container(
              child: Icon(Icons.directions_car),
            ),
          );
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_marker == null) {
      return new Container();
    }

    return Scaffold(
      appBar: new AppBar(title: new Text("Карта")),
      body: FlutterMap(
        options: new MapOptions(
          center: get_loc(),
          zoom: 12.0,
        ),
        layers: [
          new TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(markers: <Marker>[_marker]),
          CircleLayerOptions(
              circles: [CircleMarker( //radius marker
                  point: get_loc(),
                  color: Colors.red.withOpacity(0.5),
                  borderStrokeWidth: 3.0,
                  borderColor: Colors.red,
                  radius: 100 //radius
              )]
          )
        ],
      ),
    );
  }
}