import 'package:cleanair_layout/BusinessLogic/locationPollution/model.dart';

class LocationPollution extends Model {

  static String table = 'location_pollution';

  int id;
  int path;
  double latitude;
  double longitude;
  double o3;
  double pm25;
  double co;
  double no2;
  double no;
  double so2;
  double pm10;
  double nh3;

  LocationPollution({ this.id, this.path, this.latitude, this.longitude,
  this.o3, this.co, this.no2, this.pm25, this.no, this.so2, this.pm10, this.nh3});

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
      'no': no,
      'so2': so2,
      'pm10': pm10,
      'nh3': nh3,
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  static LocationPollution fromMap(Map<String, dynamic> map) {
    return LocationPollution(
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
