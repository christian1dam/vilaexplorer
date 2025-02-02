import 'package:flutter/material.dart';

class PageProvider extends ChangeNotifier {
  String currentPage = 'map';
  String currentMapStyle = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  String? selectedFiesta;
  int? idLugarDeInteres;
  String? selectedCategory;
  String? selectedPlatillo;
  String? selectedIngredientes;
  String? selectedReceta;

  void changePage(String page) {
    currentPage = page;
    selectedFiesta = null;
    idLugarDeInteres = null;
    notifyListeners();
  }

  void setFiesta(String fiesta) {
    selectedFiesta = fiesta;
    currentPage = fiesta;
    notifyListeners();
  }

  void setLugarDeInteres(int idLugarInteres) {
    clearScreen();
    idLugarDeInteres = idLugarInteres;
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
    idLugarDeInteres = null;
    selectedFiesta = null;
    selectedCategory = null;
    selectedPlatillo = null;
    selectedIngredientes = null;
    selectedReceta = null;
    notifyListeners();
  }

  // Cambiar el estilo del mapa
  void toggleMapStyle() {
    currentMapStyle =
        currentMapStyle == 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
            ? 'https://basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
            : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
    notifyListeners();
  }
}
