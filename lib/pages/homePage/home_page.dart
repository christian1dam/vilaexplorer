import 'package:flutter/material.dart';
import 'package:vilaexplorer/pages/homePage/menu_principal.dart';
import 'package:vilaexplorer/pages/tradicionesPage/tradiciones.dart';
import 'app_bar_custom.dart';
import 'map_view.dart';
import 'package:vilaexplorer/pages/tradicionesPage/DetalleFiestaTradicion.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showMenuPrincipal = false;
  bool showTradicionesPage = false;
  bool showDetalleFiestaTradicion = false;
  String? selectedFiesta; // Para almacenar la fiesta seleccionada

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const MapView(),
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
                  onShowTradicionesPressed: _toggleTradicionesPage),
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
              ),
            ),
          if (showDetalleFiestaTradicion && selectedFiesta != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: DetalleFiestaTradicion(
                fiestaName: selectedFiesta!,
              ),
            ),
        ],
      ),
    );
  }


  void _toggleDetalleFiestaTradicion(String fiestaName) {
    setState(() {
      selectedFiesta = fiestaName;
      showTradicionesPage = false;
      showDetalleFiestaTradicion = true;
    });
  }

  void _toggleTradicionesPage() {
    setState(() {
      _toggleMenuPrincipal();
      showTradicionesPage = !showTradicionesPage;
      showDetalleFiestaTradicion = false;
    });
  }


  void _toggleMenuPrincipal() {
    setState(() {
      showMenuPrincipal = !showMenuPrincipal;
      if (showTradicionesPage) showTradicionesPage = false;
    });
  }
}
