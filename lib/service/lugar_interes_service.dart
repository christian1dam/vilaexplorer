import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/models/lugarDeInteres/LugarDeInteres.dart';

class LugarDeInteresService with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  List<LugarDeInteres> _lugaresDeInteres = [];
  List<LugarDeInteres> get lugaresDeInteres => _lugaresDeInteres;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Obtiene todos los lugares de interés desde la API
  Future<void> fetchLugaresDeInteres() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiClient.get('/lugar_interes/todos');
      final List<dynamic> data = jsonDecode(response.body);

      _lugaresDeInteres = data
          .map((json) => LugarDeInteres.fromMap(json))
          .toList();
    } catch (error) {
      _errorMessage = 'Error al cargar los lugares de interés: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Obtiene todos los lugares de interés activos desde la API
  Future<void> fetchLugaresDeInteresActivos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiClient.get('/lugar_interes/activos');
      final List<dynamic> data = jsonDecode(response.body);

      _lugaresDeInteres = data
          .map((json) => LugarDeInteres.fromMap(json))
          .toList();
    } catch (error) {
      _errorMessage = 'Error al cargar los lugares de interés activos: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Obtiene un lugar de interés por su ID
  Future<LugarDeInteres?> fetchLugarDeInteresById(int id) async {
    try {
      final response = await _apiClient.get('/lugar_interes/detalle/$id');
      final Map<String, dynamic> data = jsonDecode(response.body);

      return LugarDeInteres.fromMap(data);
    } catch (error) {
      _errorMessage = 'Error al obtener el lugar de interés: $error';
      notifyListeners();
      return null;
    }
  }

  /// Limpia la lista de lugares de interés
  void clearLugaresDeInteres() {
    _lugaresDeInteres = [];
    notifyListeners();
  }
}
