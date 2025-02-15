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
import 'package:vilaexplorer/service/lugar_interes_service.dart';
import 'package:vilaexplorer/service/weather_service.dart';
import 'package:vilaexplorer/src/pages/homePage/app_bar_custom.dart';
import 'package:vilaexplorer/src/pages/homePage/menu_principal.dart';
import 'package:vilaexplorer/src/pages/homePage/routes.dart';
import 'package:vilaexplorer/src/pages/lugarInteresPage/detalle_lugar_interes.dart';

class MyHomePage extends StatefulWidget {
  static const String route = 'homePage';
  
  final dynamic lugarDeInteres;
  const MyHomePage({super.key, this.lugarDeInteres});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  static const _startedId = 'AnimatedMapController#MoveStarted';
  static const _inProgressId = 'AnimatedMapController#MoveInProgress';
  static const _finishedId = 'AnimatedMapController#MoveFinished';

  Future<List<dynamic>>? _fetchDataFuture;
  MapStateProvider? _mapStateProvider;
  final StreamController<void> _resetController = StreamController.broadcast();
  final MapController _mapController = MapController();

  List<Marker> _markers = [];
  final String _mapboxAT = dotenv.env['MAPBOX_ACCESS_TOKEN']!;
  final _tileProvider = FMTCTileProvider(
    stores: const {
      'VilaExplorerMapStore': BrowseStoreStrategy.readUpdateCreate
    },
  );

  @override
  void initState() {
    super.initState();
    _fetchDataFuture = _fetchData();
  }

  Future<List<dynamic>> _fetchData() async {
    final lugaresDeInteres = Provider.of<LugarDeInteresService>(context, listen: false).fetchLugaresDeInteresActivos();
    final currentLocation = _getCurrentLocation();
    Future<Weather> weather = WeatherService().fetchWeather();
    return Future.wait([lugaresDeInteres, currentLocation, weather]);
    }

  Future<void> _getCurrentLocation() async {
    final mapStateProvider = Provider.of<MapStateProvider>(context, listen: false);
    return mapStateProvider.getCurrentLocation();
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
                            },
                          );
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
    return FutureBuilder(
        future: _fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Weather weather = snapshot.data![2];
            return Scaffold(
              body: Consumer<MapStateProvider>(
                builder: (context, mapStateProvider, child) {
                  if (mapStateProvider.focusRoute) {
                    _fitCameraToRoute(mapStateProvider.routePoints);
                    Future.microtask(
                      () => mapStateProvider.setRouteFocusMode(),
                    );
                  }

                  if (context.mounted &&
                      mapStateProvider.focusCurrentLocation) {
                    _animatedMapMove(mapStateProvider.currentLocation!,
                        _mapController.camera.zoom);
                    Future.microtask(
                      () =>
                          mapStateProvider.setCurrentLocationFocusMode = false,
                    );
                  }

                  if (context.mounted && mapStateProvider.focusPOI) {
                    final lugarDeInteres = mapStateProvider.lugarDeInteres;
                    final destino = LatLng(
                        lugarDeInteres.coordenadas![0].latitud!,
                        lugarDeInteres.coordenadas![0].longitud!);
                    _animatedMapMove(destino, 20);
                    Future.microtask(
                      () {
                        mapStateProvider.focusPOI = false;
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          scrollControlDisabledMaxHeightRatio: 470.h,
                          sheetAnimationStyle: AnimationStyle(
                            duration: Duration(milliseconds: 400),
                          ),
                          context: context,
                          builder: (BuildContext context) {
                            return DetalleLugarInteres(
                              lugarDeInteresID: lugarDeInteres.idLugarInteres!,
                            );
                          },
                        );
                      },
                    );
                  }

                  return GestureDetector(
                    onDoubleTapDown: (TapDownDetails tapDownDetails) {
                      final RenderBox renderBox =
                          context.findRenderObject() as RenderBox;
                      final Offset localOffset = renderBox
                          .globalToLocal(tapDownDetails.globalPosition);
                      final LatLng zonaTap = _mapController.camera
                          .screenOffsetToLatLng(localOffset);

                      double newZoom =
                          (_mapController.camera.zoom + 1.5).clamp(4, 18.0);
                      _animatedMapMove(zonaTap, newZoom);
                    },
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        onMapReady: () {
                          mapStateProvider.setMapController = _mapController;
                          mapStateProvider.setStreamController =
                              _resetController;
                          _drawMarkers();
                        },
                        initialCenter:
                            mapStateProvider.currentLocation ?? LatLng(0, 0),
                        initialZoom: 14,
                        minZoom: 4,
                        interactionOptions: const InteractionOptions(
                          flags: ~InteractiveFlag.doubleTapZoom,
                        ),
                        onTap: (tapPosition, point) {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        },
                      ),
                      children: [
                        TileLayer(
                          reset: _resetController.stream,
                          tileProvider: mapStateProvider.currentMapStyle
                              ? CancellableNetworkTileProvider()
                              : _tileProvider,
                          userAgentPackageName: 'com.example.vilaexplorer',
                          urlTemplate: mapStateProvider.currentMapStyle
                              ? 'https://api.mapbox.com/styles/v1/mapbox/outdoors-v11/tiles/{z}/{x}/{y}?access_token=$_mapboxAT'
                              : 'https://api.mapbox.com/styles/v1/mapbox/dark-v10/tiles/{z}/{x}/{y}?access_token=$_mapboxAT',
                          tileUpdateTransformer:
                              _animatedMoveTileUpdateTransformer,
                          panBuffer: 0,
                        ),
                        if (mapStateProvider.currentLocation != null)
                          CircleLayer(
                            circles: [
                              CircleMarker(
                                point: mapStateProvider.currentLocation!,
                                color: const Color.fromARGB(134, 33, 149, 243),
                                borderStrokeWidth: 2.r,
                                borderColor: Colors.blue,
                                radius: 10.r,
                              ),
                            ],
                          ),
                        MarkerLayer(markers: _markers),
                        Visibility(
                          visible: mapStateProvider.showRoute,
                          child: GestureDetector(
                            onLongPress: () => mapStateProvider.showRoute = false,
                            child: PolylineLayer(
                              minimumHitbox: 20,
                              simplificationTolerance: 0.01,
                              polylines: [
                                Polyline(
                                  gradientColors: [
                                    const Color.fromARGB(255, 0, 140, 255),
                                    const Color.fromARGB(255, 0, 78, 147)
                                  ],
                                  points: mapStateProvider.routePoints,
                                  strokeWidth: 4.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: AppBarCustom(weatherData: weather),
                        ),
                        Positioned(
                          bottom: 145.h,
                          right: 20.w,
                          child: FloatingActionButton(
                            heroTag: "FAB-${UniqueKey()}",
                            backgroundColor:
                                const Color.fromARGB(230, 50, 50, 50),
                            onPressed: () {
                              Navigator.of(context).pushNamed(RoutesPage.route);
                            },
                            tooltip: "Guardar ruta",
                            child: const Icon(
                              Icons.route_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 75.h,
                          right: 20.w,
                          child: FloatingActionButton(
                            heroTag: "FAB-${UniqueKey()}",
                            backgroundColor:
                                const Color.fromARGB(230, 50, 50, 50),
                            onPressed: () => mapStateProvider.toggleMapStyle(),
                            tooltip: "Cambiar estilo del mapa",
                            child: const Icon(
                              Icons.map,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 75.h,
                          right: 90.w,
                          child: FloatingActionButton(
                              heroTag: "FAB-${UniqueKey()}",
                              backgroundColor:
                                  const Color.fromARGB(230, 50, 50, 50),
                              onPressed: () => mapStateProvider
                                  .setCurrentLocationFocusMode = true,
                              tooltip: "Volver a mi ubicación",
                              child:
                                  MySvgWidget(path: 'lib/icon/location.svg')),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return Scaffold(
            body: Stack(
              children: [CircularProgressIndicator()],
            ),
          );
        });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mapStateProvider = Provider.of<MapStateProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _mapStateProvider?.mapController?.dispose();
    _mapStateProvider?.resetController?.close();
    super.dispose();
  }

  void _fitCameraToRoute(List<LatLng> routePoints) {
    final bounds = LatLngBounds.fromPoints(routePoints);
    final cameraFit =
        CameraFit.bounds(bounds: bounds).fit(_mapController.camera);
    _animatedMapMove(cameraFit.center, cameraFit.zoom - 0.5);
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
        return Icons.location_on_outlined; // Icono por defecto
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

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    debugPrint("SE HA ENTRADO A ANIMATED MAP MOVE");
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final camera = _mapController.camera;
    final latTween = Tween<double>(
        begin: camera.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: camera.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    // Note this method of encoding the target destination is a workaround.
    // When proper animated movement is supported (see #1263) we should be able
    // to detect an appropriate animated movement event which contains the
    // target zoom/center.
    final startIdWithTarget =
        '$_startedId#${destLocation.latitude},${destLocation.longitude},$destZoom';
    bool hasTriggeredMove = false;

    controller.addListener(() {
      final String id;
      if (animation.value == 1.0) {
        id = _finishedId;
      } else if (!hasTriggeredMove) {
        id = startIdWithTarget;
      } else {
        id = _inProgressId;
      }

      hasTriggeredMove |= _mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
        id: id,
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
}

/// Causes tiles to be prefetched at the target location and disables pruning
/// whilst animating movement. When proper animated movement is added (see
/// #1263) we should just detect the appropriate AnimatedMove events and
/// use their target zoom/center.
final _animatedMoveTileUpdateTransformer =
    TileUpdateTransformer.fromHandlers(handleData: (updateEvent, sink) {
  final mapEvent = updateEvent.mapEvent;

  final id = mapEvent is MapEventMove ? mapEvent.id : null;
  if (id?.startsWith(_MyHomePageState._startedId) ?? false) {
    final parts = id!.split('#')[2].split(',');
    final lat = double.parse(parts[0]);
    final lon = double.parse(parts[1]);
    final zoom = double.parse(parts[2]);

    // When animated movement starts load tiles at the target location and do
    // not prune. Disabling pruning means existing tiles will remain visible
    // whilst animating.
    sink.add(
      updateEvent.loadOnly(
        loadCenterOverride: LatLng(lat, lon),
        loadZoomOverride: zoom,
      ),
    );
  } else if (id == _MyHomePageState._inProgressId) {
    // Do not prune or load whilst animating so that any existing tiles remain
    // visible. A smarter implementation may start pruning once we are close to
    // the target zoom/location.
  } else if (id == _MyHomePageState._finishedId) {
    // We already prefetched the tiles when animation started so just prune.
    sink.add(updateEvent.pruneOnly());
  } else {
    sink.add(updateEvent);
  }
});
