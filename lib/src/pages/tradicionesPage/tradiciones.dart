import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/l10n/app_localizations.dart';
import 'package:vilaexplorer/main.dart';
import 'package:vilaexplorer/service/tradiciones_service.dart';
import 'package:vilaexplorer/src/pages/homePage/menu_principal.dart';
import 'tarjetaFiestaTradicion.dart';

class TradicionesPage extends StatefulWidget {
  final Function(String) onFiestaSelected;
  final VoidCallback onClose;

  const TradicionesPage({
    super.key,
    required this.onFiestaSelected,
    required this.onClose,
  });

  @override
  _TradicionesPageState createState() => _TradicionesPageState();
}

class _TradicionesPageState extends State<TradicionesPage> {
  String? selectedFiesta;
  bool isSearchActive = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Llamar a fetchAllTradiciones cuando se inicia la página
    Future.microtask(() {
      Provider.of<TradicionesService>(context, listen: false)
          .getAllTradiciones();
    });
  }

  void _toggleContainer(String nombreFiesta) {
    setState(() {
      selectedFiesta = nombreFiesta;
      widget.onFiestaSelected(nombreFiesta);
    });
  }

  void _toggleSearch() {
    setState(() {
      isSearchActive = !isSearchActive;
      if (!isSearchActive) {
        searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<TradicionesService>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (provider.error != null) {
          return Center(
            child: Text(
              provider.error!,
              style: const TextStyle(color: Colors.red, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          );
        }

        final tradiciones = provider.todasLasTradiciones;

        if (tradiciones == null || tradiciones.isEmpty) {
          return const Center(
            child: Text(
              'No se encontraron tradiciones.',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  if (isSearchActive) {
                    setState(() {
                      isSearchActive = false;
                      searchController.clear();
                    });
                  }
                },
                child: Container(
                  height: 600.h,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(32, 29, 29, 0.9),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Barra de estilo iOS
                      BarraDeslizamiento(),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment
                              .center, // Alinea todos los elementos verticalmente
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 4.h), // Baja un poco la lupa
                              child: IconButton(
                                icon: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                onPressed: _toggleSearch,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                ), // Margen uniforme
                                height: 35.h,
                                alignment: Alignment
                                    .center, // Centra el contenido verticalmente

                                child: Text(
                                  AppLocalizations.of(context)!
                                      .translate('holidays_traditions'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 21.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 4.h), // Baja un poco el botón de salir
                              child: IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.white),
                                onPressed: widget.onClose,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSearchActive)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: TextField(
                            controller: searchController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!
                                  .translate('search_traditions'),
                              hintStyle: TextStyle(color: Colors.white54),
                              fillColor: Color.fromARGB(255, 47, 42, 42),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.r)),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5.h, horizontal: 10.w),
                            ),
                          ),
                        ),
                      if (isSearchActive) SizedBox(height: 10.h),
                      if (!isSearchActive)
                        Container(
                          padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
                          margin: EdgeInsets.only(bottom: 10.h),
                          width: size.width - 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(36, 36, 36, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.r))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              myBotonText(AppLocalizations.of(context)!
                                  .translate('all')),
                              myBotonText(AppLocalizations.of(context)!
                                  .translate('popular')),
                              myBotonText(AppLocalizations.of(context)!
                                  .translate('nearby')),
                            ],
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          itemCount: tradiciones.length,
                          itemBuilder: (context, index) {
                            final tradicion = tradiciones[index];
                            return FiestaCard(
                              nombre: tradicion.nombre,
                              fecha: tradicion.fecha,
                              imagen: provider
                                  .getImageForTradicion(tradicion.imagen),
                              detalleTap: () =>
                                  _toggleContainer(tradicion.nombre),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  //Necesario para hacer las traducciones
  void _changeLanguage(BuildContext context, Locale locale) {
    setState(() {
      MyApp.setLocale(context, locale);
    });
  }

  SizedBox myBotonText(String texto) {
    return SizedBox(
      width: 110.w,
      child: TextButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            Color.fromRGBO(45, 45, 45, 1),
          ),
        ),
        child: Text(
          texto,
          style: TextStyle(color: Colors.white, fontSize: 13.sp),
        ),
      ),
    );
  }
}
