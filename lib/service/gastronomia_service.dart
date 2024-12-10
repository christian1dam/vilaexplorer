import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vilaexplorer/api/api_client.dart';
import '../models/gastronomia/plato.dart';

class GastronomiaService extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  // Estado local
  List<Plato>? _platos;
  Plato? _platoSeleccionado;
  String? _error;
  bool _isLoading = false;

  // Getters
  List<Plato>? get platos => _platos;
  Plato? get platoSeleccionado => _platoSeleccionado;
  String? get error => _error;
  bool get isLoading => _isLoading;

  // Método para obtener todos los platos con manejo de estado
  Future<void> fetchAllPlatos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiClient.get('/plato/todos');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _platos = data.map((json) => Plato.fromMap(json)).toList();
      } else {
        _error = 'Error: ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (e) {
      _error = 'Error al obtener los platos: $e';
      debugPrint('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para obtener un plato por ID con manejo de estado
  Future<void> fetchPlatoById(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiClient.get('/plato/detalle/$id');
      _platoSeleccionado = Plato.fromMap(json.decode(response.body));
    } catch (e) {
      _error = 'Error al obtener el plato: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para crear un nuevo plato con manejo de estado
  Future<void> createPlato(Plato plato) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiClient.post(
        '/plato/crear',
        body: plato.toMap(),
      );
      final newPlato = Plato.fromMap(json.decode(response.body));
      _platos = [...?_platos, newPlato];
    } catch (e) {
      _error = 'Error al crear el plato: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para manejar la selección de un plato
  void selectPlato(Plato plato) {
    _platoSeleccionado = plato;
    notifyListeners();
  }

  // Método para limpiar la selección de un plato
  void clearSelection() {
    _platoSeleccionado = null;
    notifyListeners();
  }
}
