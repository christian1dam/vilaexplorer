import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/models/lugarDeInteres/LugarDeInteres.dart';
import 'package:vilaexplorer/models/tipo_entidad.dart';
import 'package:vilaexplorer/providers/page_provider.dart';
import 'package:vilaexplorer/service/favorito_service.dart';
import 'package:vilaexplorer/service/puntuacion_service.dart';
import 'package:vilaexplorer/service/usuario_service.dart';
import 'package:vilaexplorer/src/pages/homePage/map_view.dart';
import 'package:vilaexplorer/src/pages/homePage/menu_principal.dart';

class DetalleLugarInteres extends StatelessWidget {
  final LugarDeInteres lugarDeInteres;

  const DetalleLugarInteres({super.key, required this.lugarDeInteres});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pageProvider = Provider.of<PageProvider>(context, listen: false);
    final puntuacionService =
        Provider.of<PuntuacionService>(context, listen: false);
    final favoritoService =
        Provider.of<FavoritoService>(context, listen: true);
    final usuarioAutenticado = UsuarioService().usuarioAutenticado;

    return Stack(
      children: [
        Positioned(
          bottom: 70.h,
          left: 17.w,
          child: Container(
            width: 351.w,
            height: size.height * 0.45.h,
            decoration: BoxDecoration(
              color: Color.fromARGB(250, 66, 66, 66),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
                bottomLeft: Radius.circular(20.r),
                bottomRight: Radius.circular(20.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen con título y botón de cerrar superpuestos
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/no-image.jpg',
                        image: lugarDeInteres.imagen!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 180.h,
                      ),
                    ),

                    // Gradiente y superposición para título y botón
                    Container(
                      height: 180.h, // Misma altura que la imagen
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.6.r),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //TITULO
                            Expanded(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  lugarDeInteres.nombreLugar ??
                                      'Nombre no disponible',
                                  style: TextStyle(
                                    fontSize: 19.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            GoBackAndCloseButton(
                              myIcono: Icons.arrow_back,
                              onPressed: () =>
                                  pageProvider.changePage('lugares de interés'),
                              margin: EdgeInsets.only(right: 5.w),
                            ),
                            GoBackAndCloseButton(
                              onPressed: pageProvider.clearScreen,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    lugarDeInteres.nombreLugar ??
                                        'Descripción no disponible',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18.sp),
                                  ),
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RatingBar.builder(
                                      itemSize: 23.r,
                                      initialRating:
                                          lugarDeInteres.puntuacionMediaLugar ??
                                              0,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: false,
                                      itemCount: 5,
                                      itemPadding: EdgeInsets.symmetric(
                                          horizontal: 1.0.w),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Color.fromARGB(230, 255, 205, 0),
                                      ),
                                      onRatingUpdate: (rating) async {
                                        puntuacionService.gestionarPuntuacion(
                                          idUsuario: usuarioAutenticado!.id!,
                                          idEntidad:
                                              lugarDeInteres.idLugarInteres!,
                                          tipoEntidad: TipoEntidad.LUGAR_INTERES
                                              .toString()
                                              .substring(12),
                                          puntuacion: rating.toInt(),
                                        );
                                        print("Nueva calificación: $rating");
                                      },
                                    ),
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
        // Botones flotantes debajo del recuadro
        Positioned(
          left: 16.w,
          right: 16.w,
          bottom: 16.h,
          child: Row(
            children: [
              // Botón de "Obtener ruta"
              Expanded(
                flex: 4, // 80% del espacio
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 1, 140, 241),
                    elevation: 5.h,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  onPressed: () {
                    final mapViewState = mapViewKey.currentState;
                    if (mapViewState != null) {
                      mapViewState.getRouteTo(LatLng(
                          lugarDeInteres.coordenadas!.first.latitud!,
                          lugarDeInteres.coordenadas!.first.longitud!));
                    } else {
                      print('No se pudo encontrar el estado de MapView.');
                    }

                    pageProvider.clearScreen();
                  },
                  child: Text(
                    'Obtener ruta',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 8.w),

              Expanded(
                flex: 1, // 20% del espacio
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child:
                      favoritoService.esFavorito(lugarDeInteres.idLugarInteres!)
                          ? MySvgWidget(path: 'lib/icon/favoriteTrue.svg')
                          : MySvgWidget(path: 'lib/icon/guardar_icon.svg'),
                  onPressed: () {
                    favoritoService.gestionarFavorito(
                      idUsuario: usuarioAutenticado!.id!,
                      idEntidad: lugarDeInteres.idLugarInteres!,
                      tipoEntidad:
                          TipoEntidad.FIESTA_TRADICION.toString().substring(12),
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
          color: const Color.fromARGB(245, 70, 68, 68),
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
