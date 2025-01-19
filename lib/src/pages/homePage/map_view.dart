import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/providers/page_provider.dart';
import 'package:vilaexplorer/service/lugar_interes_service.dart';

class MapView extends StatefulWidget {
  final VoidCallback clearScreen;

  const MapView({Key? key, required this.clearScreen}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  LatLng? _currentLocation;
  late final MapController _mapController;
  List<Marker> _markers = [];
  final String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'] ??
      (throw Exception(
          'MAPBOX_ACCESS_TOKEN no está definido en el archivo .env'));

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print("LLAMANDO A LOADMARKERS");
      await _loadMarkers();
    });
  }

  Future<void> _getCurrentLocation() async {
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

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 16);
    }
  }

  Future<void> _loadMarkers() async {
    try {
      final lugaresDeInteresService =
          Provider.of<LugarDeInteresService>(context, listen: false);
      await lugaresDeInteresService.fetchLugaresDeInteresActivos();

      final markers = lugaresDeInteresService.lugaresDeInteres
          .where((lugar) =>
              lugar.coordenadas != null && lugar.coordenadas!.isNotEmpty)
          .expand(
            (lugar) => lugar.coordenadas!.map(
              (coordenada) {
                final iconData = _getIconForLugar(lugar.tipoLugar!.nombreTipo!);
                final color = _getColorForLugar(lugar.tipoLugar!.nombreTipo!);
                final pageProvider =
                    Provider.of<PageProvider>(context, listen: false);
                return Marker(
                  point: LatLng(coordenada.latitud!, coordenada.longitud!),
                  width: 40.w,
                  height: 40.h,
                  rotate: true,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: Icon(
                        iconData,
                        color: color,
                        size: 40.r,
                      ),
                      onPressed: () =>
                          pageProvider.setLugarDeInteres(lugar.nombreLugar!),
                    ),
                  ),
                );
              },
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
    return Consumer<PageProvider>(
      builder: (context, pageProvider, child) {
        return Stack(
          children: [
            Opacity(
              opacity: 1,
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                    initialCenter: _currentLocation ?? LatLng(0, 0),
                    initialZoom: 14,
                    minZoom: 4,
                    interactionOptions: const InteractionOptions(
                      flags: ~InteractiveFlag.doubleTapZoom,
                    ),
                    onTap: (tapPosition, latlng) {
                      widget.clearScreen();
                    }),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://api.mapbox.com/styles/v1/${pageProvider.currentMapStyle}/tiles/{z}/{x}/{y}?access_token=$accessToken',
                    additionalOptions: {
                      'access_token': accessToken,
                    },
                  ),
                  if (_currentLocation != null)
                    CircleLayer(
                      circles: [
                        CircleMarker(
                          point: _currentLocation!,
                          color: Colors.blue.withOpacity(0.5),
                          borderStrokeWidth: 2.r,
                          borderColor: Colors.blue,
                          radius: 10.r,
                        ),
                      ],
                    ),
                  MarkerLayer(markers: _markers),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  _getIconForLugar(String tipoLugar) {
    switch (tipoLugar) {
      // case "Playa":
      //   return FontAwesomeIcons.umbrellaBeach; // Icono para monumentos
      // case "Museo":
      //   return Icons.museum; // Icono para parques
      // case "Parque":
      //   return FontAwesomeIcons.treeCity;
      // case "Plaza":
      //   return FontAwesomeIcons.chair; // Icono para plazas
      // case "Monumento":
      //   return Icons.museum; // Icono para parques
      // case "Sitio Arqueológico":
      //   return AntDesign.history_outline; // Icono para museos
      default:
        return Icons.location_pin; // Icono por defecto
    }
  }

  _getColorForLugar(String tipoLugar) {
    switch (tipoLugar) {
      case "Playa":
        return Colors.amber; // Icono para monumentos
      case "Museo":
        return Colors.white38; // Icono para parques
      case "Parque":
        return Colors.green;
      case "Plaza":
        return Colors.white; // Icono para plazas
      case "Monumento":
        return const Color.fromARGB(132, 212, 245, 91); // Icono para parques
      case "Sitio Arqueológico":
        return const Color.fromARGB(255, 97, 12, 255); // Icono para museos
      default:
        return Colors.red; // Icono por defecto
    }
  }
}
