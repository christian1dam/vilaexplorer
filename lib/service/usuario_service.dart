import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/exception/invalid_password_exception.dart';
import 'package:vilaexplorer/models/usuario/usuario.dart';
import 'package:vilaexplorer/models/usuario/usuario_auth.dart';

class UsuarioService extends ChangeNotifier {
  static final UsuarioService _instance = UsuarioService._internal();

  late UsuarioAuth? usuarioAutenticado;

  late Usuario allUserData;

  UsuarioService._internal();

  factory UsuarioService() {
    return _instance;
  }

  String? _error;

  final ApiClient _apiClient = ApiClient();

  String? get error => _error;

  // Método para crear un nuevo usuario
  Future<bool> signupUsuario(String nombre, String email, String password,
      String assertPassword) async {
    const String endpoint = '/auth/signup?rol=Cliente';

    if (password != assertPassword) {
      throw InvalidPasswordException("Las contraseñas no coinciden");
    }

    UsuarioAuth usuario = UsuarioAuth(email: email, password: password);

    try {
      final response =
          await _apiClient.post(endpoint, body: usuario.registerRequest());
      if (response.statusCode == 201) {
        return true; // Usuario creado exitosamente
      }
    } catch (e) {
      debugPrint('Error al crear usuario: ${e.toString()}');
    }
    return false; // Fallo en la creación del usuario
  }

  // Método para iniciar sesión
  Future<void> loginUsuario(String email, String password) async {
    const String endpoint = '/auth/signin';
    UsuarioAuth usuario = UsuarioAuth(email: email, password: password);

    try {
      final response =
          await _apiClient.post(endpoint, body: usuario.loginRequest());
      if (response.statusCode == 200) {
        usuarioAutenticado =
            UsuarioAuth.fromMap(jsonDecode(response.body));

        allUserData = await getUsuarioByID(usuarioAutenticado!.id!);
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

  Future<Usuario> getUsuarioByID(int id) async {
    try {
      final response = await _apiClient.get('/usuario/$id');
      if (response.statusCode == 200) {
        Usuario usuario = Usuario.fromMap(jsonDecode(response.body));

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
