import 'package:flutter/material.dart';
import 'package:vilaexplorer/models/gastronomia/plato.dart';

class GastronomiaProvider with ChangeNotifier {
  // final GastronomiaService platoRepository = GastronomiaService();

  // // Estado local
  // List<Plato>? _platos;
  // Plato? _platoSeleccionado;
  // String? _error;
  // bool _isLoading = false;

  // // Getters
  // List<Plato>? get platos => _platos;
  // Plato? get platoSeleccionado => _platoSeleccionado;
  // String? get error => _error;
  // bool get isLoading => _isLoading;

  // // Obtener todos los platos con retraso artificial
  // Future<void> fetchAllPlatos() async {
  //   _setLoading(true);
  //   try {
  //     // Simula un retraso de 2 segundos antes de cargar los datos reales
  //     await Future.delayed(const Duration(seconds: 2));
  //     _platos = await platoRepository.getAllPlatos();
  //     _error = null;
  //   } catch (e) {
  //     _error = 'Error al obtener los platos: $e';
  //   } finally {
  //     _setLoading(false);
  //   }
  // }

  // // Obtener un plato por ID
  // Future<void> fetchPlatoById(int id) async {
  //   _setLoading(true);
  //   try {
  //     _platoSeleccionado = await platoRepository.getPlatoById(id);
  //     _error = null;
  //   } catch (e) {
  //     _error = 'Error al obtener el plato: $e';
  //   } finally {
  //     _setLoading(false);
  //   }
  // }

  // // Actualizar el estado de carga
  // void _setLoading(bool value) {
  //   _isLoading = value;
  //   notifyListeners();
  // }

  // // Limpiar errores
  // void limpiarError() {
  //   _error = null;
  //   notifyListeners();
  // }
}
