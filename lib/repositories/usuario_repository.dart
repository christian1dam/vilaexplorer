import 'dart:convert';

import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/models/usuario/usuario.dart';

class UsuarioRepository {
  final ApiClient _apiClient = ApiClient();

  // Obtener un usuario por ID
  Future<Usuario> getUsuarioById(int id) async {
    final response = await _apiClient.get(  '/usuario/$id');
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
    final response = await _apiClient.post(
      '/usuario/add?rol=$rol',
      body: usuario.toMap(),
    );
    return Usuario.fromMap(json.decode(response.body));
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
