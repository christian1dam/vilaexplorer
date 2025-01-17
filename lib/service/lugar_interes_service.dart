import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/models/lugarDeInteres/LugarDeInteres.dart';

class LugarDeInteresService with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  List<LugarDeInteres> _lugaresDeInteres = [];
  List<LugarDeInteres> get lugaresDeInteres => _lugaresDeInteres;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Obtiene todos los lugares de interés desde la API
  Future<void> fetchLugaresDeInteres() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiClient.get('/lugar_interes/todos');
      final List<dynamic> data = jsonDecode(response.body);

      _lugaresDeInteres = data
          .map((json) => LugarDeInteres.fromMap(json))
          .toList();
    } catch (error) {
      _errorMessage = 'Error al cargar los lugares de interés: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Obtiene todos los lugares de interés activos desde la API
  Future<void> fetchLugaresDeInteresActivos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiClient.get('/lugar_interes/activos');
      final List<dynamic> data = jsonDecode(response.body);

      _lugaresDeInteres = data
          .map((json) => LugarDeInteres.fromMap(json))
          .toList();
    } catch (error) {
      _errorMessage = 'Error al cargar los lugares de interés activos: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Obtiene un lugar de interés por su ID
  Future<LugarDeInteres?> fetchLugarDeInteresById(int id) async {
    try {
      final response = await _apiClient.get('/lugar_interes/detalle/$id');
      final Map<String, dynamic> data = jsonDecode(response.body);

      return LugarDeInteres.fromMap(data);
    } catch (error) {
      _errorMessage = 'Error al obtener el lugar de interés: $error';
      notifyListeners();
      return null;
    }
  }

  // Buscar monumentos por palabra clave
  Future<void> searchLugarDeInteres(String keyword) async {
    await _executeWithLoading(() async {
      final response = await _apiClient.get('/lugar_interes/buscar?keyword=$keyword');
      if (response.statusCode == 200) {
        final List<dynamic> lugaresDeInteresList = json.decode(response.body);
        _lugaresDeInteres = lugaresDeInteresList
            .map((lugarInteres) => LugarDeInteres.fromMap(lugarInteres))
            .toList();
      }
    }, onError: 'Error al buscar lugares de interés');
  }

    // Ejecutar una función con manejo del estado de carga
  Future<void> _executeWithLoading(Future<void> Function() action,
      {required String onError}) async {
    _setLoading(true);
    try {
      await action();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = '$onError: $e';
    } finally {
      _setLoading(false);
    }
  }


  // Actualizar el estado de carga
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Limpia la lista de lugares de interés
  void clearLugaresDeInteres() {
    _lugaresDeInteres = [];
    notifyListeners();
  }

   // Método para obtener la imagen de un monumento desde Cloudinary
  Image getImageForMonumento(String? imagenUrl) {
    if (imagenUrl != null && imagenUrl.isNotEmpty) {
      return Image.network(
        imagenUrl,
        width: double.infinity,
        height: 200.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.broken_image,
            size: 50.r,
            color: Colors.grey,
          );
        },
      );
    }

    return Image(
      image: AssetImage("assets/no-image.jpg"),
      width: double.infinity,
      height: 200.h,
      fit: BoxFit.cover,
    );
  }
}
