import 'dart:async';
import "dart:convert";
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

String API_KEY = "AIzaSyBOupgrKvCmQn5B3a3Vjn6WgG7FrpNU8f0";

void main() {
  return runApp(MyApp());
}

class ResponseParameters {
  var lat;
  var lon;
  List<dynamic> params;

  ResponseParameters(lt, ln, par) {
    lat = lt;
    lon = ln;
    params = par;
  }

  void printer() {
    print("lat: ${lat} ");
    print("lon: ${lon} ");
    print("All items");
    for (var l in params) {
      for (var item in l.entries) {
        // item представляет MapEntry<K, V>
        print("${item.key} - ${item.value}");
      }
    }
  }

  double polution_value(String name) {
    double sum;
    for (var l in params) {
      for (var item in l.entries) {
        if (item.key == name) sum += item.value;
      }
    }
    return sum;
  }
}

Future<List<dynamic>> use_future(String url) async {
  //оборачиваем асинхр. функцию для вызова
  List<dynamic> list_responses = [];
  dynamic value = await get_res(url);
  for (int i = 0; i < value.length; i++) {
    ResponseParameters l = ResponseParameters(
        value[i]['coordinates']['latitude'],
        value[i]['coordinates']['longitude'],
        value[i]['countsByMeasurement']);
    list_responses.add(l);
    print(value[i]['coordinates']['latitude']);
    print(value[i]['coordinates']['longitude']);
    print(value[i]['countsByMeasurement'].runtimeType);
  }
  print("Lensize ${list_responses.length}");
  return list_responses;
}

//"https://www.myurl.com/api/v1/test/123/?param1=one&param2=two";
Future<List<dynamic>> get_res(url) async {
  //асинхронная функция для работы с api
  var response = await http.get(url);
  print(response.statusCode);
  if (response.statusCode == 200) {
    var to_parse = json.decode(response.body)['results']; //будущий парсер json
    print(to_parse);
    return to_parse;
  }
}

Future<dynamic> get_reg(url) async {
  //асинхронная функция для работы с api
  var response = await http.get(url);
  print(response.statusCode);
  if (response.statusCode == 200) {
    var to_parse = json.decode(response.body); //будущий парсер json
    print(to_parse);
    return to_parse;
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
      home: HomePage(), //Через column не запихивается
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
  // здесь начинается магия
  Marker _marker;
  bool start_run;
  Timer _timer;
  dynamic _district;
  List<dynamic> list_responses;
  Geolocator _geolocator;
  Position _position;

  void updateLocation() async {
    //функция для обновления локации (ваш кеп)
    print("!");
    try {
      Position newPosition = await Geolocator()
          .getCurrentPosition()
          .timeout(new Duration(seconds: 5));
      print("coordinates=${newPosition.latitude},${newPosition.longitude}");
      //List<dynamic> newList = await use_future("https://api.openaq.org/v1/locations/?coordinates=${newPosition.latitude},${newPosition.longitude}&order_by=distance");;
      //dynamic new_district = await get_reg("https://maps.googleapis.com/maps/api/geocode/json?latlng=${newPosition.latitude},${newPosition.longitude}&key=${API_KEY},&sensor=false");
      setState(() {
        //_district = new_district;
        _position = newPosition;
        //list_responses = newList;
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    start_run = true;
    _geolocator = Geolocator();
    updateLocation();
    _timer = Timer.periodic(Duration(seconds: 10), (_) {
      //обновление состояния по таймеру
      setState(() {
        _marker = Marker(
            //
            width: 80.0,
            height: 80.0,
            point: LatLng(_position.latitude, _position.longitude),
            builder: (ctx) => Container(
                  child: Icon(Icons.accessible_forward),
                ));
      });
    });
  }

  @override
  void dispose() {
    //сам не знаю, что это но походу сброс таймера
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    if (_marker == null) {
      return new Container();
    }

    return Scaffold(
        key: _scaffoldKey,
        // Попытался загнать карту через column, опять пошел нахуй, хотя через container норм, нужно ебашить column->expanded->map
        appBar: new AppBar(title: new Text("Карта")),
        body: Column(
          children: [
            Expanded(
                flex: 7,
                child: FlutterMap(
                  options: new MapOptions(
                    center: LatLng(_position.latitude, _position.longitude),
                    zoom: 12.0,
                  ),
                  layers: [
                    new TileLayerOptions(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayerOptions(markers: <Marker>[_marker]),
                    CircleLayerOptions(circles: [
                      CircleMarker(
                          //radius marker
                          point:
                              LatLng(_position.latitude, _position.longitude),
                          color: method_for_color(),
                          borderStrokeWidth: 3.0,
                          borderColor: Colors.red,
                          radius: 100 //radius
                          )
                    ])
                  ],
                )),
            Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () async {
                      setState(() {
                        start_run = !start_run;
                      });
                      if (start_run) {
                            bool value = await Navigator.push(context, PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (BuildContext context, _, __) => MyPopup(),
                            transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
                            return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(scale: animation, child: child),
                            );
                            }
                            ));}},
                    child: (start_run) ? Text('Start') : Text('Stop'),
                    color: (start_run) ? Colors.blue : Colors.red,
                    textColor: Colors.white,
                  ),
                )),
          ],
        ));
  }

  Color method_for_color() {
    print("counting...${_district.runtimeType}");
    return Colors.red.withOpacity(0.5);
  }
}

Dialog leadDialog = Dialog(
  child: Container(
    height: 300.0,
    width: 360.0,
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            'Save your route?',
            style: TextStyle(color: Colors.black, fontSize: 22.0),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'Save your route?',
            style: TextStyle(color: Colors.black, fontSize: 22.0),
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: RaisedButton(
                  onPressed: (){},
                  child: Text('Yes'),
                  color:  Colors.blue,
                ),
              ),
              Expanded(
                flex: 1,
                child: RaisedButton(
                  onPressed: (){
                  },
                  child: Text('No'),
                  color:  Colors.red,
                ),
              ),
            ],
          )
        ),
      ],
    ),
  ),
);

class MyPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Save the route?:'),
      actions: [
        FlatButton(
          onPressed: () {Navigator.pop(context,true);},
          child: Text('Yes'),
        ),
        FlatButton(
          onPressed: () {Navigator.pop(context,false);},
          child: Text('No'),
        ),
      ],
    );
  }
}