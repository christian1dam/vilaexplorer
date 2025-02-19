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
        final List<dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));

        rutasPredefinidas = responseData.where((ruta) => ruta["predefinida"] == true).map<Ruta>((ruta) => Ruta.fromMap(ruta)).toList();

        rutasDelUsuario = responseData.where((ruta) => ruta["predefinida"] == false).map<Ruta>((ruta) => Ruta.fromMap(ruta)).toList();

        notifyListeners();
      } else {
        throw Exception("Error al obtener las rutas: ${response.statusCode}");
      }
    } catch (e) {
      print("Error en fetchMisRutas: $e");
    }
  }
}
