import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vilaexplorer/providers/map_state_provider.dart';
import 'package:vilaexplorer/providers/page_provider.dart';
import 'package:vilaexplorer/service/lugar_interes_service.dart';
import 'package:vilaexplorer/src/pages/cuentaPage/cuenta_page.dart';
import 'package:vilaexplorer/src/pages/favoritosPage/favorito_page.dart';
import 'package:vilaexplorer/src/pages/gastronomia/gastronomia_page.dart';
import 'package:vilaexplorer/src/pages/homePage/app_bar_custom.dart';
import 'package:vilaexplorer/src/pages/homePage/map_page.dart';
import 'package:vilaexplorer/src/pages/homePage/routes.dart';
import 'package:vilaexplorer/src/pages/lugarInteresPage/detalle_lugar_interes.dart';
import 'package:vilaexplorer/src/pages/lugarInteresPage/lugar_interes.dart';
import 'package:vilaexplorer/src/pages/tradicionesPage/detalle_fiesta_tradicion.dart';
import 'package:vilaexplorer/src/pages/tradicionesPage/tradiciones.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _fetchUserData();
    });
  }

  void _fetchUserData() async {
    final lugaresDeInteresService =
        Provider.of<LugarDeInteresService>(context, listen: false);
    await lugaresDeInteresService.fetchLugaresDeInteresActivos();
  }

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<PageProvider>(context, listen: true);
    final mapProvider = Provider.of<MapStateProvider>(context, listen: true);
    final isMapLoaded = mapProvider.isMapLoaded;

    return Scaffold(
      body: Stack(
        children: [
          BackgroundMap(),

          if (isMapLoaded)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBarCustom(),
            ),

          Positioned.fill(
            child: Offstage(
              offstage: pageProvider.currentPage != 'tradiciones',
              child: TradicionesPage(
                onFiestaSelected: (fiestaName) =>
                    pageProvider.setFiesta(fiestaName),
              ),
            ),
          ),

          if (pageProvider.selectedFiesta != null)
            Positioned.fill(
              child: Offstage(
                offstage: pageProvider.selectedFiesta == null,
                child: DetalleFiestaTradicion(
                  fiestaName: pageProvider.selectedFiesta ?? '',
                ),
              ),
            ),

          Positioned.fill(
            child: Offstage(
              offstage: pageProvider.currentPage != 'favoritos',
              child: FavoritosPage(
                onClose: () => pageProvider.changePage('map'),
              ),
            ),
          ),

          Positioned.fill(
            child: Offstage(
              offstage: pageProvider.currentPage != 'lugares de interés',
              child: LugarDeInteresPage(),
            ),
          ),

          // Página de rutas guardadas superpuesta al mapa
          Positioned.fill(
            child: Offstage(
              offstage: pageProvider.currentPage != 'routes',
              child: RoutesPage(
                onClose: () =>
                    pageProvider.changePage('map'), // Volver al mapa al cerrar
              ),
            ),
          ),

          if (pageProvider.idLugarDeInteres != null)
            Positioned.fill(
              child: Offstage(
                offstage: pageProvider.idLugarDeInteres == null,
                child: DetalleLugarInteres(
                  lugarDeInteresID: pageProvider.idLugarDeInteres!,
                ),
              ),
            ),

          Positioned.fill(
            child: Offstage(
              offstage: pageProvider.currentPage != 'cuenta',
              child: CuentaPage(),
            ),
          ),

          if (pageProvider.currentPage == 'gastronomia')
            Positioned.fill(
              child: Offstage(
                offstage: pageProvider.currentPage != 'gastronomia',
                child: GastronomiaPage(
                  onCategoriaPlatoSelected: (plato) {},
                ),
              ),
            ),


          if (pageProvider.currentPage == 'map'&& pageProvider.idLugarDeInteres == null)
            Positioned(
              bottom: 145.h, // Colocado encima del botón de cambiar estilo
              right: 20.w,
              child: FloatingActionButton(
                backgroundColor: const Color.fromARGB(230, 50, 50, 50),
                onPressed: () {
                  pageProvider.changePage(
                      'routes'); // Ir a la página de rutas guardadas
                },
                tooltip: "Guardar ruta",
                child: const Icon(
                  Icons.route_rounded,
                  color: Colors.white,
                ),
              ),
            ),


          if (pageProvider.currentPage == 'map' &&
              pageProvider.idLugarDeInteres == null)
            Positioned(
              bottom: 75.h,
              right: 20.w,
              child: FloatingActionButton(
                backgroundColor: const Color.fromARGB(230, 50, 50, 50),
                onPressed: () {
                  pageProvider.toggleMapStyle();
                },
                tooltip: "Cambiar estilo del mapa",
                child: const Icon(
                  Icons.map,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
