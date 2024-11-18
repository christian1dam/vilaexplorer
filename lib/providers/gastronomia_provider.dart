import 'package:flutter/material.dart';
import 'package:vilaexplorer/models/gastronomia/plato.dart';
import 'package:vilaexplorer/repositories/gastronomia_repository.dart';

class GastronomiaProvider extends ChangeNotifier {
  final GastronomiaRepository _repository = GastronomiaRepository();

  // Estado local
  List<Plato>? _todosLosPlatos;
  Plato? _platoSeleccionado;
  String? _error;
  bool _isLoading = false;

  // Getters
  List<Plato>? get todosLosPlatos => _todosLosPlatos;
  Plato? get platoSeleccionado => _platoSeleccionado;
  String? get error => _error;
  bool get isLoading => _isLoading;

  // Obtener todos los platos
  Future<void> fetchAllPlatos() async {
    _setLoading(true);
    try {
      _todosLosPlatos = await _repository.getAllPlatos();
      _error = null;
    } catch (e) {
      _error = 'Error al obtener los platos: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Obtener un plato por ID
  Future<void> fetchPlatoById(int id) async {
    _setLoading(true);
    try {
      _platoSeleccionado = await _repository.getPlatoById(id);
      _error = null;
    } catch (e) {
      _error = 'Error al obtener el plato: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Actualizar el estado de carga
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Limpiar errores
  void limpiarError() {
    _error = null;
    notifyListeners();
  }
}