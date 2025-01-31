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
  Usuario getUsuario() => allUserData;

  Future<bool> editarNombreUsuario(String nuevoNombre) async {
    const String endpoint = '/usuario/editar/nombre';

    try {
      final response = await _apiClient.put(
        endpoint,
        body: {'nombre': nuevoNombre}, // Pasa directamente el Map
      );

      if (response.statusCode == 200) {
        allUserData.nombre = nuevoNombre;
        notifyListeners();
        return true;
      } else {
        _error = 'Error al actualizar el nombre del usuario: ${response.body}';
        debugPrint('Error al actualizar el nombre: ${response.body}');
        return false;
      }
    } catch (e) {
      _error = 'Error al actualizar el nombre: $e';
      debugPrint('Excepción al actualizar el nombre: $e');
      return false;
    }
  }

  Future<bool> editarContrasenyaUsuario(
      String nuevaContrasenya, String actualContrasenya) async {
    const String endpoint = '/usuario/editar/contrasenya';

    if (nuevaContrasenya.isEmpty || actualContrasenya.isEmpty) {
      _error = 'Las contraseñas no pueden estar vacías';
      return false;
    }

    try {
      final response = await _apiClient.put(
        endpoint,
        body: {
          'contrasenya_actual': actualContrasenya,
          'nueva_contrasenya': nuevaContrasenya,
        },
      );

      if (response.statusCode == 200) {
        allUserData.password = nuevaContrasenya;
        notifyListeners();
        return true;
      } else {
        _error = 'Error al actualizar la contraseña: ${response.body}';
        debugPrint('Error al actualizar la contraseña: ${response.body}');
        return false;
      }
    } catch (e) {
      _error = 'Error al actualizar la contraseña: $e';
      debugPrint('Excepción al actualizar la contraseña: $e');
      return false;
    }
  }

  Future<bool> signupUsuario(String nombre, String email, String password,
      String assertPassword) async {
    const String endpoint = '/auth/signup?rol=Cliente';

    if (password != assertPassword) {
      throw InvalidPasswordException("Las contraseñas no coinciden");
    }

    UsuarioAuth usuario = UsuarioAuth(username: nombre, email: email, password: password);

    try {
      final response = await _apiClient.post(
        endpoint,
        body: usuario.registerRequest(),
      );
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
      final response = await _apiClient.post(
        endpoint,
        body: usuario.loginRequest(),
      );

      if (response.statusCode == 200) {
        usuarioAutenticado =
            UsuarioAuth.fromMap(jsonDecode(response.body));

        allUserData = await getUsuarioByID(usuarioAutenticado!.id!);
        notifyListeners();
      } else {
        debugPrint('Error al iniciar sesión: ${response.body}');
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error al autenticar al usuario: $e';
      debugPrint('Excepción al iniciar sesión: $e');
      notifyListeners();
    }
  }

  void cerrarSesion() {
    usuarioAutenticado = null;
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
      _error = 'Error al obtener el usuario por ID: $e';
      debugPrint(e.toString());
      throw Exception('Error al obtener el usuario por ID: $e');
    }
  }
}
