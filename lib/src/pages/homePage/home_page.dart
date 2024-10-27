import 'package:flutter/material.dart';
import 'package:vilaexplorer/src/pages/gastronomia/categoria_platos.dart';
import 'package:vilaexplorer/src/pages/gastronomia/detalle_platillo.dart';
import 'package:vilaexplorer/src/pages/gastronomia/gastronomia_page.dart';
import 'package:vilaexplorer/src/pages/tradicionesPage/detalleFiestaTradicion.dart';
import 'package:vilaexplorer/src/pages/tradicionesPage/tradiciones.dart';
import 'app_bar_custom.dart';
import 'map_view.dart';
import 'menu_principal.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showMenuPrincipal = false;
  bool showTradicionesPage = false;
  bool showDetalleFiestaTradicion = false;
  bool showGastronomia = false;
  bool showGastronomiaCategory = false;

  String? selectedFiesta;
  String? selectedCategory;
  bool showDetallePlatillo = false;
  String? selectedPlatillo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapView(clearScreen: _clearScreen),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBarCustom(onMenuPressed: _toggleMenuPrincipal),
          ),
          if (showMenuPrincipal)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MenuPrincipal(
                onShowTradicionesPressed: _toggleTradicionesPage,
                onShowGastronomiaPressed: _toggleGastronomiaPage,
              ),
            ),
          if (showTradicionesPage)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: TradicionesPage(
                onFiestaSelected: (fiestaName) {
                  _toggleDetalleFiestaTradicion(fiestaName);
                },
                onClose:
                    _toggleTradicionesPage,
              ),
            ),
          if (showDetalleFiestaTradicion)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: DetalleFiestaTradicion(
                fiestaName: selectedFiesta!,
                onClose: () {
                  setState(() {
                    showDetalleFiestaTradicion = false;
                    showTradicionesPage =
                        true;
                  });
                },
              ),
            ),
          if (showGastronomia)
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: GastronomiaPage(
                  onCategoriaPlatoSelected: (category) {
                    _toggleGastronomiaPageDetail(category);
                  },
                )),
          if (showGastronomiaCategory)
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: CategoriaPlatos(
                  category: selectedCategory!,
                  onClose: () {
                    setState(() {
                      showGastronomiaCategory = false;
                      showGastronomia = true;
                    });
                  },
                  onPlatilloSelected: (platillo) {
                    _toggleDetallePlatillo(platillo);
                  },
                )),
          if (showDetallePlatillo)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: DetallePlatillo(
                platillo: selectedPlatillo!,
                closeWidget: () {
                  setState(() {
                    showDetallePlatillo = false;
                    showGastronomiaCategory = true;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  void _toggleGastronomiaPage() {
    setState(() {
      showMenuPrincipal = false;
      showGastronomia = true;
    });
  }

  void _toggleGastronomiaPageDetail(String category) {
    setState(() {
      selectedCategory = category;
      showGastronomia = false;
      showGastronomiaCategory = true;
    });
  }

  void _toggleDetallePlatillo(String platillo) {
    setState(() {
      selectedPlatillo = platillo;
      showGastronomiaCategory = false;
      showDetallePlatillo = true;
    });
  }

  void _clearScreen() {
    setState(() {
      showMenuPrincipal = false;
      showTradicionesPage = false;
      showDetalleFiestaTradicion = false;
      showGastronomia = false;
      showGastronomiaCategory = false;
    });
  }

  void _toggleDetalleFiestaTradicion(String fiestaName) {
    setState(() {
      selectedFiesta = fiestaName;
      showGastronomia = false;
      showGastronomiaCategory = true;
    });
  }

  void _toggleTradicionesPage() {
    setState(() {
      showTradicionesPage = !showTradicionesPage;
      showMenuPrincipal = !showTradicionesPage; 
    });
  }

  void _toggleMenuPrincipal() {
    setState(() {
      showMenuPrincipal = !showMenuPrincipal;
      if (showTradicionesPage) showTradicionesPage = false;
      if (showGastronomia) showGastronomia = false;
    });
  }
}
