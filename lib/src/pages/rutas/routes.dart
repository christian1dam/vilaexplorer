import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/models/ruta.dart';
import 'package:vilaexplorer/providers/map_state_provider.dart';
import 'package:vilaexplorer/service/rutas_service.dart';
import 'package:vilaexplorer/src/widgets/loading.dart';

class RoutesPage extends StatefulWidget {
  static const String route = 'routesPage';

  final Function? onClose;

  const RoutesPage({super.key, this.onClose});

  @override
  _RoutesPageState createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> with TickerProviderStateMixin {
  Future<void>? _rutasFuture;

  @override
  void initState() {
    _rutasFuture =
        Provider.of<RutasService>(context, listen: false).fetchMisRutas();
    super.initState();
  }

  late List<Ruta> rutasPredefinidas = [];

  late List<Ruta> rutasCreadasUsuario = [];

  void _showLoadingLogo() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const Loading(imagePath: 'assets/images/VilaExplorer.png'),
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final rutasService = Provider.of<RutasService>(context, listen: false);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(32, 29, 29, 1),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            AppLocalizations.of(context)!.translate('routes'),
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                  text: AppLocalizations.of(context)!
                      .translate('predefined_route')),
              Tab(
                  text:
                      AppLocalizations.of(context)!.translate('saved_routes')),
            ],
          ),
        ),
        body: FutureBuilder(
          future: _rutasFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              rutasPredefinidas = rutasService.rutasPredefinidas;
              rutasCreadasUsuario = rutasService.rutasDelUsuario;
              return TabBarView(
                children: [
                  RutasPredefinidasTab(
                    rutasPredefinidas: rutasPredefinidas,
                    rutasGuardadas: rutasCreadasUsuario,
                    showLoadingLogo: _showLoadingLogo,
                  ),
                  RutasGuardadasTab(
                    rutasGuardadas: rutasCreadasUsuario,
                    showLoadingLogo: _showLoadingLogo,
                  ),
                ],
              );
            }
            return Loading(imagePath: 'assets/images/VilaExplorer.png');
          },
        ),
      ),
    );
  }
}

class RutasPredefinidasTab extends StatelessWidget {
  final List<Ruta> rutasPredefinidas;
  final List<Ruta> rutasGuardadas;
  final VoidCallback showLoadingLogo;

  const RutasPredefinidasTab({
    super.key,
    required this.rutasPredefinidas,
    required this.rutasGuardadas,
    required this.showLoadingLogo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(32, 29, 29, 1),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: ListView.builder(
        itemCount: rutasPredefinidas.length,
        itemBuilder: (context, index) {
          final ruta = rutasPredefinidas[index];
          return Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            elevation: 5,
            shadowColor: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading:
                        const Icon(Icons.route, color: Colors.black, size: 30),
                    title: Text(
                      ruta.nombreRuta!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        const Icon(Icons.directions_walk,
                            color: Colors.black54, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          _formatDistance(ruta.distancia!),
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(width: 15),
                        const Icon(Icons.timer,
                            color: Colors.black54, size: 16),
                        const SizedBox(width: 5),
                        Text(
                          _formatDuration(ruta.duracion!),
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          final mapProvider = Provider.of<MapStateProvider>(
                            context,
                            listen: false,
                          );
                          Navigator.pop(context);
                          final List<LatLng> latLngList =
                              ruta.coordenadas!.map((coordenada) {
                            return LatLng(
                                coordenada.latitud!, coordenada.longitud!);
                          }).toList();
                          Future.delayed(const Duration(milliseconds: 500), () {
                            mapProvider.setRoutePoints = latLngList;
                          });
                        },
                        icon: const Icon(Icons.map, color: Colors.white),
                        label: const Text(
                          "Ver en el mapa",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.black54, size: 20),
                          SizedBox(width: 5),
                          Text(
                            ruta.autor?.nombre ?? "Desconocido",
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class RutasGuardadasTab extends StatelessWidget {
  final List<Ruta> rutasGuardadas;
  final VoidCallback showLoadingLogo;

  const RutasGuardadasTab({
    super.key,
    required this.rutasGuardadas,
    required this.showLoadingLogo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(32, 29, 29, 1),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: rutasGuardadas.isEmpty
          ? Center(
              child: Text(
                AppLocalizations.of(context)!.translate('no_saved_route'),
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: rutasGuardadas.length,
              itemBuilder: (context, index) {
                final ruta = rutasGuardadas.elementAt(index);

                return Dismissible(
                  key: ValueKey("${ruta.idRuta}-dismiss"),
                  direction: DismissDirection.endToStart,
                    background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    ),
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    elevation: 5,
                    shadowColor: Colors.black54,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.route,
                                color: Colors.black, size: 30),
                            title: Text(
                              ruta.nombreRuta!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                const Icon(Icons.directions_walk,
                                    color: Colors.black54, size: 16),
                                const SizedBox(width: 5),
                                Text(
                                  _formatDistance(ruta.distancia!),
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(width: 15),
                                const Icon(Icons.timer,
                                    color: Colors.black54, size: 16),
                                const SizedBox(width: 5),
                                Text(
                                  _formatDuration(ruta.duracion!),
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  final mapProvider =
                                      Provider.of<MapStateProvider>(
                                    context,
                                    listen: false,
                                  );
                                  Navigator.pop(context);
                                  final List<LatLng> latLngList =
                                      ruta.coordenadas!.map((coordenada) {
                                    return LatLng(coordenada.latitud!,
                                        coordenada.longitud!);
                                  }).toList();
                                  Future.delayed(
                                      const Duration(milliseconds: 500), () {
                                    mapProvider.setRoutePoints = latLngList;
                                  });
                                },
                                icon: const Icon(Icons.map, color: Colors.white),
                                label: const Text(
                                  "Ver en el mapa",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.person,
                                      color: Colors.black54, size: 20),
                                  SizedBox(width: 5),
                                  Text(
                                    ruta.autor?.nombre ?? "Desconocido",
                                    style: const TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

String _formatDuration(double durationInSeconds) {
  int totalMinutes = (durationInSeconds / 60).round();
  int hours = totalMinutes ~/ 60;
  int minutes = totalMinutes % 60;

  if (hours > 0 && minutes > 0) {
    return "$hours h $minutes min";
  } else if (hours > 0) {
    return "$hours h";
  } else {
    return "$minutes min";
  }
}

String _formatDistance(double distanceInMeters) {
  if (distanceInMeters >= 1000) {
    return "${(distanceInMeters / 1000).toStringAsFixed(2)} km";
  } else {
    return "${distanceInMeters.toStringAsFixed(0)} m";
  }
}
