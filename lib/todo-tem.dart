import 'package:bending_spoons/model.dart';

class TodoItem extends Model {

  static String table = 'todo_items';

  int id;
  int path;
  double latitude;
  double longitude;

  TodoItem({ this.id, this.path, this.latitude, this.longitude});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'path': path,
      'latitude': latitude,
      'longitude': longitude,
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static TodoItem fromMap(Map<String, dynamic> map) {
    return TodoItem(
        id: map['id'],
        path: map['path'],
        latitude: map['latitude'],
        longitude: map['longitude'],
    );
  }
}