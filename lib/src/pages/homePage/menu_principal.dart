import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/providers/page_provider.dart';
import 'package:vilaexplorer/src/pages/homePage/history_page.dart';

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({
    super.key,
  });

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  late Future<Map<String, Map<String, String>>> _historias;

  @override
  void initState() {
    super.initState();
    _historias = _getHistorias();
  }

  Future<Map<String, Map<String, String>>> _getHistorias() async {
    final String response = await rootBundle.loadString('assets/historias.json');
    final Map<String, dynamic> data = json.decode(response);
    return data.map((key, value) => MapEntry(key, Map<String, String>.from(value)));
  }

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<PageProvider>(context, listen: false);

    return FutureBuilder(
        future: _historias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final historiasMap = snapshot.data!;
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                  color: Color.fromARGB(255, 24, 24, 24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 157, 157, 157),
                      blurRadius: 50,
                      blurStyle: BlurStyle.solid
                    ),
                  ],
                ),
              height: 500.h,
              child: Column(
                children: <Widget>[
                  BarraDeslizamiento(),

                  SearchBar(
                    hintText:
                        AppLocalizations.of(context)!.translate('mp_search'),
                  ),

                  Divider(height: 10.h, color: Colors.transparent),

                  // Botones principales
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ButtonMenuCustom(
                        width: 120.w,
                        textContent: AppLocalizations.of(context)!
                            .translate('traditions'),
                        svgPath: "lib/icon/tradiciones.svg",
                        onTap: () => {
                          pageProvider.changePage('tradiciones'),
                          Navigator.pop(context)
                        },
                      ),
                      ButtonMenuCustom(
                        width: 120.w,
                        textContent: AppLocalizations.of(context)!
                            .translate('favorites'),
                        svgPath: "lib/icon/favoritos.svg",
                        onTap: () => {
                          pageProvider.changePage("favoritos"),
                          Navigator.pop(context)
                        },
                      ),
                      ButtonMenuCustom(
                        width: 120.w,
                        textContent: AppLocalizations.of(context)!
                            .translate('my_account'),
                        svgPath: "lib/icon/user_icon.svg",
                        onTap: () => {
                          pageProvider.changePage("cuenta"),
                          Navigator.pop(context)
                        },
                      ),
                    ],
                  ),

                  Divider(height: 10.h, color: Colors.transparent),

                  // Segunda fila de botones
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ButtonMenuCustom(
                        width: 180.w,
                        textContent: AppLocalizations.of(context)!
                            .translate('gastronomy'),
                        svgPath: "lib/icon/gastronomia.svg",
                        onTap: () => {
                          pageProvider.changePage('gastronomia'),
                          Navigator.pop(context)
                        },
                      ),
                      ButtonMenuCustom(
                        width: 180.w,
                        textContent:
                            AppLocalizations.of(context)!.translate('sights'),
                        svgPath: "lib/icon/monumentos.svg",
                        onTap: () => {
                          pageProvider.changePage("monumentos"),
                          Navigator.pop(context)
                        },
                      ),
                    ],
                  ),

                  Divider(height: 10.h, color: Colors.transparent),

                  // Historias
                  _buildHistoriasSection(context, historiasMap),
                ],
              ),
            );
          }
        });
  }

  // Método para crear los ítems de historia
  Widget _buildHistoriaItem(
      BuildContext context,
      String imageUrl,
      Map<String, String> historia,
      Map<String, Map<String, String>> historiasMap) {
    return GestureDetector(
      onTap: () {
        List<Map<String, String>> historiasList = historiasMap.values.toList();
        int initialIndex = historiasMap.keys.toList().indexOf(imageUrl);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HistoriaScreen(
              historias: historiasList,
              initialIndex: initialIndex,
            ),
          ),
        );

        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        width: 80.w,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.r),
          child: Image.asset(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  // Sección de historias
  Widget _buildHistoriasSection(
      BuildContext context, Map<String, Map<String, String>> historiasMap) {
    return Container(
      width: MediaQuery.of(context).size.width.w,
      height: MediaQuery.of(context).size.height * 0.15.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(13.r)),
        color: Color.fromRGBO(39, 39, 39, 1),
      ),
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
      margin: EdgeInsets.only(left: 7.w, right: 7.w, bottom: 15.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.translate('near'),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.translate('see_more'),
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: historiasMap.keys.map((imageUrl) {
                return _buildHistoriaItem(context, imageUrl, historiasMap[imageUrl]!, historiasMap);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonMenuCustom extends StatelessWidget {
  final double width;
  final double height = 105;
  final double textSize = 1;
  final String textContent;
  final String svgPath;
  final Function() onTap;

  const ButtonMenuCustom({
    super.key,
    required this.textContent,
    required this.svgPath,
    required this.onTap,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      height: height.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.only(left: 12.w, top: 15.h),
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromRGBO(39, 39, 39, 0.92),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0.r),
          ),
          splashFactory: InkRipple.splashFactory,
          shadowColor: Colors.white.withOpacity(0.3),
        ),
        child: SizedBox(
          width: 100.w,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MySvgWidget(path: svgPath, width: 40.w, height: 40.h),
              Text(
                textContent,
                style: TextStyle(fontSize: textSize * 17.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget _crearBoton(double mywidth, String texto, String redirector,
//     String imagePath, double tamanoTexto, BuildContext context) {
//   return SizedBox(
//     width: mywidth,
//     height: 105.h,
//     child: ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         padding: EdgeInsets.only(left: 12.w, top: 15.h),
//         foregroundColor: Colors.white,
//         backgroundColor: const Color.fromRGBO(39, 39, 39, 0.92),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30.0.r),
//         ),
//         splashFactory: InkRipple.splashFactory,
//         shadowColor: Colors.white.withOpacity(0.3),
//       ),
//       child: SizedBox(
//         width: 100.w,
//         height: double.infinity,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             MySvgWidget(path: imagePath, width: 40.w, height: 40.h),
//             Text(
//               texto,
//               style: TextStyle(fontSize: tamanoTexto * 17.sp),
//             ),
//           ],
//         ),
//       ),
//       onPressed: () {
//         if (redirector == "Favoritos" && onShowFavoritosPressed != null) {
//           onShowFavoritosPressed!();
//         } else if (redirector == "Gastronomia" &&
//             onShowGastronomiaPressed != null) {
//           onShowGastronomiaPressed!();
//         } else if (redirector == "Tradiciones" &&
//             onShowTradicionesPressed != null) {
//           onShowTradicionesPressed!();
//         } else if (redirector == "Cuenta" && onShowCuentaPressed != null) {
//           onShowCuentaPressed!();
//         } else if (redirector == "Monumentos" &&
//             onShowMonumentosPressed != null) {
//           onShowMonumentosPressed!();
//         }
//       },
//     ),
//   );
// }

class BarraDeslizamiento extends StatelessWidget {
  const BarraDeslizamiento({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0.h),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 100.w,
          height: 10.h,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ),
    );
  }
}

// Widget de SVG personalizado
class MySvgWidget extends StatelessWidget {
  final String path;
  final double? height;
  final double? width;

  const MySvgWidget({
    super.key,
    required this.path,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(path, height: height?.h, width: width?.w);
  }
}

class SearchBar extends StatelessWidget {
  final String hintText;

  const SearchBar({
    super.key,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(39, 39, 39, 1).withOpacity(0.92),
        borderRadius: BorderRadius.all(Radius.circular(30.r)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 10.h, right: 10.w, bottom: 10.h),
              child: SizedBox(
                height: 40.h,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 1.w),
                      icon: Padding(
                        padding:
                            EdgeInsets.only(top: 7.h, left: 20.w, bottom: 5.h),
                        child: SizedBox(
                          width: 35.w,
                          child: MySvgWidget(
                            path: "lib/icon/lupa.svg",
                            height: 24.h,
                            width: 24.w,
                          ),
                        ),
                      ),
                      hintText: hintText,
                      hintStyle: const TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0.r),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor:
                          const Color.fromRGBO(39, 39, 39, 1).withOpacity(0.92),
                    ),
                    cursorColor: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
