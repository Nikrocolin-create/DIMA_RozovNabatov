import 'dart:async';
import "dart:convert";
import 'package:bending_spoons/location_polution.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:bending_spoons/db.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

String API_KEY = "AIzaSyBOupgrKvCmQn5B3a3Vjn6WgG7FrpNU8f0";

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await DB.init();
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

  Map<dynamic,dynamic> get map_polution { //[{parameter: co, count: 29197}, {parameter: no2, count: 28513}, {parameter: o3, count: 30910}, {parameter: pm25, count: 31928}]
    Map<dynamic,dynamic> map = {};
    for (var l in params) {
      map[l['parameter'].toString()] = l['count'];
    }
    return map;
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
  }
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
  bool action = false;
  Marker _marker;
  bool start_run;
  Timer _timer;
  List<Location_Polution> pol_path = [];
  List<dynamic> list_responses;
  Geolocator _geolocator;
  Position _position;

  void updateLocation() async {
    //функция для обновления локации (ваш кеп)
    try {
      Position newPosition = await Geolocator()
          .getCurrentPosition()
          .timeout(new Duration(seconds: 5));

      List<dynamic> newList;
      if (start_run)  {
        newList = await use_future("https://api.openaq.org/v1/locations/"
            "?coordinates=${newPosition.latitude},${newPosition.longitude}&radius=20000&order_by=distance");
        pol_path.add(Location_Polution(
          path: 1, // написать метод который при выборе начать находит в бд максимальный номер и увеличивает его на 1
          latitude: newPosition.latitude,
          longitude: newPosition.longitude,
          o3 : newList[0].map_polution['o3'],
          pm25: newList[0].map_polution['pm25'],
          co: newList[0].map_polution['co'],
          no2: newList[0].map_polution['no2'],
        ));
      }

      setState(() {
        _position = newPosition;
        if (newList!=null)
        list_responses = newList;
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
        appBar: new AppBar(title: new Text("Map")),
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
                        action = await _asyncConfirmDialog(context);
                        if (action) {
                          for (Location_Polution item in pol_path) {
                              await DB.insert('location_polution', item);
                            }
                          action = false;
                          pol_path.clear(); //очищаем проделанный путь
                          }
                        }
                      },
                    child: (start_run) ? Text('Start') : Text('Stop'),
                    color: (start_run) ? Colors.blue : Colors.red,
                    textColor: Colors.white,
                  ),
                )),
          ],
        ));
  }

  Color method_for_color() {
    updateLocation();// вызов каждые десять секунд
    return Colors.red.withOpacity(0.5);
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