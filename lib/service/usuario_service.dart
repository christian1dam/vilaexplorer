import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/models/usuario/usuario.dart';

class UsuarioService extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  // Método para crear un nuevo usuario
  Future<bool> signupUsuario(
      String nombre, String email, String password) async {
    const String endpoint = '/auth/signup?rol=Cliente';
    final Map<String, String> body = {
      "nombre": nombre,
      "email": email,
      "password": password,
    };

    try {
      final response = await _apiClient.post(endpoint, body: body);
      if (response.statusCode == 201) {
        return true; // Usuario creado exitosamente
      } else {
        debugPrint('Error al crear usuario: ${response.body}');
        return false; // Fallo en la creación del usuario
      }
    } catch (e) {
      debugPrint('Excepción al crear usuario: $e');
      return false;
    }
  }

  // Método para iniciar sesión
  Future<Usuario?> loginUsuario(String email, String password) async {
    const String endpoint = '/auth/signin';
    final Map<String, String> body = {
      "email": email,
      "password": password,
    };

    try {
      final response = await _apiClient.post(endpoint, body: body);
      if (response.statusCode == 200) {
        final Usuario usuario = Usuario.fromMap(jsonDecode(response.body));
        return usuario; // Retorna el usuario autenticado
      } else {
        debugPrint('Error al iniciar sesión: ${response.body}');
        return null; // Fallo en el inicio de sesión
      }
    } catch (e) {
      debugPrint('Excepción al iniciar sesión: $e');
      return null;
    }
  }
}