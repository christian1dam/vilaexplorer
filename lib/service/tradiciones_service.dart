import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/models/tradiciones/tradiciones.dart';

class TradicionesService extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  // Estado local
  List<Tradiciones>? _todasLasTradiciones;
  Tradiciones? _tradicionSeleccionada;
  String? _error;
  bool _isLoading = false;

  // Getters
  List<Tradiciones>? get todasLasTradiciones => _todasLasTradiciones;
  Tradiciones? get tradicionSeleccionada => _tradicionSeleccionada;
  String? get error => _error;
  bool get isLoading => _isLoading;

  // Métodos públicos para manejar el estado

  // Obtener todas las tradiciones
  Future<void> getAllTradiciones() async {
    await _executeWithLoading(() async {
      final response = await _apiClient.get('/fiesta_tradicion/todos');
      if (response.statusCode == 200) {
        final List<dynamic> tradicionesList = json.decode(response.body);
        _todasLasTradiciones = tradicionesList
            .map((tradicion) => Tradiciones.fromMap(tradicion))
            .toList();
      }
    }, onError: 'Error al obtener tradiciones');
  }

  // Obtener una tradición por ID
  Future<void> getTradicionById(int id) async {
    await _executeWithLoading(() async {
      final response = await _apiClient.get('/fiesta_tradicion/$id');
      if (response.statusCode == 200) {
        _tradicionSeleccionada =
            Tradiciones.fromMap(json.decode(response.body));
      }
    }, onError: 'Error al obtener la tradición');
  }

  // Buscar tradiciones por palabra clave
  Future<void> searchTradiciones(String keyword) async {
    await _executeWithLoading(() async {
      final response =
          await _apiClient.get('/fiesta_tradicion/buscar?keyword=$keyword');
      if (response.statusCode == 200) {
        final List<dynamic> tradicionesList = json.decode(response.body);
        _todasLasTradiciones = tradicionesList
            .map((tradicion) => Tradiciones.fromMap(tradicion))
            .toList();
      }
    }, onError: 'Error al buscar tradiciones');
  }

  // Limpiar errores
  void limpiarError() {
    _error = null;
    notifyListeners();
  }

  // Métodos privados para el manejo del estado

  // Ejecutar una función con manejo del estado de carga
  Future<void> _executeWithLoading(Future<void> Function() action,
      {required String onError}) async {
    _setLoading(true);
    try {
      await action();
      _error = null;
    } catch (e) {
      _error = '$onError: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Actualizar el estado de carga
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
