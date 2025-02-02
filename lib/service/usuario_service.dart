import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/exception/invalid_password_exception.dart';
import 'package:vilaexplorer/models/usuario/usuario.dart';
import 'package:vilaexplorer/user_preferences/user_preferences.dart';

class UsuarioService {
  final userPreferences = UserPreferences();
  final ApiClient _apiClient = ApiClient();

  Future<bool> actualizarUsuario(Usuario usuario) async {
    final int userID = await userPreferences.id;
    final String endpoint = '/usuario/update/$userID';
    try {
      final response = await _apiClient.put(endpoint, body: usuario.toMap());
      if (response.statusCode == 200) {
        debugPrint("RESPUESTA AL PUT: ${jsonDecode(utf8.decode(response.bodyBytes))}");
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        debugPrint("Valor de data['nombre']: ${data['nombre']}");
        if (data['nombre'].toString().isNotEmpty) {
          debugPrint("Nombre recibido: ${data['nombre']}"); 
          await userPreferences.setUsername(data['nombre']);
          debugPrint(await userPreferences.username);
        }
        if (data['email'] != null) {
          await userPreferences.setEmail(data['email']);
        }
        return true;
      } else {
        debugPrint('Error al actualizar el usuario: ${response.body}');
        throw Exception("Error al actualizar el usuario: ${response.body}");
      }
    } catch (e) {
      debugPrint('Excepción al actualizar el usuario: $e');
      throw Exception("Error al actualizar el usuario: $e");
    }
  }

  Future<bool> signUp(String nombre, String email, String password,
      String assertPassword) async {
    const String endpoint = '/auth/signup?rol=Cliente';
    late Usuario usuario;

    password != assertPassword
        ? throw InvalidPasswordException("Las contraseñas no coinciden")
        : usuario = Usuario(
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
    Usuario usuario = Usuario(email: email, password: password);

    try {
      final response = await _apiClient.post(endpoint, body: usuario.toMap());

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

  Future<bool> validatePassword(String password) async {
    final id = await UserPreferences().id;
    final String endpoint = '/usuario/validatePassword';

    Usuario usuario = Usuario(idUsuario:id, password: password);
    try {
      final response = await _apiClient.postAuth(endpoint, body: usuario.toMap());
      if (response.statusCode == 200){
        return jsonDecode(response.body);
      } 
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Excepcion al validar la contraseña $e");
    }
    return false;
  }
}
