import 'package:bending_spoons/model.dart';

class Location_Polution extends Model {

  static String table = 'location_polution';

  int id;
  int path;
  double latitude;
  double longitude;
  int o3;
  int pm25;
  int co;
  int no2;

  Location_Polution({ this.id, this.path, this.latitude, this.longitude,
  this.o3, this.co, this.no2, this.pm25});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id' : id,
      'path': path,
      'latitude': latitude,
      'longitude': longitude,
      'o3': o3,
      'pm25': pm25,
      'co': co,
      'no2': no2,
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static Location_Polution fromMap(Map<String, dynamic> map) {
    return Location_Polution(
      id: map['id'],
      path: map['path'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      o3 : map['o3'],
      pm25: map['pm25'],
      co: map['co'],
      no2: map['no2'],
    );
  }
}