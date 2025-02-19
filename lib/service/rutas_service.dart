import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/models/ruta.dart';
import 'package:vilaexplorer/user_preferences/user_preferences.dart';

class RutasService extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  List<Ruta> rutasPredefinidas = [];
  List<Ruta> rutasDelUsuario = [];

  Future<void> fetchMisRutas() async {
    int autorId = await UserPreferences().id;

    try {
      final String url = "/ruta/mis-rutas/$autorId";
      final response = await _apiClient.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> responseData =
            jsonDecode(utf8.decode(response.bodyBytes));

        rutasPredefinidas = responseData
            .where((ruta) => ruta["predefinida"] == true)
            .map<Ruta>((ruta) => Ruta.fromMap(ruta))
            .toList();

        rutasDelUsuario = responseData
            .where((ruta) => ruta["predefinida"] == false)
            .map<Ruta>((ruta) => Ruta.fromMap(ruta))
            .toList();

        notifyListeners();
      } else {
        throw Exception("Error al obtener las rutas: ${response.statusCode}");
      }
    } catch (e) {
      print("Error en fetchMisRutas: $e");
    }
  }

  Future<bool> createRoute({
    required String titulo,
    required List<List<double>> coordenadas,
  }) async {
    int autorId = await UserPreferences().id;

    try {
      final String url =
          "/ruta/createRoute?idAutor=$autorId&titulo=${Uri.encodeComponent("Mi ubicación -> $titulo")}&predefinida=false";

      final Map<String, dynamic> body = {
        "coordinates": coordenadas,
      };
      
      final response = await _apiClient.postAuth(url, body: body);
      if (response.statusCode == 200) {
        print("Ruta creada exitosamente");
        return true;
      } else {
        print(
            "Error al crear la ruta: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error en createRoute: $e");
      return false;
    }
  }
}
