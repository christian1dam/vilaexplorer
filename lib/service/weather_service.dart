import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:vilaexplorer/providers/map_state_provider.dart';

class WeatherService {
  MapStateProvider mapStateProvider = MapStateProvider();
  final String apikey = dotenv.env['OPENWEATHER_TOKEN']!;

  // ASUMO QUE SE HAN DADO LOS PERMISOS

  Future<Weather> fetchWeather() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apikey'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }
}

class Weather {
  final String nombreLugar;
  final double temperatura;
  final String estadoClimatico;

  Weather({required this.nombreLugar, required this.temperatura, required this.estadoClimatico,});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      nombreLugar: json['name'],
      temperatura: json['main']['temp'],
      estadoClimatico: json['weather'][0]['main'],
    );
  }
}
