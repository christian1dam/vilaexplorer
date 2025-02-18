import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/models/tradiciones/tradiciones.dart';

class TradicionesService extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  List<Tradicion>? _todasLasTradiciones;
  Tradicion? _tradicionSeleccionada;

  List<Tradicion>? get todasLasTradiciones => _todasLasTradiciones;
  Tradicion? get tradicionSeleccionada => _tradicionSeleccionada;

  Future<void> getAllTradiciones() async {
    try {
      final response = await _apiClient.get('/fiesta_tradicion/activas');
      if (response.statusCode == 200) {
        final List<dynamic> tradicionesList =
            json.decode(utf8.decode(response.bodyBytes));
        _todasLasTradiciones = tradicionesList
            .map((tradicion) => Tradicion.fromMap(tradicion))
            .toList();
      }
      debugPrint("SE HAN OBTENIDO TODAS LAS TRADICIONES");
      notifyListeners();
    } catch (e) {
      debugPrint("EXCEPCION EN GET_ALL_TRADICIONES $e");
      throw Exception(e);
    }
  }

  Future<void> getTradicionById(int id) async {
    try{
      final response = await _apiClient.get('/fiesta_tradicion/$id');
      if (response.statusCode == 200) {
        _tradicionSeleccionada = Tradicion.fromMap(json.decode(utf8.decode(response.bodyBytes)));
        notifyListeners();
      }
    }catch(e) {
      throw Exception(e);
    }
      
  }

  Future<void> searchTradiciones(String keyword) async {
    try {
      final response = await _apiClient.get('/fiesta_tradicion/buscar?keyword=$keyword');
      if (response.statusCode == 200) {
        final List<dynamic> tradicionesList = json.decode(utf8.decode(response.bodyBytes));
        _todasLasTradiciones = tradicionesList.map((tradicion) => Tradicion.fromMap(tradicion)).toList();
        notifyListeners();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
