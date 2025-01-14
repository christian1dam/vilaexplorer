import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vilaexplorer/models/monumentos/monumento.dart';

class MonumentosService {
  // URL base de la API (puedes adaptarlo según tu estructura)
  final String apiUrl = 'https://tuapi.com/monumentos';

  // Obtener todos los monumentos
  Future<List<Monumentos>> getAllMonumentos() async {
    final response = await http.get(Uri.parse('$apiUrl/all'));
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Monumentos.fromMap(json)).toList();
    } else {
      throw Exception('Error al obtener los monumentos');
    }
  }

  // Obtener un monumento por ID
  Future<Monumentos> getMonumentoById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));
    
    if (response.statusCode == 200) {
      return Monumentos.fromMap(json.decode(response.body));
    } else {
      throw Exception('Error al obtener el monumento');
    }
  }

  // Buscar monumentos por palabra clave
  Future<List<Monumentos>> searchMonumentos(String keyword) async {
    final response = await http.get(Uri.parse('$apiUrl/search?query=$keyword'));
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Monumentos.fromMap(json)).toList();
    } else {
      throw Exception('Error al buscar monumentos');
    }
  }
}
