import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/providers/page_provider.dart';
import 'package:vilaexplorer/src/pages/cuentaPage/cuenta_page.dart';
import 'package:vilaexplorer/src/pages/custom_draggable_scrollable_sheet.dart';
import 'package:vilaexplorer/src/pages/favoritosPage/favorito_page.dart';
import 'package:vilaexplorer/src/pages/gastronomia/gastronomia_page.dart';
import 'package:vilaexplorer/src/pages/homePage/history_page.dart';
import 'package:vilaexplorer/src/pages/lugarInteresPage/lugar_interes.dart';
import 'package:vilaexplorer/src/pages/tradicionesPage/tradiciones.dart';

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
    final String response =
        await rootBundle.loadString('assets/historias.json');
    final Map<String, dynamic> data = json.decode(response);
    return data
        .map((key, value) => MapEntry(key, Map<String, String>.from(value)));
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
            return BackgroundBoxDecoration(
              child: SizedBox(
                height: 416.h,
                child: Column(
                  children: <Widget>[
                    const BarraDeslizamiento(),

                    Divider(height: 10.h, color: Colors.transparent),

                    // Botones principales
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ButtonMenuCustom(
                            width: 100.w,
                            textContent: AppLocalizations.of(context)!
                                .translate('traditions'),
                            svgPath: "lib/icon/tradiciones.svg",
                            onTap: () {
                              Navigator.pop(context);
                              showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                isScrollControlled: true,
                                isDismissible: true,
                                enableDrag: true,
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.sizeOf(context).height * 0.81,
                                ),
                                builder: (BuildContext context) {
                                  return CustomDraggableScrollableSheet(
                                    context: context,
                                    builder:
                                      (ScrollController scrollController,
                                          BoxConstraints constraints) {
                                    return TradicionesPage(
                                      onFiestaSelected: (fiestaName) =>
                                          pageProvider.setFiesta(fiestaName),
                                      scrollCOntroller: scrollController,
                                      boxConstraints: constraints,
                                    );
                                  });
                                },
                              );
                            }),
                        ButtonMenuCustom(
                          width: 100.w,
                          textContent: AppLocalizations.of(context)!
                              .translate('favorites'),
                          svgPath: "lib/icon/favoritos.svg",
                          onTap: () async {
                            Navigator.pop(context);

                            return showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              isScrollControlled: true,
                              isDismissible: true,
                              enableDrag: true,
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.sizeOf(context).height * 0.81,
                              ),
                              builder: (BuildContext context) {
                                return CustomDraggableScrollableSheet(
                                  context: context,
                                  builder: (ScrollController scrollController,
                                      BoxConstraints constraints) {
                                    return FavoritosPage(
                                      scrollCOntroller: scrollController,
                                      boxConstraints: constraints,
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                        ButtonMenuCustom(
                            width: 100.w,
                            textContent: AppLocalizations.of(context)!
                                .translate('my_account'),
                            svgPath: "lib/icon/user_icon.svg",
                            onTap: () => Navigator.pushReplacementNamed(
                                context, CuentaPage.route)),
                      ],
                    ),

                    Divider(height: 10.h, color: Colors.transparent),

                    // Segunda fila de botones
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ButtonMenuCustom(
                          width: 155.w,
                          textContent: AppLocalizations.of(context)!
                              .translate('gastronomy'),
                          svgPath: "lib/icon/gastronomia.svg",
                          onTap: () {
                            Navigator.pop(context);
                            return showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              isScrollControlled: true,
                              isDismissible: true,
                              enableDrag: true,
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.sizeOf(context).height * 0.81,
                              ),
                              builder: (BuildContext context) {
                                return CustomDraggableScrollableSheet(
                                  context: context,
                                  builder:
                                    (ScrollController controller,
                                        BoxConstraints constraints) {
                                  return GastronomiaPage(
                                    scrollController: controller,
                                    boxConstraints: constraints,
                                    onCategoriaPlatoSelected: (plato) {},
                                  );
                                });
                              },
                            );
                          },
                        ),
                        ButtonMenuCustom(
                          width: 155.w,
                          textContent:
                              AppLocalizations.of(context)!.translate('sights'),
                          svgPath: "lib/icon/monumentos.svg",
                          onTap: () async {
                            Navigator.pop(context);
                            return showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              isScrollControlled: true,
                              isDismissible: true,
                              enableDrag: true,
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.sizeOf(context).height * 0.81,
                              ),
                              builder: (BuildContext context) {
                                return CustomDraggableScrollableSheet(
                                  context: context,
                                  builder: (ScrollController scrollController,
                                      BoxConstraints constraints) {
                                    return LugarDeInteresPage(
                                      scrollController: scrollController,
                                      constraints: constraints,
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),

                    Divider(height: 10.h, color: Colors.transparent),

                    // Historias
                    _buildHistoriasSection(context, historiasMap),
                  ],
                ),
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
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 0.15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(13.r)),
        color: const Color.fromRGBO(39, 39, 39, 1),
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
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.translate('see_more'),
                style: const TextStyle(
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
                return _buildHistoriaItem(
                    context, imageUrl, historiasMap[imageUrl]!, historiasMap);
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

class BackgroundBoxDecoration extends StatelessWidget {
  final Widget child;
  const BackgroundBoxDecoration({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
        color: const Color.fromARGB(255, 24, 24, 24),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 157, 157, 157),
            blurRadius: 50,
            blurStyle: BlurStyle.solid,
          ),
        ],
      ),
      child: child,
    );
  }
}
