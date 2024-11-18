import 'dart:async';
import 'dart:convert';

import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/models/usuario/usuario.dart';

class UsuarioRepository {
  final ApiClient _apiClient = ApiClient();

  // Método para autenticar al usuario
  Future<Usuario?> autenticarUsuario(String nombre, String password) async {
    final endpoint = '/usuario/signIn?nombre=$nombre&password=$password';

    try {
      final response = await _apiClient.get(endpoint);
      if (response.statusCode == 200) {
        return Usuario.fromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error al autenticar al usuario: $e');
    }
  }

  // Obtener un usuario por ID
  Future<Usuario> getUsuarioById(int id) async {
    final response = await _apiClient.get('/usuario/$id');
    return Usuario.fromMap(json.decode(response.body));
  }

  // Obtener un usuario por nombre y contraseña
  Future<Usuario> getUsuarioByNombreYPassword(
      String nombre, String password) async {
    final response = await _apiClient
        .get('/usuario/signIn?nombre=$nombre&password=$password');
    return Usuario.fromMap(json.decode(response.body));
  }

// Crear un nuevo usuario con un rol
  Future<Usuario> createUsuario(Usuario usuario, String rol) async {
    try {
      print("Se ha entrado en el Repository");
      final response = await _apiClient.post(
        '/usuario/add?rol=$rol',
        body: usuario.toMap(),  
      );

      // Validación de la respuesta
      if (response.statusCode == 201) {
        final usuarioCreado = Usuario.fromMap(json.decode(response.body));
        print("Usuario creado: $usuarioCreado");
        return usuarioCreado;
      } else {
        print("Error en la creación del usuario: ${response.body}");
        throw Exception('Error en el servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en el Repository al crear usuario: $e');
    }
  }

  // Actualizar un usuario existente
  Future<Usuario> updateUsuario(int id, Usuario usuario) async {
    final response =
        await _apiClient.put('/usuario/$id', body: usuario.toMap());
    return Usuario.fromMap(json.decode(response.body));
  }

  // Borrado lógico de un usuario
  Future<void> deleteUsuarioLogico(int id) async {
    await _apiClient.put('/usuario/desactivar/$id');
  }
}