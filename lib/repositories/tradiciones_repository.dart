import 'dart:convert';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/models/page.dart';
import 'package:vilaexplorer/models/tradiciones/tradiciones.dart';

class FiestaTradicionRepository {
  final ApiClient _apiClient = ApiClient();

  // Obtener una fiesta tradicional por su ID
  Future<Tradiciones> getFiestaById(int id) async {
    final response = await _apiClient.get('/fiesta_tradicion/detalle/$id');
    return Tradiciones.fromMap(json.decode(response.body));
  }

  // Obtener todas las fiestas tradicionales
  Future<List<Tradiciones>> getAllFiestas() async {
    try {
      final response = await _apiClient.get('/fiesta_tradicion/todos');
      if (response.statusCode == 200) {
        final List<dynamic> tradicionesList = json.decode(response.body);
        return tradicionesList
            .map((tradicion) => Tradiciones.fromMap(tradicion))
            .toList();
      } else {
        throw Exception(
            'Error al obtener las tradiciones: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener las tradiciones: $e');
    }
  }

  // Buscar fiestas tradicionales por palabra clave
  Future<List<Tradiciones>> searchFiestas(String keyword) async {
    final response = await _apiClient
        .get('/fiesta_tradicion/buscar_palabra?keyword=$keyword');
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Tradiciones.fromMap(json)).toList();
  }

  // Buscar fiestas tradicionales por palabra clave con paginación
  Future<Page<Tradiciones>> searchFiestasPaginated(
      String keyword, Map<String, dynamic> paginationParams) async {
    final uri = Uri.parse('/fiesta_tradicion/buscar')
        .replace(queryParameters: {'keyword': keyword, ...paginationParams});
    final response = await _apiClient.get(uri.toString());

    // Decodificar el JSON y pasar la función de mapeo
    return Page<Tradiciones>.fromMap(
      json.decode(response.body),
      (json) => Tradiciones.fromMap(json), // Mapea cada elemento a Tradiciones
    );
  }
}