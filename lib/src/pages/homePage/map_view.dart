import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/providers/page_provider.dart';
import 'package:vilaexplorer/service/lugar_interes_service.dart';
import 'package:http/http.dart' as http;

final GlobalKey<_MapViewState> mapViewKey = GlobalKey<_MapViewState>();

class MapView extends StatefulWidget {
  final VoidCallback clearScreen;

  MapView({Key? key, required this.clearScreen}) : super(key: mapViewKey);

  @override
  _MapViewState createState() => _MapViewState();

  // Exponer el método público para obtener rutas
  void getRouteTo(LatLng destination) {
    createState().getRouteTo(destination);
  }
}

class _MapViewState extends State<MapView> {
  LatLng? _currentLocation;
  late final MapController _mapController;
  List<Marker> _markers = [];
  List<LatLng> _routePoints = [];
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
                  if (_routePoints.isNotEmpty)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: _routePoints,
                          color: Colors.blue,
                          strokeWidth: 4.0,
                        ),
                      ],
                    ),
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
      // case "Playa":
      //   return Colors.amber;
      // case "Museo":
      //   return Colors.white38;
      // case "Parque":
      //   return Colors.green;
      // case "Plaza":
      //   return Colors.white;
      // case "Monumento":
      //   return const Color.fromARGB(132, 212, 245, 91);
      // case "Sitio Arqueológico":
      //   return const Color.fromARGB(255, 97, 12, 255);
      default:
        return Colors.red;
    }
  }

  Future<void> _getRoute(LatLng origin, LatLng destination) async {
    final response = await http.get(
      Uri.parse(
        'https://api.mapbox.com/directions/v5/mapbox/driving/${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}?geometries=geojson&access_token=$accessToken',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final coordinates = data['routes'][0]['geometry']['coordinates'];

      setState(() {
        _routePoints = coordinates
            .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
            .toList();
      });
    } else {
      throw Exception('Error al obtener la ruta: ${response.reasonPhrase}');
    }
  }

  void getRouteTo(LatLng destination) {
    if (_currentLocation != null) {
      _getRoute(_currentLocation!, destination);
    } else {
      print('No se puede obtener la ruta: ubicación actual no disponible.');
    }
  }
}
