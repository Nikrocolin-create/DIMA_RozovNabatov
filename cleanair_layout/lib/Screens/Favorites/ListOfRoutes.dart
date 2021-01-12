import 'dart:core';
import 'package:cleanair_layout/BusinessLogic/database/db.dart';
import 'package:cleanair_layout/Screens/Favorites/ShowRoute.dart';
import 'package:cleanair_layout/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import "package:cleanair_layout/Screens/Favorites/ListOfRoutes.dart";

class PathList extends StatefulWidget {
  @override
  _PathListState createState() {
    return _PathListState();
  }
}

class _PathListState extends State {
  List<dynamic> query;
  List<dynamic> query_for_distance;
  final Distance distance = new Distance();

  Map<dynamic, dynamic> distances;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    distances = Map<dynamic, dynamic>();
    query = [];
    update_list();
  }

  Future<void> update_list() async {
    query = await DB.time_query();
    var prom_dist;
    for (var item in query) {

      prom_dist = 0;
      query_for_distance = await DB.path_query(item['path']);
      int i;
      if (query_for_distance.length > 1)
        for (i = 1; i < query_for_distance.length; i++) {
           prom_dist += distance(
               LatLng(query_for_distance[i-1]["latitude"], query_for_distance[i-1]["longitude"]),
               LatLng(query_for_distance[i]["latitude"], query_for_distance[i]["longitude"]),
           );
        }
      distances[item['path']] = prom_dist;
      print(distances[item['path']]);
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
        child:  FutureBuilder<dynamic>(
            future: update_list(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('Uninitialized');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Text('Awaiting result...');
                case ConnectionState.done:
                  if (snapshot.hasError) throw snapshot.error;
                  return  new ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: query.length,
                    // Provide a builder function. This is where the magic happens.
                    // Convert each item into a widget based on the type of item it is.
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = query[index];
                      print("Item: ${item["path"]}");
                      return InfoBlock(query[index],distances[query[index]["path"]], item["path"]);
                    },
                  );
              }
            }
          )
    );
  }
}


class InfoBlock extends StatelessWidget {

  var minMeasureTime;
  var minMeasureDate;
  var maxMeasureTime;
  var distance;
  var time;
  var path;

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');

    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  // format for duration
  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");
  
  String differenceBetweenTimes(String time1, String time2) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss');
    final DateTime displayTime1 = displayFormater.parse(time1);
    final DateTime displayTime2 = displayFormater.parse(time2);
    final int difference = displayTime2.difference(displayTime1).inSeconds;
    final int hours = (difference/3600).floor();
    final int minutes = ((difference - hours * 3600)/60).floor();
    final int seconds = difference - hours * 3600 - minutes * 60;
    final Duration d = Duration(hours: hours, minutes: minutes, seconds: seconds);
    return format(d);
  }

  InfoBlock(var resp, var dist, var index) {
    minMeasureTime = resp["min(measure_time)"];
    minMeasureDate = convertDateTimeDisplay(resp["min(measure_time)"]);
    time = differenceBetweenTimes(resp["min(measure_time)"], resp["max(measure_time)"]);
    maxMeasureTime = resp["max(measure_time)"];
    distance = dist;
    path = index;
  }

  Widget build(BuildContext context){
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(2.0),
        child: ExpansionTile(
          title: Text("Favorite route"),
          subtitle: Text(
            "$minMeasureDate", 
            style: TextStyle(color: Colors.black.withOpacity(0.6)),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Distance is $distance m\t Time is $time',
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ) 
            ),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                FlatButton(
                  textColor: kPrimaryColor,
                  onPressed: () {
                    print("Index: ${path}");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RouteShower(path.toString()),
                        ));
                  },
                  child: const Text('Dislay on Map'),
                ),
                FlatButton(
                  textColor: kPrimaryColor,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => _buildPopupDialog(context),
                    );
                  },
                  child: const Text('Additional information'),
                ),
              ],
            )
        ]
      )
      )
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Route Information'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Min time: $minMeasureTime\nMax time: $maxMeasureTime\nDistance: $distance"),
        ]
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: kPrimaryColor,
          child: const Text('Close'),
        )
      ],
    );
  }
}
