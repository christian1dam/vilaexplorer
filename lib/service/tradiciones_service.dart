import 'package:vilaexplorer/models/page.dart';
import 'package:vilaexplorer/models/tradiciones/tradiciones.dart';
import 'package:vilaexplorer/repositories/tradiciones_repository.dart';

class TradicionesService {
  final FiestaTradicionRepository _repository = FiestaTradicionRepository();

  // Obtener todas las tradiciones
  Future<List<Tradiciones>> getAllTradiciones() async {
    try {
      return await _repository.getAllFiestas();
    } catch (e) {
      throw Exception('Error al obtener tradiciones: $e');
    }
  }

  // Obtener una tradición por ID
  Future<Tradiciones> getTradicionById(int id) async {
    try {
      return await _repository.getFiestaById(id);
    } catch (e) {
      throw Exception('Error al obtener la tradición: $e');
    }
  }

  // Buscar tradiciones por palabra clave
  Future<List<Tradiciones>> searchTradiciones(String keyword) async {
    try {
      return await _repository.searchFiestas(keyword);
    } catch (e) {
      throw Exception('Error al buscar tradiciones: $e');
    }
  }

  // Buscar tradiciones por palabra clave con paginación
  Future<Page<Tradiciones>> searchTradicionesPaginated(
    String keyword,
    Map<String, dynamic> paginationParams,
  ) async {
    try {
      return await _repository.searchFiestasPaginated(
        keyword,
        paginationParams,
      );
    } catch (e) {
      throw Exception('Error al buscar tradiciones paginadas: $e');
    }
  }
}