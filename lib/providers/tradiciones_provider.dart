import 'package:flutter/material.dart';
import 'package:vilaexplorer/models/page.dart' as model;
import 'package:vilaexplorer/models/tradiciones/tradiciones.dart';
import 'package:vilaexplorer/service/tradiciones_service.dart';

class TradicionesProvider extends ChangeNotifier {
  final TradicionesService _tradicionesService = TradicionesService();

  List<Tradiciones> _tradiciones = [];
  List<Tradiciones> get tradiciones => _tradiciones;

  model.Page<Tradiciones>? _paginatedTradiciones;
  model.Page<Tradiciones>? get paginatedTradiciones => _paginatedTradiciones;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Método para cargar todas las tradiciones
  Future<void> fetchAllTradiciones() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _tradiciones = await _tradicionesService.getAllTradiciones();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al cargar las tradiciones: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Método para buscar tradiciones por palabra clave
  Future<void> searchTradiciones(String keyword) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _tradiciones = await _tradicionesService.searchTradiciones(keyword);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al buscar tradiciones: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Método para buscar tradiciones paginadas
  Future<void> searchTradicionesPaginated(
      String keyword, Map<String, dynamic> paginationParams) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _paginatedTradiciones =
          await _tradicionesService.searchTradicionesPaginated(
        keyword,
        paginationParams,
      );
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al buscar tradiciones paginadas: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Método para obtener una tradición por ID
  Future<Tradiciones?> getTradicionById(int id) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      return await _tradicionesService.getTradicionById(id);
    } catch (e) {
      _errorMessage = 'Error al obtener la tradición: $e';
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Método para manejar el estado de carga
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}