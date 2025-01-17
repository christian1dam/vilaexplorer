import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vilaexplorer/providers/page_provider.dart';
import 'package:vilaexplorer/src/pages/cuentaPage/cuenta_page.dart';
import 'package:vilaexplorer/src/pages/favoritosPage/favorito_page.dart';
import 'package:vilaexplorer/src/pages/homePage/app_bar_custom.dart';
import 'package:vilaexplorer/src/pages/homePage/menu_principal.dart';
import 'package:vilaexplorer/src/pages/homePage/map_view.dart';
import 'package:vilaexplorer/src/pages/monumentosPage/lugar_interes.dart';
import 'package:vilaexplorer/src/pages/tradicionesPage/tradiciones.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<PageProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Mapa en el fondo
          MapView(
            clearScreen: pageProvider.clearScreen,
          ),

          // AppBar en la parte superior
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

          if (pageProvider.currentPage == 'menu')
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MenuPrincipal(
                onShowTradicionesPressed: () =>
                    pageProvider.changePage('tradiciones'),
                onShowGastronomiaPressed: () =>
                    pageProvider.changePage('gastronomia'),
                onShowFavoritosPressed: () =>
                    pageProvider.changePage('favoritos'),
                onShowCuentaPressed: () => pageProvider.changePage('cuenta'),
                onShowMonumentosPressed: () =>
                    pageProvider.changePage('monumentos'),
                onCloseMenu: () => pageProvider.changePage('map'),
              ),
            ),

          if (pageProvider.currentPage == 'tradiciones')
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: TradicionesPage(
                onFiestaSelected: (fiestaName) =>
                    pageProvider.setFiesta(fiestaName),
                onClose: () => pageProvider.changePage('map'),
              ),
            ),

          if (pageProvider.currentPage == 'favoritos')
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: FavoritosPage(
                onClose: () => pageProvider.changePage('map'),
              ),
            ),

          if (pageProvider.currentPage == 'Lugar de interes')
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: LugarDeInteresPage(
                onClose: () => pageProvider.changePage('map'),
                onLugarInteresSelected: (String) {},
              ),
            ),

          if (pageProvider.currentPage == 'cuenta')
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: CuentaPage(
                onClose: () => pageProvider.changePage('map'),
              ),
            ),

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
