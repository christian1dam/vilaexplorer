import 'package:flutter/material.dart';

class PageProvider extends ChangeNotifier {
  String currentPage = 'map';
  String currentMapStyle = 'mapbox/streets-v11';

  String? selectedFiesta;
  String? selectedLugarInteres;
  String? selectedCategory;
  String? selectedPlatillo;
  String? selectedIngredientes;
  String? selectedReceta;

  void changePage(String page) {
    currentPage = page;
    selectedFiesta = null;
    selectedLugarInteres = null;
    notifyListeners();
  }

  void setFiesta(String fiesta) {
    selectedFiesta = fiesta;
    currentPage = fiesta;
    notifyListeners();
  }

  void setLugarDeInteres(String lugarDeInteres) {
    selectedLugarInteres = lugarDeInteres;
    currentPage = lugarDeInteres;
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
    selectedFiesta = null;
    selectedCategory = null;
    selectedPlatillo = null;
    selectedIngredientes = null;
    selectedReceta = null;
    selectedLugarInteres = null;
    notifyListeners();
  }

  // Cambiar el estilo del mapa
  void toggleMapStyle() {
    currentMapStyle = currentMapStyle == 'mapbox/streets-v11'
        ? 'mapbox/dark-v10'
        : 'mapbox/streets-v11';
    notifyListeners();
  }
}
