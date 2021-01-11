import 'dart:convert';

import 'dart:async';
import 'package:cleanair_layout/BusinessLogic/Maps/gmaps.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../../constants.dart';

/*   it's the function library. We need to implement only functions somehow! */

class APIWork {

  ResponseParameters lBefore;

  Future<int> returnColor() async {

    Position newPosition = await Geolocator()
        .getCurrentPosition()
        .timeout(new Duration(seconds: 10));

    var response = await http.get("http://api.openweathermap.org/data/2.5/air_pollution?lat=${newPosition.latitude}"+
                                  "&lon=${newPosition.longitude}&appid=$cleanAirAPIKey");

    if (response.statusCode == 200) {
      var valueBefore = json.decode(response.body)['list']; //json parser
      var value2Before = json.decode(response.body)['coord'];
      lBefore = ResponseParameters(
          value2Before['lat'],
          value2Before['lon'],
          valueBefore[0]['components']
      );

      int c = valueBefore[0]['main']['aqi'] - 1;
      return c;
    } else {
      return 0;
    } 
  }

  Future<Map<String, dynamic>> getMeasures() async {
    return lBefore.params;
  }
}

