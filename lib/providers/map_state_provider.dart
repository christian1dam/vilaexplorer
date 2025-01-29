import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class MapStateProvider extends ChangeNotifier {
  bool _isMapLoaded = false;
  LatLng? _currentLocation;
  List<LatLng> _routePoints = [];
  final String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'] ??
      (throw Exception(
          'MAPBOX_ACCESS_TOKEN no está definido en el archivo .env'));

  LatLng? get currentLocation => _currentLocation;

  set setCurrentLocation(LatLng location) {
    _currentLocation = location;
    notifyListeners();
  }

  List<LatLng> get routePoints => _routePoints;

  void setRoutePoints(List<LatLng> points) {
    _routePoints = points;
    notifyListeners();
  }

  bool get isMapLoaded => _isMapLoaded;

  set setMapLoaded(bool isItLoaded) {
    _isMapLoaded = isItLoaded;
    notifyListeners();
  }

  Future<void> getRouteTo(LatLng destination, LatLng origin) async {
    final response = await http.get(
      Uri.parse(
        'https://api.mapbox.com/directions/v5/mapbox/driving/${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}?geometries=geojson&access_token=$accessToken',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final coordinates = data['routes'][0]['geometry']['coordinates'];
      _routePoints = coordinates
          .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
          .toList();
      notifyListeners();
    } else {
      throw Exception('Error al obtener la ruta: ${response.reasonPhrase}');
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    _currentLocation = LatLng(position.latitude, position.longitude);
    notifyListeners();
  }
}
