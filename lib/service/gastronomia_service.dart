import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/models/gastronomia/post_plato.dart';
import 'package:vilaexplorer/user_preferences/user_preferences.dart';
import '../models/gastronomia/plato.dart';
import 'package:http/http.dart' as http;

class GastronomiaService extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  // Estado local
  List<Plato>? _platos;
  Plato? _platoSeleccionado;
  String? _error;
  bool _isLoading = false;

  // Getters
  List<Plato>? get platos => _platos;
  Plato? get platoSeleccionado => _platoSeleccionado;
  String? get error => _error;
  bool get isLoading => _isLoading;

  // Método para obtener todos los platos con manejo de estado
  Future<void> fetchAllPlatos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiClient.get('/plato/aprobados');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        _platos = data.map((json) => Plato.fromMap(json)).toList();
      } else {
        _error = 'Error: ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (e) {
      _error = 'Error al obtener los platos: $e';
      debugPrint('Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserRecipes() async {
    final idUsuario = await UserPreferences().id;

    try {
      final response = await _apiClient.get('/plato/misRecetas?autorID=$idUsuario');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _platos = data.map((json) => Plato.fromMap(json)).toList();
      } 
    } catch (e) {
      throw Exception(e);
    } finally {
      notifyListeners();
    }
  }

  // Método para obtener un plato por ID con manejo de estado
  Future<void> fetchPlatoById(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiClient.get('/plato/detalle/$id');
      _platoSeleccionado = Plato.fromMap(json.decode(response.body));
    } catch (e) {
      _error = 'Error al obtener el plato: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para crear un nuevo plato con manejo de estado
  Future<void> createPlato(
    String nombrePlato,
    int idTipo,
    String ingredientes,
    String descripcion,
    String receta,
    String imagePath, // Ruta local de la imagen
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final idUsuario = await UserPreferences().id;

    try {
      // Subir imagen a Cloudinary
      final imageUrl = await uploadImage(File(imagePath));
      if (imageUrl == null) {
        throw 'No se pudo subir la imagen a Cloudinary.';
      }

      // Crear objeto PostPlato con la URL de Cloudinary
      PostPlato postPlato = PostPlato(
        nombre: nombrePlato,
        descripcion: descripcion,
        ingredientes: ingredientes,
        receta: receta,
        imagen: imageUrl, // URL de la imagen subida
        estado: false,
        puntuacionMediaPlato: 0.0,
        eliminado: false,
      );

      // Hacer la petición POST para crear el plato
      final response = await _apiClient.postAuth(
        '/plato/crearFlutter?autorID=$idUsuario&tipoPlatoID=$idTipo',
        body: postPlato.toMap(),
      );

      debugPrint("RESPONSE ${response.statusCode}");
    } catch (e) {
      _error = 'Error al crear el plato: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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

  // Método para manejar la selección de un plato
  void selectPlato(Plato plato) {
    _platoSeleccionado = plato;
    notifyListeners();
  }

  // Método para limpiar la selección de un plato
  void clearSelection() {
    _platoSeleccionado = null;
    notifyListeners();
  }

  // Método para obtener la imagen de un plato
  Future<Widget> getImageForPlato(
      String? imagenBase64, String? imagenUrl) async {
    if (imagenBase64 != null && imagenBase64.isNotEmpty) {
      // Si la imagen está en formato base64
      try {
        return Image.memory(
          base64Decode(imagenBase64),
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.broken_image,
              size: 50,
              color: Colors.grey,
            );
          },
        );
      } catch (e) {
        debugPrint("Error al decodificar la imagen en base64: $e");
        return const Icon(
          Icons.broken_image,
          size: 50,
          color: Colors.grey,
        );
      }
    } else if (imagenUrl != null && imagenUrl.isNotEmpty) {
      // Si la imagen está en formato URL
      try {
        final response = await http.get(Uri.parse(imagenUrl));
        if (response.statusCode == 200) {
          return Image.network(
            imagenUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.broken_image,
                size: 50,
                color: Colors.grey,
              );
            },
          );
        } else {
          debugPrint(
              "Error al obtener la imagen desde la URL: ${response.statusCode}");
          return const Icon(
            Icons.broken_image,
            size: 50,
            color: Colors.grey,
          );
        }
      } catch (e) {
        debugPrint("Error al obtener la imagen desde la URL: $e");
        return const Icon(
          Icons.broken_image,
          size: 50,
          color: Colors.grey,
        );
      }
    }

    // Si no hay imagen disponible
    return const Icon(
      Icons.image_not_supported,
      size: 50,
      color: Colors.grey,
    );
  }
}
