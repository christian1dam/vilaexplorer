import 'package:flutter/material.dart';
import 'package:pruebas_vila_explorer/src/pages/tradicionesPage/detalleFiestaTradicion.dart';
import 'package:pruebas_vila_explorer/src/pages/tradicionesPage/tradiciones.dart';
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

  String? selectedFiesta;

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
                onClose: _toggleTradicionesPage, // Callback para cerrar TradicionesPage
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
                    showTradicionesPage = true; // Volver a mostrar TradicionesPage
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  void _clearScreen() {
    setState(() {
      showMenuPrincipal = false;
      showTradicionesPage = false;
      showDetalleFiestaTradicion = false;
    });
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
      showTradicionesPage = !showTradicionesPage;
      showMenuPrincipal = !showTradicionesPage; // Alterna el menú principal
    });
  }

  void _toggleMenuPrincipal() {
    setState(() {
      showMenuPrincipal = !showMenuPrincipal;
      if (showTradicionesPage) showTradicionesPage = false;
    });
  }
}
