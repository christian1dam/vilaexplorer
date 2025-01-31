import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/exception/invalid_password_exception.dart';
import 'package:vilaexplorer/models/usuario/usuario_auth.dart';
import 'package:vilaexplorer/user_preferences/user_preferences.dart';

class UsuarioService {
  final userPreferences = UserPreferences();

  final ApiClient _apiClient = ApiClient();

  Future<bool> editarNombre(String nuevoNombre) async {
    const String endpoint = '/usuario/editar/nombre';

    try {
      final response = await _apiClient.put(
        endpoint,
        body: {'nombre': nuevoNombre},
      );

      if (response.statusCode == 200) {
        await userPreferences.setUsername(nuevoNombre);
        return true;
      } else {
        throw Exception(
            "Ha habido un problema de conexión con el servidor, inténtelo más tarde.");
      }
    } catch (e) {
      throw Exception(
          "Ha habido un problema de conexión con el servidor, inténtelo más tarde.");
    }
  }

  Future<bool> editarContrasenya(
      String nuevaContrasenya, String actualContrasenya) async {
    const String endpoint = '/usuario/editar/contrasenya';

    if (nuevaContrasenya.isEmpty || actualContrasenya.isEmpty) {
      throw Exception('Las contraseñas no pueden estar vacías');
    } // TODO -> ESTO SE DEBE MANEJAR DESDE LA INTERFAZ Y NO DESDE LOS SERVICIOS

    try {
      final response = await _apiClient.put(
        endpoint,
        body: {
          'contrasenya_actual': actualContrasenya,
          'nueva_contrasenya': nuevaContrasenya,
        },
      );

      if (response.statusCode == 200) {
        // AHORA NO SE GUARDAN LAS CONTRASEÑAS DEL USUARIO EN EL CLIENTE
        return true;
      } else {
        debugPrint('Error al actualizar la contraseña: ${response.body}');
        throw Exception("Error al actualizar la contraseña: ${response.body}");
      }
    } catch (e) {
      debugPrint('Excepción al actualizar la contraseña: $e');
      throw Exception("Error al actualizar la contraseña: $e");
    }
  }

  Future<bool> signUp(String nombre, String email, String password,
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

  Future<bool> logIn(String email, String password) async {
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
