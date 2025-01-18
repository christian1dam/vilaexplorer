import 'package:flutter/material.dart';

class PageProvider extends ChangeNotifier {
  String currentPage = 'map';
  String currentMapStyle = 'mapbox/streets-v11';

  String? selectedFiesta;
  String? selectedCategory;
  String? selectedPlatillo;
  String? selectedIngredientes;
  String? selectedReceta;

  void changePage(String page) {
    currentPage = page;
    notifyListeners();
  }

  void setFiesta(String fiesta) {
    selectedFiesta = fiesta;
    currentPage = 'map';
    notifyListeners();
  }

  void setCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setPlatillo(String platillo, String ingredientes, String receta) {
    selectedPlatillo = platillo;
    selectedIngredientes = ingredientes;
    selectedReceta = receta;
    notifyListeners();
  }

  void clearScreen() {
    currentPage = 'map';
    print("se ha limpiado la pantalla");
    selectedFiesta = null;
    selectedCategory = null;
    selectedPlatillo = null;
    selectedIngredientes = null;
    selectedReceta = null;
    notifyListeners();
  }

  // Cambiar el estilo del mapa
  void toggleMapStyle() {
    print("SE HA CAMBIADO EL MAPA DE COLOR");
    currentMapStyle = currentMapStyle == 'mapbox/streets-v11'
        ? 'mapbox/dark-v10'
        : 'mapbox/streets-v11';
    notifyListeners();
  }
}
