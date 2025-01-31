import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vilaexplorer/service/usuario_service.dart';

class ApiClient {
  final String _baseUrl =
      // 'http://172.30.32.1:8080/api/v0';
      //'http://192.168.100.103:8080/api/v0';
   'http://172.20.10.2:8080/api/v0'; // Wifi Móvil
   //'http://192.168.0.35:8080/api/v0'; // Red

  // GET request
  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final response = await http.get(url, headers: _authHeader());
      print(response.headers);
      print(response.reasonPhrase);
      _handleResponse(response);

      return response;
    } catch (e) {
      throw Exception('Error en GET: $e');
    }
  }

  // POST request
  Future<http.Response> post(String endpoint,
      {Map<String, dynamic>? body}) async {
    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await http.post(
        url,
        headers: _defaultHeaders(),
        body: jsonEncode(body),
      );
      print("POST request to $url with body: $body");
      print("Response status: ${response.statusCode}, body: ${response.body}");
      _handleResponse(response);
      return response;
    } catch (e) {
      throw Exception('Error en POST: $e');
    }
  }

  // POST request
  Future<http.Response> postAuth(String endpoint,
      {Map<String, dynamic>? body}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final response = await http.post(
        url,
        headers: _authHeader(),
        body: jsonEncode(body),
      );
      print("POST request to $url with body: $body");
      print("Response status: ${response.statusCode}, body: ${response.body}");
      _handleResponse(response);
      return response;
    } catch (e) {
      throw Exception('Error en POST: $e');
    }
  }

  // PUT request
  Future<http.Response> put(String endpoint,
      {Map<String, dynamic>? body}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final response = await http.put(
        url,
        headers: _authHeader(),
        body: jsonEncode(body),
      );
      _handleResponse(response);
      return response;
    } catch (e) {
      throw Exception('Error en PUT: $e');
    }
  }

  // DELETE request
  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final response = await http.delete(url, headers: _authHeader());
      _handleResponse(response);
      return response;
    } catch (e) {
      throw Exception('Error en DELETE: $e');
    }
  }

  // PATCH request
  Future<http.Response> patch(String endpoint,
      {Map<String, dynamic>? body}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final response = await http.patch(
        url,
        headers: _defaultHeaders(),
        body: jsonEncode(body),
      );
      _handleResponse(response);
      return response;
    } catch (e) {
      throw Exception('Error en PATCH: $e');
    }
  }

  // Configuración de headers por defecto
  Map<String, String> _defaultHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // Manejo de errores HTTP
  void _handleResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode > 299) {
      throw Exception(
        'Error HTTP ${response.statusCode}: ${response.body}',
      );
    }
  }

  Map<String, String> _authHeader() {
    final usuarioAutenticado = UsuarioService().usuarioAutenticado;

    print('${usuarioAutenticado!.type} ${usuarioAutenticado.token}');

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': '${usuarioAutenticado.type} ${usuarioAutenticado.token}',
    };
  }
}
