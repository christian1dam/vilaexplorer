import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/exception/invalid_password_exception.dart';
import 'package:vilaexplorer/models/usuario/usuario.dart';

class UsuarioService extends ChangeNotifier {
  late Usuario? usuarioAutenticado;
  String? _error;

  final ApiClient _apiClient = ApiClient();

  String? get error => _error;

  // Método para crear un nuevo usuario
  Future<bool> signupUsuario(
      String nombre, String email, String password, String assertPassword) async {
    const String endpoint = '/auth/signup?rol=Cliente';

    if(password != assertPassword) throw InvalidPasswordException("Las contraseñas no coinciden");
    
    Usuario usuario = Usuario(nombre: nombre, email: email, password: password);

    try {
      final response = await _apiClient.post(endpoint, body: usuario.registerRequest());
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
  Future<void> loginUsuario(String email, String password) async {
    const String endpoint = '/auth/signin';
    Usuario usuario = Usuario(email: email, password: password);

    try {
      final response =
          await _apiClient.post(endpoint, body: usuario.loginRequest());
      if (response.statusCode == 200) {
        final Usuario usuario = Usuario.fromMap(jsonDecode(response.body));
        usuarioAutenticado =
            usuario; // Guarda en el servicio el usuario autenticado
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
  void cerrarSesion() {
    usuarioAutenticado = null;
    _error = null;
    notifyListeners();
  }
}
