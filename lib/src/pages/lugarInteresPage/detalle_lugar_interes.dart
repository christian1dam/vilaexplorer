import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/models/lugarDeInteres/LugarDeInteres.dart';
import 'package:vilaexplorer/models/tipo_entidad.dart';
import 'package:vilaexplorer/providers/map_state_provider.dart';
import 'package:vilaexplorer/service/favorito_service.dart';
import 'package:vilaexplorer/service/lugar_interes_service.dart';
import 'package:vilaexplorer/service/puntuacion_service.dart';
import 'package:vilaexplorer/service/rutas_service.dart';
import 'package:vilaexplorer/src/pages/homePage/menu_principal.dart';
import 'package:vilaexplorer/user_preferences/user_preferences.dart';

class DetalleLugarInteres extends StatefulWidget {
  final int lugarDeInteresID;
  final BuildContext? context;

  const DetalleLugarInteres(
      {super.key, required this.lugarDeInteresID, this.context});

  @override
  State<DetalleLugarInteres> createState() => _DetalleLugarInteresState();
}

class _DetalleLugarInteresState extends State<DetalleLugarInteres> {
  late Future<LugarDeInteres> _lugarDeInteresFuture;
  late LugarDeInteres _lugarDeInteres;

  @override
  void initState() {
    super.initState();
    _lugarDeInteresFuture = _fetchData();
  }

  Future<LugarDeInteres> _fetchData() async {
    final service = Provider.of<LugarDeInteresService>(context, listen: false);
    await service.fetchLugarDeInteresById(widget.lugarDeInteresID);
    return service.lugarDeInteres;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return FutureBuilder(
      future: _lugarDeInteresFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.black,
              color: Colors.white,
              strokeWidth: 13,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("ERROR: ${snapshot.error}"),
          );
        } else {
          final puntuacionService = Provider.of<PuntuacionService>(context);
          final favoritoService = Provider.of<FavoritoService>(context);
          final lugarDeInteresService =
              Provider.of<LugarDeInteresService>(context);
          final userPreferences = UserPreferences();
          _lugarDeInteres = lugarDeInteresService.lugarDeInteres;
          return Stack(
            children: [
              Positioned(
                bottom: 70.h,
                left: 17.w,
                child: Container(
                  width: 351.w,
                  height: size.height * 0.45.h,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 24, 24, 24),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                      bottomLeft: Radius.circular(20.r),
                      bottomRight: Radius.circular(20.r),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.r),
                              topRight: Radius.circular(20.r),
                            ),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/no-image.jpg',
                              image: _lugarDeInteres.imagen!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 180.h,
                              fadeInDuration: Duration(milliseconds: 400),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  "assets/no-image.jpg",
                                  height: 180.h,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          Container(
                            height: 180.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.r),
                                topRight: Radius.circular(20.r),
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  const Color.fromARGB(153, 0, 0, 0),
                                  Colors.transparent
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.center,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15.w,
                                vertical: 15.h,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //TITULO
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        _lugarDeInteres.nombreLugar ??
                                            'Nombre no disponible',
                                        style: TextStyle(
                                          fontSize: 19.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  GoBackAndCloseButton(
                                    onPressed: () {
                                      if (Navigator.canPop(widget.context!)) {
                                        Navigator.pop(widget.context!);
                                      }
                                    },
                                    myIcono: Icons.close_outlined,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(16.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          _lugarDeInteres.nombreLugar ??
                                              'Descripción no disponible',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.sp),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4.w,
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RatingBar.builder(
                                            itemSize: 23.r,
                                            initialRating: _lugarDeInteres
                                                .puntuacionMediaLugar!,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            unratedColor: Colors.grey,
                                            itemCount: 5,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 1.0.w),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Color.fromARGB(
                                                  230, 255, 255, 64),
                                            ),
                                            onRatingUpdate: (rating) async {
                                              await puntuacionService
                                                  .gestionarPuntuacion(
                                                idUsuario:
                                                    await userPreferences.id,
                                                idEntidad: _lugarDeInteres
                                                    .idLugarInteres!,
                                                tipoEntidad: TipoEntidad
                                                    .LUGAR_INTERES.name,
                                                puntuacion: rating.toInt(),
                                                context: context,
                                              );
                                              debugPrint(
                                                  "Nueva calificación: $rating \nLugar de interes.puntuacionMediaLugar: ${_lugarDeInteres.puntuacionMediaLugar}");
                                              await Provider.of<
                                                          LugarDeInteresService>(
                                                      context,
                                                      listen: false)
                                                  .fetchLugarDeInteresById(
                                                      widget.lugarDeInteresID);
                                              if (context.mounted) {
                                                setState(() {
                                                  _lugarDeInteres =
                                                      lugarDeInteresService
                                                          .lugarDeInteres;
                                                });
                                              }
                                            },
                                          ),
                                          SizedBox(
                                            width: 100.w,
                                              child: Text("Rating: ${_lugarDeInteres.puntuacionMediaLugar}",
                                            style:
                                                TextStyle(color: Colors.white),
                                            textAlign: TextAlign.end,
                                          )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  "Comentarios",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                // TODO #1 Aquí van las opiniones de los usuarios
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16.w,
                right: 16.w,
                bottom: 16.h,
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 1, 140, 241),
                          elevation: 5.h,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        onPressed: () async {
                          final mapProvider = Provider.of<MapStateProvider>(
                              context,
                              listen: false);
                          final routeProvider =
                              Provider.of<RutasService>(context, listen: false);
                          final List<List<double>> coordenadas = _lugarDeInteres
                              .coordenadas!
                              .map((coord) => [coord.longitud!, coord.latitud!])
                              .toList();
                          if (mapProvider.currentLocation != null) {
                            coordenadas.insert(0, [
                              mapProvider.currentLocation!.longitude,
                              mapProvider.currentLocation!.latitude
                            ]);
                          }
                          final bool rutaCreada =
                              await routeProvider.createRoute(
                                  titulo: _lugarDeInteres.nombreLugar!,
                                  coordenadas: coordenadas);
                          if (rutaCreada) {
                            mapProvider.showRoute = true;
                            mapProvider.getRouteTo(
                                LatLng(
                                  _lugarDeInteres.coordenadas!.first.latitud!,
                                  _lugarDeInteres.coordenadas!.first.longitud!,
                                ),
                                mapProvider.currentLocation!);
                          } else {
                            throw Exception("NO SE HA CREADO LA RUTA");
                          }
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Crear Ruta',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 24, 24, 24),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: favoritoService.esFavorito(
                                _lugarDeInteres.idLugarInteres!,
                                TipoEntidad.LUGAR_INTERES)
                            ? MySvgWidget(path: 'lib/icon/favoriteTrue.svg')
                            : MySvgWidget(path: 'lib/icon/guardar_icon.svg'),
                        onPressed: () async {
                          await favoritoService.gestionarFavorito(
                            idUsuario: await userPreferences.id,
                            idEntidad: _lugarDeInteres.idLugarInteres!,
                            tipoEntidad: TipoEntidad.LUGAR_INTERES.name,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class GoBackAndCloseButton extends StatelessWidget {
  const GoBackAndCloseButton({
    super.key,
    required this.onPressed,
    required this.myIcono,
    this.margin,
  });

  final VoidCallback onPressed;
  final IconData myIcono;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 24, 24, 24),
          borderRadius: BorderRadius.all(
            Radius.circular(10.r),
          ),
        ),
        child: IconButton(
          icon: Icon(
            myIcono,
            color: Colors.white,
            weight: 9999,
            size: 30,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
