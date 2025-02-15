import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/models/lugarDeInteres/LugarDeInteres.dart';

class MapStateProvider extends ChangeNotifier{
  final _apiClient = ApiClient();
  LatLng? _currentLocation;
  List<LatLng> _routePoints = [];
  LatLngBounds? _bounds;
  LatLngBounds? get bounds => _bounds;
  bool _focusRoute = false;
  bool get focusRoute => _focusRoute;
  bool currentMapStyle = true;
  LatLng? get currentLocation => _currentLocation;

  MapController? _mapController;

  MapController? get mapController => _mapController;

  set setMapController(MapController mapController) {
    _mapController = mapController;
    notifyListeners();
  }

  StreamController<void>? _resetController;

  StreamController<void>? get resetController => _resetController;

  set setStreamController(StreamController<void> resetController) {
    _resetController = resetController;
    notifyListeners();
  }

  bool _focusCurrentLocation = false;

  LugarDeInteres? _lugarDeInteres;
  LugarDeInteres get lugarDeInteres => _lugarDeInteres!;
  set lugarDeInteres(LugarDeInteres poi){
    _lugarDeInteres = poi;
    notifyListeners();
  }
  
  bool _showRoute = false;
  bool get showRoute => _showRoute;
  set showRoute(bool show){
    _showRoute = show;
    notifyListeners();
  }

  bool _focusPOI = false;
  bool get focusPOI => _focusPOI;
  set focusPOI(bool focus){
    _focusPOI = focus;
    notifyListeners();
  }

  bool get focusCurrentLocation => _focusCurrentLocation;

  set setCurrentLocation(LatLng location) {
    _currentLocation = location;
    notifyListeners();
  }

  List<LatLng> get routePoints => _routePoints;

  set setRoutePoints(List<LatLng> points) {
    _routePoints = points;
    _focusRoute = true;
    notifyListeners();
  }

  void setRouteFocusMode() {
    _focusRoute = false;
    notifyListeners();
  }

  set setCurrentLocationFocusMode(bool focus) {
    _focusCurrentLocation = focus;
    notifyListeners();
  }

  Future<void> getRouteTo(LatLng destination, LatLng origin) async {
    try {
      final endpoint =
          "/ruta/generarRuta?origenLat=${origin.latitude}&origenLng=${origin.longitude}&destinoLat=${destination.latitude}&destinoLng=${destination.longitude}";

      final response = await _apiClient.get(endpoint);

      final data = json.decode(response.body);

      final features = data['features'] as List;
      final coordinates = features.first['geometry']['coordinates'] as List;

      setRoutePoints = coordinates
          .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
          .toList();

      _bounds = LatLngBounds.fromPoints(_routePoints);
      notifyListeners();
    } catch (e) {
      throw Exception('Error al obtener la ruta: $e');
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

    setCurrentLocation = LatLng(position.latitude, position.longitude);
    notifyListeners();
  }

  void toggleMapStyle() {
    debugPrint("SE HA ENTRADO A TOGGLEMAPSTYLE $currentMapStyle");
    currentMapStyle = !currentMapStyle;
    notifyListeners();
    resetController!.add(null);
    notifyListeners();
  }
}
