import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/models/Puntuacion.dart';
import 'package:vilaexplorer/models/lugarDeInteres/LugarDeInteres.dart';
import 'package:vilaexplorer/models/usuario/usuario.dart';

class LugarDeInteresService with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  List<LugarDeInteres> _lugaresDeInteres = [];
  List<LugarDeInteres> get lugaresDeInteres => _lugaresDeInteres;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchLugaresDeInteresActivos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiClient.get('/lugar_interes/activos');
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      _lugaresDeInteres = data.map((json) => LugarDeInteres.fromMap(json)).toList();
    } catch (error) {
      _errorMessage = 'Error al cargar los luzgares de interés activos: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<LugarDeInteres?> fetchLugarDeInteresById(int id) async {
    try {
      final response = await _apiClient.get('/lugar_interes/detalle/$id');
      final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

      return LugarDeInteres.fromMap(data);
    } catch (error) {
      _errorMessage = 'Error al obtener el lugar de interés: $error';
      notifyListeners();
      return null;
    }
  }

  Future<void> searchLugarDeInteres(String keyword) async {
    await _executeWithLoading(() async {
      final response =
          await _apiClient.get('/lugar_interes/buscar?keyword=$keyword');
      if (response.statusCode == 200) {
        final List<dynamic> lugaresDeInteresList = json.decode(utf8.decode(response.bodyBytes));
        _lugaresDeInteres = lugaresDeInteresList
            .map((lugarInteres) => LugarDeInteres.fromMap(lugarInteres))
            .toList();
      }
    }, onError: 'Error al buscar lugares de interés');
  }

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

  /// Verifica si el usuario ya ha puntuado una entidad
  Future<bool> hasPuntuado({
    required int idUsuario,
    required int idEntidad,
    required String tipoEntidad,
  }) async {
    final endpoint =
        "/puntuacion/usuario/$idUsuario/entidad/$tipoEntidad/$idEntidad";

    try {
      final response = await _apiClient.get(endpoint);
      return response.statusCode == 200 && jsonDecode(response.body).isNotEmpty;
    } catch (e) {
      print("Error al verificar puntuación: $e");
      return false;
    }
  }

  /// Crea una nueva puntuación
  Future<void> crearPuntuacion(Puntuacion puntuacion) async {
    final endpoint = "/puntuacion/crear";

    print("Entrando a crearPuntuacion");
    print("Endpoint: $endpoint");
    print("Puntuación enviada: ${puntuacion.toMap()}");

    try {
      print(
          "Enviando puntuación: ${puntuacion.toMap()}"); // Imprime los datos enviados

      final response = await _apiClient.postAuth(
        endpoint,
        body: puntuacion.toMap(),
      );

      if (response.statusCode == 201) {
        print("Puntuación creada correctamente.");
      } else {
        print("Error al crear la puntuación: ${response.statusCode}");
        print("Error body: ${response.body}");
      }
    } catch (e) {
      print("Error al crear puntuación: $e");
      print("${e.hashCode} + ${e.toString()} + ${e.runtimeType}");
    }
  }

  /// Actualiza una puntuación existente
  Future<void> actualizarPuntuacion({
    required int idUsuario,
    required int idEntidad,
    required String tipoEntidad,
    required int nuevaPuntuacion,
  }) async {
    final endpoint = "/puntuacion/actualizar"
        "?idUsuario=$idUsuario"
        "&idEntidad=$idEntidad"
        "&tipoEntidad=$tipoEntidad"
        "&nuevaPuntuacion=$nuevaPuntuacion";

    try {
      final response = await _apiClient.put(endpoint);

      if (response.statusCode == 200) {
        print("Puntuación actualizada correctamente.");
      } else {
        print("Error al actualizar la puntuación: ${response.statusCode}");
      }
    } catch (e) {
      print("Error al actualizar puntuación: $e");
    }
  }

  /// Lógica principal para crear o actualizar una puntuación
  Future<void> gestionarPuntuacion({
    required int idUsuario,
    required int idEntidad,
    required String tipoEntidad,
    required int puntuacion,
  }) async {
    final yaPuntuado = await hasPuntuado(
      idUsuario: idUsuario,
      idEntidad: idEntidad,
      tipoEntidad: tipoEntidad,
    );

    if (yaPuntuado) {
      await actualizarPuntuacion(
        idUsuario: idUsuario,
        idEntidad: idEntidad,
        tipoEntidad: tipoEntidad,
        nuevaPuntuacion: puntuacion,
      );
    } else {
      final puntuacionModel = Puntuacion(
          idEntidad: idEntidad,
          puntuacion: puntuacion,
          usuario: Usuario(
            idUsuario: idUsuario,
          ),
          tipoEntidad: tipoEntidad);
      await crearPuntuacion(puntuacionModel);
    }

    await fetchLugaresDeInteresActivos();
  }
}
