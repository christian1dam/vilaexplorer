import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/models/tradiciones/tradiciones.dart';

class TradicionesService extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  List<Tradicion>? _todasLasTradiciones;
  Tradicion? _tradicionSeleccionada;
  String? _error;
  bool _isLoading = false;

  // Getters
  List<Tradicion>? get todasLasTradiciones => _todasLasTradiciones;
  Tradicion? get tradicionSeleccionada => _tradicionSeleccionada;
  String? get error => _error;
  bool get isLoading => _isLoading;

  Future<void> getAllTradiciones() async {
    try {
      final response = await _apiClient.get('/fiesta_tradicion/activas');
      if (response.statusCode == 200) {
        final List<dynamic> tradicionesList = json.decode(utf8.decode(response.bodyBytes));
        _todasLasTradiciones = tradicionesList
            .map((tradicion) => Tradicion.fromMap(tradicion))
            .toList();
      }
      debugPrint("SE HAN OBTENIDO TODAS LAS TRADICIONES");
      notifyListeners();
    } catch (e) {
      debugPrint("EXCEPCION EN GET_ALL_TRADICIONES $e");
      throw Exception(e);
    }
  }

  // Obtener una tradición por ID
  Future<void> getTradicionById(int id) async {
    await _executeWithLoading(() async {
      final response = await _apiClient.get('/fiesta_tradicion/$id');
      if (response.statusCode == 200) {
        _tradicionSeleccionada =
            Tradicion.fromMap(json.decode(utf8.decode(response.bodyBytes)));
      }
    }, onError: 'Error al obtener la tradición');
  }

  // Buscar tradiciones por palabra clave
  Future<void> searchTradiciones(String keyword) async {
    await _executeWithLoading(() async {
      final response =
          await _apiClient.get('/fiesta_tradicion/buscar?keyword=$keyword');
      if (response.statusCode == 200) {
        final List<dynamic> tradicionesList =
            json.decode(utf8.decode(response.bodyBytes));
        _todasLasTradiciones = tradicionesList
            .map((tradicion) => Tradicion.fromMap(tradicion))
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
