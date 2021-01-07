import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bending_spoons/Pages.dart';
import "package:latlong/latlong.dart";
import 'ShowRoute.dart';
import 'db.dart';

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

  ///не сработало добавление в инит стейт
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
    print(query);
    print("query");
    var prom_dist;
    for (var item in query) {
      print("item: ${item}");
      prom_dist = 0;
      query_for_distance = await DB.path_query(item['path']);
      print('Query: ${query_for_distance}');
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
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        appBar: new AppBar(
          title: new Text("My routes"),
          actions: [
            PopupMenuButton(
              onSelected: (String choice) {
                if (choice == "/")
                  Navigator.pushNamed(context, '/');
                else if (choice == "/map") Navigator.pushNamed(context, '/map');
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
        body:  FutureBuilder<dynamic>(
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
                    itemCount: query.length,
                    // Provide a builder function. This is where the magic happens.
                    // Convert each item into a widget based on the type of item it is.
                    itemBuilder: (context, index) {
                      final item = query[index];
                      print(distances);
                      return InfoBlock(query[index],distances[query[index]["path"]]);
                    },
                  );
              }
            }));
  }
}

class InfoBlock extends StatelessWidget {
  var tuple;
  var distance;

  InfoBlock(var resp, var dist) {
    tuple = resp;
    distance= dist;
    print(tuple);
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(tuple['path']);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RouteShower(tuple['path'].toString()),
            ));
      },
      child: Container(
        height: 48.0,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                child: Text(
                  tuple["min(measure_time)"].toString(),
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                child: Text(
                  tuple["max(measure_time)"].toString(),
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                child: Text(
                  "${distance} m",
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
