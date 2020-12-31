
import 'package:bending_spoons/ListOfRoutes.dart';
import 'package:bending_spoons/gmap.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:bending_spoons/location_pollution.dart';
import 'package:bending_spoons/db.dart';
import 'ShowRoute.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();
  return runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coding with Curry',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/',
      routes: {
        '/':(BuildContext context) => MyHomePage(),
        '/map': (context) => GMap(),
        '/my_routes': (context) => PathList(),
        //'/show_route': (context) => RouteShower(),
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _getLocationPermission();
  }

  void _getLocationPermission() async {
    var location = new Location();
    try {
      location.requestPermission();
    } on Exception catch (_) {
      print('There was a problem allowing location access');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nikita is here"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Using Google Maps in Flutter',
                style: TextStyle(fontSize: 42),
              ),
              SizedBox(height: 20),
              Text(
                'The google_maps_flutter package is still in the Developers Preview status, so make sure you monitor changes closely when using it. There will likely be breaking changes in the near future.',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.map),
        onPressed: () => Navigator.pushNamed(context,'/map'),
      ),
    );
  }
}
