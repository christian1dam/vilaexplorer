import 'package:flutter/material.dart';
import 'package:vilaexplorer/models/tradiciones/tradiciones.dart';
import 'package:vilaexplorer/repositories/tradiciones_service.dart';

class TradicionesProvider extends ChangeNotifier {
  final FiestaTradicionService _repository = FiestaTradicionService();

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
  Future<void> fetchAllTradiciones() async {
    await _executeWithLoading(() async {
      _todasLasTradiciones = await _repository.getAllFiestas();
    }, onError: 'Error al obtener tradiciones');
  }

  // Obtener una tradición por ID
  Future<void> fetchTradicionById(int id) async {
    await _executeWithLoading(() async {
      _tradicionSeleccionada = await _repository.getFiestaById(id);
    }, onError: 'Error al obtener la tradición');
  }

  // Buscar tradiciones por palabra clave
  Future<void> searchTradiciones(String keyword) async {
    await _executeWithLoading(() async {
      _todasLasTradiciones = await _repository.searchFiestas(keyword);
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