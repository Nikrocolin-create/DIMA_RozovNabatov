// import 'dart:async';
// import "dart:convert";
import 'package:dima_nabatov_rozov/constants.dart';
import 'package:flutter/material.dart';
import 'package:dima_nabatov_rozov/Screens/login_screen.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong/latlong.dart';
// import 'package:location/location.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;


void main(){
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CleanRun',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white
      ),
      home: WelcomeLoginScreen(),
    );
  }

}

/*
void use_future(String url){ //оборачиваем асинхр. функцию для вызова
  get_res(url).then((value) { // после выполнения get_res результат передается в valuе и выполняется функция в {}
    print("hello");
    print(value);
  });
}


//"https://www.myurl.com/api/v1/test/123/?param1=one&param2=two";
Future<String> get_res(url) async { //асинхронная функция для работы с api
  var response = await http.get(url);
  print(response.statusCode);
  if (response.statusCode == 200){
    var to_parse = json.decode(response.body)['results'];//будущий парсер json
    print(to_parse);
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

class _HomePageState extends State<HomePage> { // здесь начинается магия
  Marker _marker;
  Timer _timer;
  int _markerIndex = 0;
  Geolocator _geolocator;
  Position _position;

  void updateLocation() async {//функция для обновления локации (ваш кеп)
    print("!");
    try {
      Position newPosition = await Geolocator().getCurrentPosition().timeout(new Duration(seconds: 5));
      setState(() {
        _position = newPosition;
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();

    _geolocator = Geolocator();
    updateLocation();
    _timer = Timer.periodic(Duration(seconds: 10), (_) { //обновление состояния по таймеру
      setState(() {
        use_future("https://api.openaq.org/v1/locations/?coordinates=${_position.latitude},${_position.longitude}&radius=20000");
        _marker = Marker(//
            width: 80.0,
            height: 80.0,
            point: LatLng(_position.latitude,_position.longitude),
            builder: (ctx) => Container(
              child: Icon(Icons.directions_car),
            ));
      });
    });
  }


  @override
  void dispose() { //сам не знаю, что это но походу сброс таймера
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
          center: LatLng(_position.latitude,_position.longitude),
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
                  point: LatLng(_position.latitude,_position.longitude),
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
}*/