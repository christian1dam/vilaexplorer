import 'package:vilaexplorer/models/usuario/usuario.dart';
import 'package:vilaexplorer/repositories/usuario_repository.dart';

class UsuarioService {
  final UsuarioRepository _usuarioRepository = UsuarioRepository();

  // Obtener un usuario por ID
  Future<Usuario> obtenerUsuarioPorId(int id) async {
    try {
      return await _usuarioRepository.getUsuarioById(id);
    } catch (e) {
      throw Exception('Error al obtener el usuario por ID: $e');
    }
  }

  // Obtener un usuario por nombre y contraseña
  Future<Usuario> obtenerUsuarioPorNombreYPassword(
      String nombre, String password) async {
    try {
      return await _usuarioRepository.getUsuarioByNombreYPassword(
          nombre, password);
    } catch (e) {
      throw Exception('Error al autenticar al usuario: $e');
    }
  }

// Crear un nuevo usuario con un rol
  Future<Usuario> crearUsuario(Usuario usuario, String rol) async {
    try {
      print("Se ha entrado en el Service");
      final usuarioCreado =
          await _usuarioRepository.createUsuario(usuario, rol);
      print("Usuario creado en el Service: $usuarioCreado");
      return usuarioCreado;
    } catch (e) {
      print("Error en el Service al crear usuario: $e");
      throw Exception('Error al crear el usuario: $e');
    }
  }

  // Actualizar un usuario existente
  Future<Usuario> actualizarUsuario(int id, Usuario usuario) async {
    try {
      return await _usuarioRepository.updateUsuario(id, usuario);
    } catch (e) {
      throw Exception('Error al actualizar el usuario: $e');
    }
  }

  // Borrado lógico de un usuario
  Future<void> desactivarUsuario(int id) async {
    try {
      await _usuarioRepository.deleteUsuarioLogico(id);
    } catch (e) {
      throw Exception('Error al desactivar el usuario: $e');
    }
  }
}