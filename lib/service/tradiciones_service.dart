import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/models/tradiciones/tradiciones.dart';
import 'package:http/http.dart' as http;

class TradicionesService extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  // Estado local
  List<Tradiciones>? _todasLasTradiciones;
  Tradiciones? _tradicionSeleccionada;
  String? _error;
  bool _isLoading = false;

  // Getters
  List<Tradiciones>? get todasLasTradiciones => _todasLasTradiciones;
  Tradiciones? get tradicionSeleccionada => _tradicionSeleccionada;
  String? get error => _error;
  bool get isLoading => _isLoading;

  // Métodos públicos para manejar el estado

  // Obtener todas las tradiciones
  Future<void> getAllTradiciones() async {
    await _executeWithLoading(() async {
      final response = await _apiClient.get('/fiesta_tradicion/activas');
      if (response.statusCode == 200) {
        final List<dynamic> tradicionesList = json.decode(response.body);
        _todasLasTradiciones = tradicionesList
            .map((tradicion) => Tradiciones.fromMap(tradicion))
            .toList();
      }
    }, onError: 'Error al obtener tradiciones');
  }

  // Obtener una tradición por ID
  Future<void> getTradicionById(int id) async {
    await _executeWithLoading(() async {
      final response = await _apiClient.get('/fiesta_tradicion/$id');
      if (response.statusCode == 200) {
        _tradicionSeleccionada =
            Tradiciones.fromMap(json.decode(response.body));
      }
    }, onError: 'Error al obtener la tradición');
  }

  // Buscar tradiciones por palabra clave
  Future<void> searchTradiciones(String keyword) async {
    await _executeWithLoading(() async {
      final response =
          await _apiClient.get('/fiesta_tradicion/buscar?keyword=$keyword');
      if (response.statusCode == 200) {
        final List<dynamic> tradicionesList = json.decode(response.body);
        _todasLasTradiciones = tradicionesList
            .map((tradicion) => Tradiciones.fromMap(tradicion))
            .toList();
      }
    }, onError: 'Error al buscar tradiciones');
  }

  // Limpiar errores
  void limpiarError() {
    _error = null;
    notifyListeners();
  }

  // Métodos privados para el manejo del estado

  // Ejecutar una función con manejo del estado de carga
  Future<void> _executeWithLoading(Future<void> Function() action,
      {required String onError}) async {
    _setLoading(true);
    try {
      await action();
      _error = null;
    } catch (e) {
      _error = '$onError: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Actualizar el estado de carga
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Método para subir imagen a Cloudinary
  Future<String?> uploadImage(File image) async {
    const String uploadUrl =
        'https://api.cloudinary.com/v1_1/vilaimagescloud/image/upload?upload_preset=villapreset';

    try {
      final request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      request.files.add(await http.MultipartFile.fromPath('file', image.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);
        debugPrint('Imagen subida correctamente: $responseBody');
        return jsonResponse['secure_url']; // URL de la imagen subida
      } else {
        debugPrint('Error al subir la imagen: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error durante la subida de la imagen: $e');
      return null;
    }
  }

// Método para obtener la imagen de una tradición desde Cloudinary
  Image getImageForTradicion(String? imagenUrl) {
    if (imagenUrl != null && imagenUrl.isNotEmpty) {
      // Si hay una URL válida proporcionada
      return Image.network(
        imagenUrl,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // En caso de error al cargar la imagen, mostrar un icono
          return const Icon(
            Icons.broken_image,
            size: 50,
            color: Colors.grey,
          );
        },
      );
    }

    // Si no hay URL proporcionada o está vacía, mostrar imagen de respaldo
    return const Image(
      image: AssetImage("assets/no-image.jpg"),
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
    );
  }
}
