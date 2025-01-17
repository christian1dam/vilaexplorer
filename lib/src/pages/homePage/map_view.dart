import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/service/lugar_interes_service.dart';

class MapView extends StatefulWidget {
  final VoidCallback clearScreen;

  const MapView({super.key, required this.clearScreen});

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  bool _isMapLoaded = false;
  LatLng? _currentLocation;
  late final MapController _mapController;
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _simulateMapLoading();
    _getCurrentLocation();
    _loadMarkers();
  }

  void _simulateMapLoading() {
    Timer(Duration(milliseconds: 200), () {
      setState(() {
        _isMapLoaded = true;
      });
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si el servicio de localización está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    // Verificar permisos
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // Obtener la ubicación actual
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    // Centrar el mapa en la ubicación del usuario
    if (_currentLocation != null) {
      _mapController.move(
          _currentLocation!, 16); // Zoom 16 para centrarse en el usuario
    }
  }

  Future<void> _loadMarkers() async {
    try {
      final lugaresDeInteresService =
          Provider.of<LugarDeInteresService>(context, listen: false);
      await lugaresDeInteresService.fetchLugaresDeInteres();

      final markers = lugaresDeInteresService.lugaresDeInteres
          .where((lugar) =>
              lugar.coordenadas != null && lugar.coordenadas!.isNotEmpty)
          .expand((lugar) => lugar.coordenadas!)
          .map(
            (coordenada) => Marker(
              point: LatLng(coordenada.latitud!, coordenada.longitud!),
              width: 30.w,
              height: 30.h,
              child: Icon(
                Icons.location_on,
                color: Colors.red,
                size: 30.r,
              ),
            ),
          )
          .toList();

      setState(() {
        _markers = markers;
      });
    } catch (error) {
      print('Error al cargar los marcadores: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: _isMapLoaded ? 1 : 0,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation ?? LatLng(0, 0),
              initialZoom: 14,
              minZoom: 2,
              interactionOptions: InteractionOptions(
                flags: ~InteractiveFlag.doubleTapZoom,
              ),
            ),
            children: [
              GestureDetector(
                onTap: widget.clearScreen,
                child: openStreetMapTileLayer,
              ),
              if (_currentLocation != null)
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: _currentLocation!,
                      color: Colors.blue.withOpacity(0.5),
                      borderStrokeWidth: 2.r,
                      borderColor: Colors.blue,
                      radius: 10.r, // Radio del círculo
                    ),
                  ],
                ),
              MarkerLayer(markers: _markers),
            ],
          ),
        ),
        if (!_isMapLoaded)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  TileLayer get openStreetMapTileLayer => TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'dev.fleaflet.flutter_map.example',
        tileBuilder: _darkModeTileBuilder,
        tileBounds: LatLngBounds(LatLng(-85.0, -180.0), LatLng(85.0, 180.0)),
      );

  Widget _darkModeTileBuilder(
    BuildContext context,
    Widget tileWidget,
    TileImage tile,
  ) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        -0.2126, -0.7152, -0.0722, 0, 280,
        -0.2126, -0.7152, -0.0722, 0, 280,
        -0.2126, -0.7152, -0.0722, 0, 280,
        0, 0, 0, 1, 0,
      ]),
      child: tileWidget,
    );
  }
}
