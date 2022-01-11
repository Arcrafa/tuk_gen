import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:tuk_gen/core/models/directions.dart';
import 'package:tuk_gen/fundation/environment_fundation.dart' as env;
class GoogleProvider {
  
  Future<dynamic> getGoogleMapsDirections (double fromLat, double fromLng, double toLat, double toLng) async {
    print('SE ESTA EJECUTANDO');

    Uri uri = Uri.https(
        'maps.googleapis.com',
        'maps/api/directions/json', {
          'key': env.API_KEY_MAPS,
          'origin': '$fromLat,$fromLng',
          'destination': '$toLat,$toLng',
          'traffic_model' : 'best_guess',
          'departure_time': DateTime.now().microsecondsSinceEpoch.toString(),
          'mode': 'driving',
          'transit_routing_preferences': 'less_driving'
        }
    );
    print('URL: $uri');
    final response = await http.get(uri);
    final decodedData = json.decode(response.body);
    final leg = new Direction.fromJsonMap(decodedData['routes'][0]['legs'][0]);
    print(leg);
    return leg;
  }
}