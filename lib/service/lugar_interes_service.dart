import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/helpers/debouncer.dart';
import 'package:vilaexplorer/models/lugarDeInteres/LugarDeInteres.dart';

class LugarDeInteresService with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  final StreamController<List<LugarDeInteres>> _sugestionsStreamController = StreamController.broadcast();
  Stream<List<LugarDeInteres>> get suggestionStream => _sugestionsStreamController.stream;
    final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  List<LugarDeInteres> _lugaresDeInteres = [];
  List<LugarDeInteres> get lugaresDeInteres => _lugaresDeInteres;

  LugarDeInteres? _lugarDeInteresActual;
  LugarDeInteres get lugarDeInteres => _lugarDeInteresActual!;

  set setLugarDeInteres(LugarDeInteres lugar) {
    _lugarDeInteresActual = lugar;
    notifyListeners();
  }

  Future<void> fetchLugaresDeInteresActivos() async {
    try {
      final response = await _apiClient.get('/lugar_interes/activos');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        _lugaresDeInteres =data.map((json) => LugarDeInteres.fromMap(json)).toList();
        debugPrint("SE HAN OBTENIDO LOS LUGAREES DE INTERES $_lugaresDeInteres");
        notifyListeners();
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> fetchLugarDeInteresById(int id) async {
    try {
      final response = await _apiClient.get('/lugar_interes/detalle/$id');
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        debugPrint("SE HA OBTENIDO EL LUGAR DE INTERES DE LA BD");
        _lugarDeInteresActual = LugarDeInteres.fromMap(data);
        notifyListeners();
      }
    } catch (e) {
      throw Exception("Error al obtener el lugar de interés: $e");
    }
  }

  Future<List<LugarDeInteres>> searchLugarDeInteres(String query) async {
    try {
      final response = await _apiClient.get('/lugar_interes/buscar?keyword=$query');
        debugPrint("status RESPONSE SEARCH: ${response.statusCode.toString()}");
        if(response.statusCode == 204) return [];
        final List<dynamic> lugaresDeInteresList = json.decode(utf8.decode(response.bodyBytes));
        return lugaresDeInteresList.map((lugarInteres) => LugarDeInteres.fromMap(lugarInteres)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      debugPrint('Tenemos valor a buscar: $value');
      final results = await searchLugarDeInteres(value);
      _sugestionsStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}
