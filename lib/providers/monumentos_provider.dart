import 'package:flutter/material.dart';
import 'package:vilaexplorer/models/monumentos/monumento.dart';
import 'package:vilaexplorer/service/monumentos_service.dart';

class MonumentosProvider extends ChangeNotifier {
  final MonumentosService _repository = MonumentosService();

  // Estado local
  List<Monumentos>? _todosLosMonumentos;
  Monumentos? _monumentoSeleccionado;
  String? _error;
  bool _isLoading = false;

  // Getters
  List<Monumentos>? get todosLosMonumentos => _todosLosMonumentos;
  Monumentos? get monumentoSeleccionado => _monumentoSeleccionado;
  String? get error => _error;
  bool get isLoading => _isLoading;

  // Métodos públicos para manejar el estado

  // Obtener todos los monumentos
  Future<void> fetchAllMonumentos() async {
    await _executeWithLoading(() async {
      _todosLosMonumentos = await _repository.getAllMonumentos();
    }, onError: 'Error al obtener monumentos');
  }

  // Obtener un monumento por ID
  Future<void> fetchMonumentoById(int id) async {
    await _executeWithLoading(() async {
      _monumentoSeleccionado = await _repository.getMonumentoById(id);
    }, onError: 'Error al obtener el monumento');
  }

  // Buscar monumentos por palabra clave
  Future<void> searchMonumentos(String keyword) async {
    await _executeWithLoading(() async {
      _todosLosMonumentos = await _repository.searchMonumentos(keyword);
    }, onError: 'Error al buscar monumentos');
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
