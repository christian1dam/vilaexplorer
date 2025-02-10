import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:vilaexplorer/api/api_client.dart';

class MapStateProvider extends ChangeNotifier {
  late final MapController _mapController = MapController();
  final _apiClient = ApiClient();
  bool _isMapLoaded = false;
  LatLng? _currentLocation;
  List<LatLng> _routePoints = [];
  LatLngBounds? _bounds;
  LatLngBounds? get bounds => _bounds;

  final StreamController<void> resetController = StreamController.broadcast();
  bool currentMapStyle = true;


  LatLng? get currentLocation => _currentLocation;

  MapController get mapController => _mapController;

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
    try {
      final endpoint =
          "/ruta/generarRuta?origenLat=${origin.latitude}&origenLng=${origin.longitude}&destinoLat=${destination.latitude}&destinoLng=${destination.longitude}";

      final response = await _apiClient.get(endpoint);

      final data = json.decode(response.body);

      final features = data['features'] as List;
      final coordinates = features.first['geometry']['coordinates'] as List;

      _routePoints = coordinates
          .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
          .toList();

      final bbox = data['bbox'] as List;

      if (bbox.length == 4) {
        final southWest = LatLng(bbox[1], bbox[0]);
        final northEast = LatLng(bbox[3], bbox[2]);
        _bounds = LatLngBounds(southWest, northEast);
        _mapController.fitCamera(
            CameraFit.bounds(bounds: _bounds!, padding: EdgeInsets.all(40.r)));
      }

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

    _currentLocation = LatLng(position.latitude, position.longitude);
    notifyListeners();
  }

   void toggleMapStyle() {
    debugPrint("SE HA ENTRADO A TOGGLEMAPSTYLE $currentMapStyle");
    currentMapStyle = !currentMapStyle;
    resetController.add(null);
    notifyListeners();
  }
}
