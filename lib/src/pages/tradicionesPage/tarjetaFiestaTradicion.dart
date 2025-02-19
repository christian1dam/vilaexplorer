import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vilaexplorer/models/tipo_entidad.dart';
import 'package:vilaexplorer/service/favorito_service.dart';
import 'package:vilaexplorer/src/pages/homePage/menu_principal.dart';
import 'package:vilaexplorer/user_preferences/user_preferences.dart';

class FiestaCard extends StatelessWidget {
  final String? nombre;
  final String? fecha;
  final Image? imagen;
  final int? id;
  final Function()? detalleTap;

  const FiestaCard({
    super.key,
    this.nombre,
    this.fecha,
    this.imagen,
    this.detalleTap,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    final favoritoService = Provider.of<FavoritoService>(context, listen: true);

    return Card(
      color: Colors.grey[850],
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: detalleTap,
            child: Stack(
              children: [
                SizedBox(
                  height: 200.h,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15.r)),
                    child: imagen != null
                        ? FadeInImage(
                            placeholder: AssetImage("assets/no-image.jpg"),
                            image: imagen!.image,
                            fit: BoxFit.cover,
                          )
                        : Image.asset("assets/no-image.jpg"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10.h, left: 10.w),
                  width: double.infinity,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.r),
                      topRight: Radius.circular(15.r),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0.7),
                        Color.fromRGBO(0, 0, 0, 0.0),
                      ],
                    ),
                  ),
                  child: nombre != null
                      ? Text(
                          nombre!,
                          style: TextStyle(
                              fontSize: 25.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )
                      : SizedBox(
                          width: 20.w,
                          height: 10.h,
                        ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.w, bottom: 8.h),
            child: Container(
              width: double.infinity,
              height: 50.h,
              padding: EdgeInsets.only(top: 10.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 11.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    fecha != null
                        ? Text(
                            fecha!,
                            style: TextStyle(
                                color: Color.fromRGBO(224, 120, 62, 1),
                                fontSize: 16.sp),
                          )
                        : SizedBox(width: 20.w, height: 10.h),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                        shadowColor: WidgetStatePropertyAll(Colors.transparent),
                        overlayColor: WidgetStatePropertyAll(Colors.transparent),
                      ),
                      child: favoritoService.esFavorito(
                                id!,
                                TipoEntidad.FIESTA_TRADICION)
                            ? MySvgWidget(path: 'lib/icon/favoriteTrue.svg')
                            : MySvgWidget(path: 'lib/icon/guardar_icon.svg'),
                        onPressed: () async {
                          await favoritoService.gestionarFavorito(
                            idUsuario: await UserPreferences().id,
                            idEntidad: id!,
                            tipoEntidad: TipoEntidad.FIESTA_TRADICION.name,
                          );
                        },
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FiestaCardShimmer extends StatelessWidget {
  const FiestaCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 194, 194, 194),
            highlightColor: const Color.fromARGB(211, 255, 255, 255),
            child: Container(
              height: 200.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.w, bottom: 8.h, top: 10.h),
            child: Container(
              width: double.infinity,
              height: 50.h,
              padding: EdgeInsets.only(top: 10.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 11.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Shimmer.fromColors(
                      baseColor: const Color.fromARGB(255, 194, 194, 194),
                      highlightColor: const Color.fromARGB(211, 255, 255, 255),
                      child: Container(
                        width: 150.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.r))),
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: const Color.fromARGB(255, 194, 194, 194),
                      highlightColor: const Color.fromARGB(211, 255, 255, 255),
                      child: Container(
                        width: 100.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.r))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
