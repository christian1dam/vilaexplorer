import 'package:flutter/material.dart';

class PageProvider extends ChangeNotifier {
  String currentPage = 'map';

  String? selectedFiesta;
  int? idLugarDeInteres;

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

  void clearScreen() {
    currentPage = 'map';
    selectedFiesta = null;
    notifyListeners();
  }
}
