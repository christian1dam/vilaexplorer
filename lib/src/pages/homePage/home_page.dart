import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vilaexplorer/providers/page_provider.dart';
import 'package:vilaexplorer/service/lugar_interes_service.dart';
import 'package:vilaexplorer/src/pages/cuentaPage/cuenta_page.dart';
import 'package:vilaexplorer/src/pages/favoritosPage/favorito_page.dart';
import 'package:vilaexplorer/src/pages/gastronomia/gastronomia_page.dart';
import 'package:vilaexplorer/src/pages/homePage/app_bar_custom.dart';
import 'package:vilaexplorer/src/pages/homePage/menu_principal.dart';
import 'package:vilaexplorer/src/pages/homePage/map_view.dart';
import 'package:vilaexplorer/src/pages/monumentosPage/detalle_monumento.dart';
import 'package:vilaexplorer/src/pages/monumentosPage/lugar_interes.dart';
import 'package:vilaexplorer/src/pages/tradicionesPage/detalle_fiesta_tradicion.dart';
import 'package:vilaexplorer/src/pages/tradicionesPage/tradiciones.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<PageProvider>(context);
    final lugarInteresService = Provider.of<LugarDeInteresService>(context);

    return Scaffold(
      body: Stack(
        children: [
          MapView(
            clearScreen: pageProvider.clearScreen,
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBarCustom(
              onMenuPressed: () {
                pageProvider.changePage(
                    pageProvider.currentPage == 'menu' ? 'map' : 'menu');
              },
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Offstage(
              offstage: pageProvider.currentPage != 'menu',
              child: MenuPrincipal(
                onShowTradicionesPressed: () =>
                    pageProvider.changePage('tradiciones'),
                onShowGastronomiaPressed: () =>
                    pageProvider.changePage('gastronomia'),
                onShowFavoritosPressed: () =>
                    pageProvider.changePage('favoritos'),
                onShowCuentaPressed: () => pageProvider.changePage('cuenta'),
                onShowMonumentosPressed: () =>
                    pageProvider.changePage('lugares de interés'),
                onCloseMenu: () => pageProvider.changePage('map'),
              ),
            ),
          ),

          // Página de tradiciones superpuesta al mapa
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

          // Página de favoritos superpuesta al mapa
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

          if (pageProvider.selectedLugarInteres != null)
            Positioned.fill(
              child: Offstage(
                offstage: pageProvider.selectedLugarInteres == null,
                child: DetalleMonumentoPage(
                  lugarDeInteres: lugarInteresService.lugaresDeInteres.firstWhere((lugar) => lugar.nombreLugar == pageProvider.selectedLugarInteres),
                ),
              ),
            ),

          // Página de cuenta superpuesta al mapa
          Positioned.fill(
            child: Offstage(
              offstage: pageProvider.currentPage != 'cuenta',
              child: CuentaPage(
                onClose: () => pageProvider.changePage('map'),
              ),
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

          // FloatingActionButton para cambiar el estilo del mapa
          if (pageProvider.currentPage == 'map')
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
