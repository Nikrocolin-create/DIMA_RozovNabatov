

import 'package:bending_spoons/model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

abstract class DB {

  static Database _db;
  static int get _version => 1;

  static Future<void> init() async {

    if (_db != null) { return; }

    try {

      String _path = await getDatabasesPath() + 'google_map';
      print(_path);
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    }
    catch(ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async =>
      await db.execute('CREATE TABLE location_pollution (id INTEGER PRIMARY KEY AUTOINCREMENT, path INTEGER, latitude DOUBLE, longitude DOUBLE, '
          'co integer, pm25 integer, no2 integer, o3 integer, measure_time datetime default current_timestamp)');

  static void onDrop() async=> await _db.execute("drop table location_pollution");

  static Future<List<Map<String, dynamic>>> query(String table) async => _db.query(table);

  static Future<int> insert(String table, Model model) async =>
      await _db.insert(table, model.toMap());

  static Future<int> update(String table, Model model) async =>
      await _db.update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  static Future<int> delete(String table, Model model) async =>
      await _db.delete(table, where: 'id = ?', whereArgs: [model.id]);

  static Future<List<Map<String, dynamic>>> time_query() async {
    return _db.rawQuery('SELECT path, max(measure_time) FROM location_pollution GROUP BY path');
  }

  static Future<List<Map<String, dynamic>>> path_query(int path) async {
    return _db.rawQuery('SELECT * FROM location_pollution where path=${path}');
  }

  static Future<List<Map<String, dynamic>>> max_query() async {
    return _db.rawQuery('SELECT max(path) FROM location_pollution GROUP BY path');
  }
}
