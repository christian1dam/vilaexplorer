import 'package:vilaexplorer/models/gastronomia/plato.dart';
import 'package:vilaexplorer/repositories/gastronomia_repository.dart';

class GastronomiaService {
  final GastronomiaRepository _repository;

  GastronomiaService(this._repository);

  // Obtener un plato por su ID
  Future<Plato> getPlatoById(int id) async {
    try {
      return await _repository.getPlatoById(id);
    } catch (e) {
      throw Exception('Error al obtener el plato: $e');
    }
  }

  // Obtener todos los platos
  Future<List<Plato>> getAllPlatos() async {
    try {
      return await _repository.getAllPlatos();
    } catch (e) {
      throw Exception('Error al obtener todos los platos: $e');
    }
  }

  // Crear un nuevo plato
  Future<Plato> createPlato(Plato plato) async {
    try {
      return await _repository.createPlato(plato);
    } catch (e) {
      throw Exception('Error al crear el plato: $e');
    }
  }
}
