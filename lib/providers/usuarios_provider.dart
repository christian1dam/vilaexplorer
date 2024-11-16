import 'package:flutter/material.dart';
import 'package:vilaexplorer/models/usuario/usuario.dart';
import 'package:vilaexplorer/service/usuario_service.dart';


class UsuarioProvider extends ChangeNotifier {
  final UsuarioService _usuarioService = UsuarioService();

  // Estado local
  Usuario? _usuarioAutenticado;
  String? _error;

  // Getters
  Usuario? get usuarioAutenticado => _usuarioAutenticado;
  String? get error => _error;

  // Autenticar usuario (inicio de sesión)
  Future<void> autenticarUsuario(String nombre, String password) async {
    try {
      _usuarioAutenticado = await _usuarioService
          .obtenerUsuarioPorNombreYPassword(nombre, password);
      _error = null; // Limpia errores previos
      notifyListeners();
    } catch (e) {
      _usuarioAutenticado = null;
      _error = 'Error al autenticar el usuario: $e';
      notifyListeners();
    }
  }

  // Registrar un nuevo usuario
  Future<void> registrarUsuario(Usuario usuario, String rol) async {
    try {
      _usuarioAutenticado = await _usuarioService.crearUsuario(usuario, rol);
      _error = null; // Limpia errores previos
      notifyListeners();
    } catch (e) {
      _error = 'Error al registrar el usuario: $e';
      notifyListeners();
    }
  }

  // Actualizar datos del usuario autenticado
  Future<void> actualizarUsuario(Usuario usuario) async {
    if (_usuarioAutenticado == null) {
      _error = 'No hay usuario autenticado';
      notifyListeners();
      return;
    }

    try {
      _usuarioAutenticado = await _usuarioService.actualizarUsuario(
          _usuarioAutenticado!.idUsuario, usuario);
      _error = null; // Limpia errores previos
      notifyListeners();
    } catch (e) {
      _error = 'Error al actualizar el usuario: $e';
      notifyListeners();
    }
  }

  // Desactivar la cuenta del usuario autenticado
  Future<void> desactivarCuenta() async {
    if (_usuarioAutenticado == null) {
      _error = 'No hay usuario autenticado';
      notifyListeners();
      return;
    }

    try {
      await _usuarioService.desactivarUsuario(_usuarioAutenticado!.idUsuario);
      _usuarioAutenticado = null; // Limpia el usuario autenticado
      _error = null; // Limpia errores previos
      notifyListeners();
    } catch (e) {
      _error = 'Error al desactivar la cuenta: $e';
      notifyListeners();
    }
  }

  // Cerrar sesión
  void cerrarSesion() {
    _usuarioAutenticado = null;
    _error = null;
    notifyListeners();
  }

  // Limpiar errores
  void limpiarError() {
    _error = null;
    notifyListeners();
  }
}