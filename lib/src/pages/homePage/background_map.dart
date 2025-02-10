import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/providers/map_state_provider.dart';
import 'package:vilaexplorer/providers/page_provider.dart';
import 'package:vilaexplorer/service/lugar_interes_service.dart';
import 'package:vilaexplorer/src/pages/lugarInteresPage/detalle_lugar_interes.dart';

class BackgroundMap extends StatefulWidget {
  const BackgroundMap({super.key});

  @override
  _BackgroundMapState createState() => _BackgroundMapState();
}

class _BackgroundMapState extends State<BackgroundMap> {
  List<Marker> _markers = [];
  final String accessToken = dotenv.env['OPENROUTESERVICE_ACCESS_TOKEN'] ??
      (throw Exception(
          'OPENROUTESERVICE_ACCESS_TOKEN no está definido en el archivo .env'));
  final _tileProvider = FMTCTileProvider(
    stores: const {
      'VilaExplorerMapStore': BrowseStoreStrategy.readUpdateCreate
    },
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint("LLAMANDO A LOADMARKERS");
      _drawMarkers();
      Provider.of<MapStateProvider>(context, listen: false).setMapLoaded = true;
    });
  }

  Future<void> _getCurrentLocation() async {
    final mapStateProvider =
        Provider.of<MapStateProvider>(context, listen: false);
    await mapStateProvider.getCurrentLocation();
    if (mapStateProvider.currentLocation != null) {
      mapStateProvider.mapController
          .move(mapStateProvider.currentLocation!, 16);
    }
  }

  void _drawMarkers() {
    try {
      final lugaresDeInteresService =
          Provider.of<LugarDeInteresService>(context, listen: false);
      final markers = lugaresDeInteresService.lugaresDeInteres
          .where((lugar) =>
              lugar.coordenadas != null && lugar.coordenadas!.isNotEmpty)
          .expand(
            (lugar) => lugar.coordenadas!.map(
              (coordenada) {
                final iconData = _getIconForLugar(lugar.tipoLugar!.nombreTipo!);
                final color = _getColorForLugar(lugar.tipoLugar!.nombreTipo!);
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
                        onPressed: () async {
                          return showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              scrollControlDisabledMaxHeightRatio: 470.h,
                              sheetAnimationStyle: AnimationStyle(
                                duration: Duration(milliseconds: 400),
                              ),
                              context: context,
                              builder: (BuildContext context) {
                                return DetalleLugarInteres(
                                  lugarDeInteresID: lugar.idLugarInteres!,
                                );
                              });
                        }),
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
      debugPrint('Error al cargar los marcadores: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapStateProvider = Provider.of<MapStateProvider>(context);
    final pageProvider = Provider.of<PageProvider>(context, listen: false);
    return Stack(
      children: [
        Opacity(
          opacity: 1,
          child: FlutterMap(
            mapController: mapStateProvider.mapController,
            options: MapOptions(
                initialCenter: mapStateProvider.currentLocation ?? LatLng(0, 0),
                initialZoom: 14,
                minZoom: 4,
                interactionOptions: const InteractionOptions(
                  flags: ~InteractiveFlag.doubleTapZoom,
                ),
                onTap: (tapPosition, latlng) {
                  pageProvider.clearScreen();
                }),
            children: [
              TileLayer(
                reset: mapStateProvider.resetController.stream,
                tileProvider: CancellableNetworkTileProvider(),
                urlTemplate: mapStateProvider.currentMapStyle
                    ? 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
                    : 'https://basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
              ),
              if (mapStateProvider.currentLocation != null)
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: mapStateProvider.currentLocation!,
                      color: Colors.blue.withOpacity(0.5),
                      borderStrokeWidth: 2.r,
                      borderColor: Colors.blue,
                      radius: 10.r,
                    ),
                  ],
                ),
              MarkerLayer(markers: _markers),
              if (mapStateProvider.routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: mapStateProvider.routePoints,
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

  void getRouteTo(LatLng destination, BuildContext context) {
    if (context.mounted) {
      final mapStateProvider =
          Provider.of<MapStateProvider>(context, listen: false);
      if (mapStateProvider.currentLocation != null) {
        mapStateProvider.getRouteTo(
            destination, mapStateProvider.currentLocation!);
      } else {
        debugPrint(
            'No se puede obtener la ruta: ubicación actual no disponible.');
      }
    }
  }
}
