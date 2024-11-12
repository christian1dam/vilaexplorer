import 'package:flutter/material.dart';
import 'package:vilaexplorer/src/pages/favoritosPage/favorito_page.dart';
import 'package:vilaexplorer/src/pages/gastronomia/categoria_platos.dart';
import 'package:vilaexplorer/src/pages/gastronomia/detalle_platillo.dart';
import 'package:vilaexplorer/src/pages/gastronomia/gastronomia_page.dart';
import 'package:vilaexplorer/src/pages/tradicionesPage/detalleFiestaTradicion.dart';
import 'package:vilaexplorer/src/pages/tradicionesPage/tradiciones.dart';
import 'app_bar_custom.dart';
import 'map_view.dart';
import 'menu_principal.dart';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isMapLoaded = false;

  bool showMenuPrincipal = false;
  bool showTradicionesPage = false;
  bool showDetalleFiestaTradicion = false;
  bool showGastronomia = false;
  bool showGastronomiaCategory = false;
  bool showFavoritosPage = false;


  String? selectedFiesta;
  String? selectedCategory;
  bool showDetallePlatillo = false;
  String? selectedPlatillo;

  @override
  void initState() {
    super.initState();
    _loadMap();  // Cargar el mapa al iniciar
  }

  Future<void> _loadMap() async {
    await Future.delayed(Duration(seconds: 2)); // Simula la carga del mapa
    setState(() {
      isMapLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isMapLoaded
          ? Stack(
              children: [
                // Mapa en el fondo
                MapView(
                  clearScreen: _clearScreen,
                ),

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
                      onShowFavoritosPressed: _toggleFavoritosPage,
                      onCloseMenu: _toggleMenuPrincipal,
                    ),
                  ),


                // Página de Favoritos
                if (showFavoritosPage)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: FavoritosPage(
                      onClose: _toggleFavoritosPage,  // Pasa la referencia de la función
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
            )
          : Center(child: CircularProgressIndicator()),
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

  void _toggleFavoritosPage() {
    setState(() {
      // Si el menú principal está abierto, lo cerramos.
      showMenuPrincipal = false;
      // Alternar la visibilidad de la página de Favoritos.
      showFavoritosPage = !showFavoritosPage;
      // Si se está mostrando Tradiciones, cerramos Tradiciones para evitar bloqueo.
      if (showTradicionesPage) {
        showTradicionesPage = false;
      }
    });
  }



  void _toggleTradicionesPage() {
  setState(() {
    // Si el menú principal está abierto, lo cerramos.
    showMenuPrincipal = false;
    // Alternar la visibilidad de la página de Tradiciones.
    showTradicionesPage = !showTradicionesPage;
    // Si se está mostrando Favoritos, cerramos Favoritos.
    if (showFavoritosPage) {
      showFavoritosPage = false;
    }
  });
}


  void _toggleMenuPrincipal() {
  setState(() {
    // Si alguna página está abierta, cerramos todo antes de abrir el menú
    if (showGastronomia || showTradicionesPage || showDetalleFiestaTradicion || showGastronomiaCategory || showDetallePlatillo || showFavoritosPage) {
      showGastronomia = false;
      showTradicionesPage = false;
      showDetalleFiestaTradicion = false;
      showGastronomiaCategory = false;
      showDetallePlatillo = false;
      showFavoritosPage = false;
    }
    // Alternar la visibilidad del menú
    showMenuPrincipal = !showMenuPrincipal;
  });
}

}
