import 'package:cleanair_layout/BusinessLogic/database/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// returns query from database
class Lister {
  List<Text> query = [];
  var number = 0;
  Lister({this.number});
  
  Future<List<Text>> get_map() async {
    List<dynamic> l = await DB.time_query();
    for (var node in l) {
      query.add(Text(node.toString()));
    }
    return query;
  }
}
