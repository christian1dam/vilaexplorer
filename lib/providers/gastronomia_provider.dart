import 'package:flutter/material.dart';
import 'package:vilaexplorer/models/gastronomia/plato.dart';
import 'package:vilaexplorer/service/gastronomia_service.dart';

class GastronomiaProvider extends ChangeNotifier {
  final GastronomiaService _gastronomiaService = GastronomiaService();

  List<Plato> _platos = [];
  List<Plato> get platos => _platos;

  Plato? _platoSeleccionado;
  Plato? get platoSeleccionado => _platoSeleccionado;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Método para cargar todos los platos
  Future<void> fetchAllPlatos() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _platos = await _gastronomiaService.getAllPlatos();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al cargar los platos: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Método para obtener un plato por su ID
  Future<void> fetchPlatoById(int id) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _platoSeleccionado = await _gastronomiaService.getPlatoById(id);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al obtener el plato: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Método para crear un nuevo plato
  Future<void> createPlato(Plato plato) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final platoCreado = await _gastronomiaService.createPlato(plato);
      _platos.add(platoCreado); // Agregar el plato creado a la lista
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al crear el plato: $e';
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