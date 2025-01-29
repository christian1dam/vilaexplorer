import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._internal();
  late final FlutterSecureStorage _storage;
  FlutterSecureStorage get storage => _storage;

  factory UserPreferences() {
    return _instance;
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  UserPreferences._internal() {
    _storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  }

  Future<String> get typeToken async {
    String? type = await _storage.read(key: 'typeToken');
    return type!;
  }

  Future<void> setTypeToken(String typeToken) async {
    await _storage.write(key: 'typeToken', value: typeToken);
  }

  Future<String> get token async {
    String? token = await _storage.read(key: 'token');
    return token!;
  }

  Future<void> setToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<void> setId(int id) async {
    await _storage.write(key: 'id', value: id.toString());
  }

  Future<int> get id async {
    final id = await _storage.read(key: 'id');
    return int.parse(id!);
  }

  Future<void> setSesion(bool estado) async {
    await storage.write(key: 'estadoSesion', value: estado.toString());
  }

  Future<bool> get sesion async {
    final estadoSesion = await storage.read(key: 'estadoSesion');
    return estadoSesion == 'true' ? true : false;
  }

  Future<String> get username async {
    String? username = await _storage.read(key: 'username');
    return username!;
  }

  Future<void> setUsername(String username) async {
    await _storage.write(key: 'username', value: username);
  }

    Future<String> get email async {
    String? email = await _storage.read(key: 'email');
    return email!;
  }

  Future<void> setEmail(String email) async {
    await _storage.write(key: 'email', value: email);
  }
}
