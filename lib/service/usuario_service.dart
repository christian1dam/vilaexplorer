import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/exception/invalid_password_exception.dart';
import 'package:vilaexplorer/models/usuario/usuario.dart';
import 'package:vilaexplorer/models/usuario/usuario_auth.dart';
import 'package:vilaexplorer/user_preferences/user_preferences.dart';

class UsuarioService extends ChangeNotifier {
  final userPreferences = UserPreferences();
  late Usuario allUserData;

  String? _error;

  final ApiClient _apiClient = ApiClient();

  String? get error => _error;
  Usuario getUsuario() => allUserData;

  Future<bool> signupUsuario(String nombre, String email, String password,
      String assertPassword) async {
    const String endpoint = '/auth/signup?rol=Cliente';

    if (password != assertPassword) {
      throw InvalidPasswordException("Las contraseñas no coinciden");
    }

    UsuarioAuth usuario = UsuarioAuth(username: nombre, email: email, password: password);

    try {
      final response = await _apiClient.post(endpoint, body: usuario.toMap());
      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      debugPrint('Error al crear usuario: ${e.toString()}');
    }
    return false;
  }

  Future<void> loginUsuario(String email, String password) async {
    const String endpoint = '/auth/signin';
    UsuarioAuth usuario = UsuarioAuth(email: email, password: password);

    try {
      final response = await _apiClient.post(endpoint, body: usuario.loginRequest());

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        await userPreferences.setTypeToken(data['type']);
        await userPreferences.setToken(data['token']);
        await userPreferences.setId(data['id']);
        await userPreferences.setPassword(data['password']);
        await userPreferences.setSesion(true);

        allUserData = await getUsuarioByID(data['id']);
        notifyListeners();
      } else {
        debugPrint('Error al iniciar sesión: ${response.body}');
        notifyListeners(); // Fallo en el inicio de sesión
      }
    } catch (e) {
      _error = 'Error al autenticar al usuario: $e';
      debugPrint('Excepción al iniciar sesión: $e');
      notifyListeners();
    }
  }

  // Método para cerrar sesión
  void cerrarSesion() async {
    await userPreferences.storage.deleteAll();
    _error = null;
    notifyListeners();
  }

  Future<Usuario> getUsuarioByID(int id) async {
    try {
      final response = await _apiClient.get('/usuario/por-id/$id');
      if (response.statusCode == 200) {
        Usuario usuario = Usuario.fromMap(jsonDecode(utf8.decode(response.bodyBytes)));

        return usuario;
      } else {
        throw Exception('Error al obtener el usuario: ${response.body}');
      }
    } catch (e) {
      _error = 'error al obtener el usuario por ID: $e';
      debugPrint(e.toString());
      throw Exception('Error al obtener el usuario por ID: $e');
    }
  }
}
