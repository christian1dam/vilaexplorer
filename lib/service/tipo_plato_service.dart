import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/models/gastronomia/tipoPlato.dart';

class TipoPlatoService extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  // Estado local
  List<TipoPlato>? _tiposPlato;
  TipoPlato? _tipoPlatoSeleccionado;
  String? _error;
  bool _isLoading = false;

  // Getters
  List<TipoPlato>? get tiposPlato => _tiposPlato;
  TipoPlato? get tipoPlatoSeleccionado => _tipoPlatoSeleccionado;
  String? get error => _error;
  bool get isLoading => _isLoading;

  // Obtener todos los tipos de plato activos
  Future<void> fetchTiposPlatoActivos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiClient.get('/tipo_plato/activos');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _tiposPlato = data.map((json) => TipoPlato.fromMap(json)).toList();
      } else {
        _error = 'Error: ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (e) {
      _error = 'Error al obtener los tipos de plato activos: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Obtener un tipo de plato por ID
  Future<void> fetchTipoPlatoById(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiClient.get('/tipo_plato/$id');
      if (response.statusCode == 200) {
        _tipoPlatoSeleccionado = TipoPlato.fromMap(json.decode(response.body));
      } else {
        _error = 'Error: ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (e) {
      _error = 'Error al obtener el tipo de plato: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Limpiar la selección de tipo de plato
  void clearSelection() {
    _tipoPlatoSeleccionado = null;
    notifyListeners();
  }
}
