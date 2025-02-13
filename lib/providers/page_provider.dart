import 'package:flutter/material.dart';

class PageProvider extends ChangeNotifier {

  String? selectedFiesta;
  int? idLugarDeInteres;

  void changePage(String page) {
    selectedFiesta = null;
    idLugarDeInteres = null;
    notifyListeners();
  }

  void setFiesta(String fiesta) {
    selectedFiesta = fiesta;
    notifyListeners();
  }

  void setLugarDeInteres(int idLugarInteres) {
    idLugarDeInteres = idLugarInteres;
    notifyListeners();
  }

  void clearScreen() {
    selectedFiesta = null;
    notifyListeners();
  }
}
