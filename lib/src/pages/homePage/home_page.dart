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
          // Mapa en el fondo
          MapView(clearScreen: _clearScreen),
          
          // AppBar en la parte superior
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBarCustom(onMenuPressed: _toggleMenuPrincipal),
          ),
          
          // Menú Principal con barra de iOS y deslizamiento para cerrar
          if (showMenuPrincipal)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MenuPrincipal(
                onShowTradicionesPressed: _toggleTradicionesPage,
                onShowGastronomiaPressed: _toggleGastronomiaPage,
                onCloseMenu: _toggleMenuPrincipal,  // Cerrar el menú al deslizar hacia abajo
              ),
            ),
          
          // Página de Tradiciones
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
                onClose: _toggleTradicionesPage,
              ),
            ),
          
          // Detalle de una Fiesta o Tradición seleccionada
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
                    showTradicionesPage = true;
                  });
                },
              ),
            ),
          
          // Página de Gastronomía
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
              ),
            ),
          
          // Categoría de platos en la Gastronomía
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
              ),
            ),
          
          // Detalle de un Platillo
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

  // Métodos para manejar la navegación entre las páginas y los detalles
  
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
      showDetallePlatillo = false;
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
      showMenuPrincipal = !showTradicionesPage; 
    });
  }

  void _toggleMenuPrincipal() {
  setState(() {
    // Cerrar cualquier página abierta antes de abrir el menú
    if (showGastronomia || showTradicionesPage || showDetalleFiestaTradicion || showGastronomiaCategory || showDetallePlatillo) {
      showGastronomia = false;
      showTradicionesPage = false;
      showDetalleFiestaTradicion = false;
      showGastronomiaCategory = false;
      showDetallePlatillo = false;
    }
    showMenuPrincipal = !showMenuPrincipal;
  });
}

}
