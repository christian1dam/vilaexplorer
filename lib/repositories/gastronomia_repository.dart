import 'dart:convert';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/models/gastronomia/plato.dart';


class GastronomiaRepository {
  final ApiClient _apiClient = ApiClient();

  // Obtener un plato por su ID
  Future<Plato> getPlatoById(int id) async {
    final response = await _apiClient.get('/plato/detalle/$id');
    return Plato.fromMap(json.decode(response.body));
  }

  // Obtener todos los platos
  Future<List<Plato>> getAllPlatos() async {
    final response = await _apiClient.get('/plato/todos');
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Plato.fromMap(json)).toList();
  }

  // Crear un nuevo plato
  Future<Plato> createPlato(Plato plato) async {
    final response = await _apiClient.post(
      '/plato/crear',
      body: plato.toMap(),
    );
    return Plato.fromMap(json.decode(response.body));
  }
}
