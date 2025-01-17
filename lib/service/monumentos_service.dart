import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/models/monumentos/monumento.dart';
import 'package:http/http.dart' as http;

class MonumentosService extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  // Estado local
  List<Monumentos>? _todosLosMonumentos;
  Monumentos? _monumentoSeleccionado;
  String? _error;
  bool _isLoading = false;

  // Getters
  List<Monumentos>? get todosLosMonumentos => _todosLosMonumentos;
  Monumentos? get monumentoSeleccionado => _monumentoSeleccionado;
  String? get error => _error;
  bool get isLoading => _isLoading;

  // Obtener todos los monumentos
  Future<void> getAllMonumentos() async {
    await _executeWithLoading(() async {
      final response = await _apiClient.get('/lugar_interes/activos');
      
      debugPrint('Response: ${response.body}'); // Verifica la respuesta para depuración

      if (response.statusCode == 200) {
        final List<dynamic> monumentosList = json.decode(response.body);
        _todosLosMonumentos = monumentosList
            .map((monumento) => Monumentos.fromMap(monumento))
            .toList();
      } else {
        _error = 'Error al obtener los monumentos: ${response.statusCode}';
      }
    }, onError: 'Error al obtener los monumentos');
  }

  // Obtener un monumento por ID
  Future<void> getMonumentoById(int id) async {
    await _executeWithLoading(() async {
      final response = await _apiClient.get('/lugar_interes/$id');
      if (response.statusCode == 200) {
        _monumentoSeleccionado =
            Monumentos.fromMap(json.decode(response.body));
      }
    }, onError: 'Error al obtener el monumento');
  }

  // Buscar monumentos por palabra clave
  Future<void> searchMonumentos(String keyword) async {
    await _executeWithLoading(() async {
      final response = await _apiClient.get('/lugar_interes/buscar?keyword=$keyword');
      if (response.statusCode == 200) {
        final List<dynamic> monumentosList = json.decode(response.body);
        _todosLosMonumentos = monumentosList
            .map((monumento) => Monumentos.fromMap(monumento))
            .toList();
      }
    }, onError: 'Error al buscar monumentos');
  }

  // Limpiar errores
  void limpiarError() {
    _error = null;
    notifyListeners();
  }

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

  // Método para obtener la imagen de un monumento desde Cloudinary
  Image getImageForMonumento(String? imagenUrl) {
    if (imagenUrl != null && imagenUrl.isNotEmpty) {
      return Image.network(
        imagenUrl,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.broken_image,
            size: 50,
            color: Colors.grey,
          );
        },
      );
    }

    return const Image(
      image: AssetImage("assets/no-image.jpg"),
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
    );
  }
}
