import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserPreferences extends ChangeNotifier {
  static final UserPreferences _instance = UserPreferences._internal();
  late final FlutterSecureStorage _storage;
  FlutterSecureStorage get storage => _storage;
  String _nombre = '';
  String _email = '';

  String get nombre => _nombre;
  String get correo => _email;

  factory UserPreferences() {
    return _instance;
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  UserPreferences._internal() {
    _storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  }

  Future<void> loadUserData() async {
    _nombre = await _storage.read(key: 'username') ?? 'Usuario desconocido';
    _email = await _storage.read(key: 'email') ?? 'Email no disponible';
    notifyListeners();
  }

  Future<String> get typeToken async {
    return await _storage.read(key: 'typeToken') ?? '';
  }

  Future<void> setTypeToken(String typeToken) async {
    await _storage.write(key: 'typeToken', value: typeToken);
  }

  Future<String> get token async {
    return await _storage.read(key: 'token') ?? '';
  }

  Future<void> setToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<void> setId(int id) async {
    await _storage.write(key: 'id', value: id.toString());
  }

  Future<int> get id async {
    final id = await _storage.read(key: 'id');
    return id != null ? int.tryParse(id) ?? 0 : 0;
  }

  Future<void> setSesion(bool estado) async {
    await storage.write(key: 'estadoSesion', value: estado.toString());
  }

  Future<bool> get sesion async {
    final estadoSesion = await storage.read(key: 'estadoSesion');
    return estadoSesion?.toLowerCase() == 'true';
  }

  Future<String> get username async {
    return await _storage.read(key: 'username') ?? 'Usuario desconocido';
  }

  Future<void> setUsername(String username) async {
    await _storage.write(key: 'username', value: username);
    _nombre = username;
    notifyListeners();
  }

  Future<String> get email async {
    return await _storage.read(key: 'email') ?? 'Email no disponible';
  }

  Future<void> setEmail(String email) async {
    await _storage.write(key: 'email', value: email);
    _email = email;
    notifyListeners();
  }
}
