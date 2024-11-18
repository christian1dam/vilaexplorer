import 'package:flutter/material.dart';
import 'package:vilaexplorer/models/tradiciones/tradiciones.dart';
import 'package:vilaexplorer/repositories/tradiciones_repository.dart';

class TradicionesProvider extends ChangeNotifier {
  final FiestaTradicionRepository _repository = FiestaTradicionRepository();

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

  // Obtener todas las tradiciones
  Future<void> fetchAllTradiciones() async {
    _setLoading(true);
    try {
      _todasLasTradiciones = await _repository.getAllFiestas();
      _error = null;
    } catch (e) {
      _error = 'Error al obtener tradiciones: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Obtener una tradición por ID
  Future<void> fetchTradicionById(int id) async {
    _setLoading(true);
    try {
      _tradicionSeleccionada = await _repository.getFiestaById(id);
      _error = null;
    } catch (e) {
      _error = 'Error al obtener la tradición: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Buscar tradiciones por palabra clave
  Future<void> searchTradiciones(String keyword) async {
    _setLoading(true);
    try {
      _todasLasTradiciones = await _repository.searchFiestas(keyword);
      _error = null;
    } catch (e) {
      _error = 'Error al buscar tradiciones: $e';
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
