import 'package:flutter/material.dart';
import '../models/gastronomia/categoria_plato.dart';

class CategoriaPlatoProvider extends ChangeNotifier {
  // final CategoriaPlatoService _repository = CategoriaPlatoService();

  // List<CategoriaPlato> _categorias = [];
  // bool _isLoading = false;

  // // Getters para acceder a las categorías y el estado de carga
  // List<CategoriaPlato> get categorias => _categorias;
  // bool get isLoading => _isLoading;

  // // Método para cargar todas las categorías desde el repositorio
  // Future<void> fetchCategorias() async {
  //   _isLoading = true; // Indica que los datos están cargando
  //   notifyListeners();

  //   try {
  //     // Llama al repositorio para obtener las categorías
  //     final categorias = await _repository.getAllCategorias();
  //     _categorias = categorias; 
  //   } catch (e) {
  //     // Manejo de errores
  //     print('Error al cargar las categorías: $e');
  //   } finally {
  //     // Indica que la carga ha terminado
  //     _isLoading = false;
  //     notifyListeners(); // Notifica a los widgets para que se actualicen
  //   }
  // }
}
