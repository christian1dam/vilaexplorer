import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatefulWidget {
  final VoidCallback clearScreen;

  const MapView({super.key, required this.clearScreen});

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  bool _isMapLoaded = false;

  @override
  void initState() {
    super.initState();
    _simulateMapLoading();
  }

  void _simulateMapLoading() {
    // Simulamos la carga de todos los tiles con un retraso
    Timer(Duration(seconds: 2), () {
      setState(() {
        _isMapLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Mapa en segundo plano con opacidad controlada
        Opacity(
          opacity: _isMapLoaded ? 1 : 0, // Mostrar el mapa solo cuando _isMapLoaded es true
          child: FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(38.50994005947137, -0.22868221040381242),
              initialZoom: 14,
              interactionOptions: InteractionOptions(
                flags: ~InteractiveFlag.doubleTapZoom,
              ),
            ),
            children: [
              GestureDetector(
                onTap: widget.clearScreen,
                child: openStreetMapTileLayer,
              ),
            ],
          ),
        ),

        // Indicador de carga mientras el mapa no esté listo
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
      );

  Widget _darkModeTileBuilder(
    BuildContext context,
    Widget tileWidget,
    TileImage tile,
  ) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        // 280 -> brillo
        -0.2126, -0.7152, -0.0722, 0, 280, // Red channel
        -0.2126, -0.7152, -0.0722, 0, 280, // Green channel
        -0.2126, -0.7152, -0.0722, 0, 280, // Blue channel
        0, 0, 0, 1, 0,                    // Alpha channel
      ]),
      child: tileWidget,
    );
  }
}