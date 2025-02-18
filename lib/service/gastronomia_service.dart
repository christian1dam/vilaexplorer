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

  List<Plato> _platos = [];
  List<Plato> _platosUsuario = [];
  Plato? _platoSeleccionado;

  List<Plato> get platos => _platos;
  List<Plato> get platosUsuario => _platosUsuario;
  Plato? get platoSeleccionado => _platoSeleccionado;

  Future<void> fetchAllPlatos() async {
    try {
      final response = await _apiClient.get('/plato/aprobados');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      if (response.statusCode == 200) {
        _platos = [];
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        for (int i = 0; i < data.length; i++) {
          _platos.add(Plato.fromMap(data[i]));
        }
        notifyListeners();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> fetchUserRecipes() async {
    final idUsuario = await UserPreferences().id;

    try {
      final response = await _apiClient.get('/plato/misRecetas?autorID=$idUsuario');
      if (response.statusCode == 200) {
        _platosUsuario = [];
        final data = json.decode(utf8.decode(response.bodyBytes));
         for (int i = 0; i < data.length; i++) {
          _platosUsuario.add(Plato.fromMap(data[i]));
        }
      }
    } catch (e) {
      throw Exception(e);
    }
    notifyListeners();
  }

  Future<void> fetchPlatoById(int id) async {

    try {
      final response = await _apiClient.get('/plato/detalle/$id');
      if(response.statusCode == 200){
      _platoSeleccionado = Plato.fromMap(json.decode(utf8.decode(response.bodyBytes)));
      }
    } catch (e) {
      throw Exception(e);
    }

    notifyListeners();
  }

  Future<void> createPlato(
    String nombrePlato,
    int idTipo,
    String ingredientes,
    String descripcion,
    String receta,
    String imagePath,
  ) async {
    final idUsuario = await UserPreferences().id;

    try {
      final imageUrl = await uploadImage(File(imagePath));
      if (imageUrl == null) {
        throw Exception('No se pudo subir la imagen a Cloudinary.');
      }

      PostPlato postPlato = PostPlato(
        nombre: nombrePlato,
        descripcion: descripcion,
        ingredientes: ingredientes,
        receta: receta,
        imagen: imageUrl,
        estado: false,
        puntuacionMediaPlato: 0.0,
        eliminado: false,
      );

      final response = await _apiClient.postAuth(
        '/plato/crearFlutter?autorID=$idUsuario&tipoPlatoID=$idTipo',
        body: postPlato.toMap(),
      );

      debugPrint("RESPONSE ${response.statusCode}");
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data is Plato) {
          _platos.add(data);
        }
      }
    } catch (e) {
      throw Exception('Error al crear el plato: $e');
    }
    notifyListeners();
  }

  Future<String?> uploadImage(File image) async {
    const String uploadUrl = 'https://api.cloudinary.com/v1_1/vilaimagescloud/image/upload?upload_preset=villapreset';

    try {
      final request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      request.files.add(await http.MultipartFile.fromPath('file', image.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);
        debugPrint('Imagen subida correctamente: $responseBody');
        return jsonResponse['secure_url'];
      } else {
        debugPrint('Error al subir la imagen: ${response.statusCode}');
        throw Exception("${response.statusCode}");
      }
    } catch (e) {
      debugPrint('Error durante la subida de la imagen: $e');
      throw Exception(e);
    }
  }

  void selectPlato(Plato plato) {
    _platoSeleccionado = plato;
    notifyListeners();
  }

  void clearSelection() {
    _platoSeleccionado = null;
    notifyListeners();
  }
}
