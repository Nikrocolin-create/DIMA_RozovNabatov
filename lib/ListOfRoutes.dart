import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bending_spoons/Pages.dart';

import 'ShowRoute.dart';
import 'db.dart';

class PathList extends StatefulWidget {
  @override
  _PathListState createState() {
    return _PathListState();
  }
}

class _PathListState extends State {
  Lister list = Lister(number: 1);
  List<Text> query;///не сработало добавление в инит стейт

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    query=[];
    update_list();
  }

  void update_list() async {
    List <Text> query1;
    try {
      print("HERE");
      query1 = await list.get_map();
    } catch (e) {};
    setState(() {
      print(query1);
      query = query1;
      print(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        appBar: new AppBar(title: new Text("My routes"),
          actions: [
            PopupMenuButton(
              onSelected: (String choice) {
                if (choice == "/")
                  Navigator.pushNamed(context, '/');
                else if (choice == "/map")
                  Navigator.pushNamed(context, '/map');
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
          ],),
        body: new ListView.builder(
          itemCount: query.length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            final item = query[index];
            return InfoBlock(query[index].data);
          },)
    );
  }
}

class Lister {
  List<Text> query = [];
  var number = 0;
  Lister({this.number});
  Future<List<Text>> get_map() async {
    List<dynamic> l = await DB.time_query();
    print(await DB.time_query());
    print(l.length);
    for (var node in l) {
      query.add(Text(node.toString()));
      print(query);
    }
    return query;
  }
}

class InfoBlock extends StatelessWidget{
  var res_que;
  String date='';
  String id='';

  InfoBlock(String resp){
    var i=0;
    var flag = 0;
    while (i < resp.length) {
      if (resp[i] == " " && resp[i-1]== ":") {
        flag++;
      }
      if (flag == 1 && resp.codeUnitAt(i) >= '0'.codeUnitAt(0) && resp.codeUnitAt(i) <= '9'.codeUnitAt(0)){
        id += resp[i];
      }
      if (flag == 2 && resp[i]!='}'){
        date += resp[i];
      }
      i++;
      print(id);
      print(date);
    }
  }

  Widget build(BuildContext context){
    return GestureDetector(
        onTap: (){
          print(id);
          Navigator.push(context,
              MaterialPageRoute(
              builder: (context) => RouteShower(id),
          ));
    },
    child: Container(
      height: 48.0,
      child: Row(
        children: [
          Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent)
            ),
            child: Text(id,style: TextStyle(fontSize: 14),),),
      ),
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent)
              ),
              child: Text(date,style: TextStyle(fontSize: 14),),),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent)
              ),
              child: Text("km",style: TextStyle(fontSize: 14),),),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent)
              ),
              child: Text("del",style: TextStyle(fontSize: 14),),),
    ),
        ],
      ),
    ),);
  }
}

