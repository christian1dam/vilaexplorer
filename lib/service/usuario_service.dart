import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/exception/invalid_password_exception.dart';
import 'package:vilaexplorer/models/usuario/usuario_auth.dart';
import 'package:vilaexplorer/user_preferences/user_preferences.dart';

class UsuarioService {
  final userPreferences = UserPreferences();

  final ApiClient _apiClient = ApiClient();

  Future<bool> signupUsuario(String nombre, String email, String password,
      String assertPassword) async {
    const String endpoint = '/auth/signup?rol=Cliente';
    late UsuarioAuth usuario;

    password != assertPassword
        ? throw InvalidPasswordException("Las contraseñas no coinciden")
        : usuario = UsuarioAuth(
            username: nombre,
            email: email,
            password: password); //TODO -> SE DEBEN MANEJAR DESDE EL FORMULARIO

    try {
      final response = await _apiClient.post(endpoint, body: usuario.toMap());
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint('Error al crear usuario: ${e.toString()}');
      throw Exception(e);
    }
    return false;
  }

  Future<bool> loginUsuario(String email, String password) async {
    const String endpoint = '/auth/signin';
    UsuarioAuth usuario = UsuarioAuth(email: email, password: password);

    try {
      final response =
          await _apiClient.post(endpoint, body: usuario.loginRequest());

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        await userPreferences.setTypeToken(data['type']);
        await userPreferences.setToken(data['token']);
        await userPreferences.setId(data['id']);
        await userPreferences.setSesion(true);
        await userPreferences.setUsername(data['username']);
        await userPreferences.setEmail(data['email']);

        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Excepción al iniciar sesión");
    }
    return false;
  }
}
