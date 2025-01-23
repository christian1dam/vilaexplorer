import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/models/lugarDeInteres/LugarDeInteres.dart';

class LugarDeInteresService with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  List<LugarDeInteres> _lugaresDeInteres = [];
  List<LugarDeInteres> get lugaresDeInteres => _lugaresDeInteres;

  LugarDeInteres? _lugarDeInteresActual;
  LugarDeInteres get lugarDeInteres => _lugarDeInteresActual!;

  set setLugarDeInteres(LugarDeInteres lugar) {
    _lugarDeInteresActual = lugar;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      notifyListeners();
    });
  }

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
      _lugaresDeInteres =
          data.map((json) => LugarDeInteres.fromMap(json)).toList();
    } catch (error) {
      _errorMessage = 'Error al cargar los luzgares de interés activos: $error';
    } finally {
      _isLoading = false;
      debugPrint("SE HA ACTUALIZADO LA PUNTUACIÓN");
      notifyListeners();
    }
  }

  Future<void> fetchLugarDeInteresById(int id) async {
    try {
      final response = await _apiClient.get('/lugar_interes/detalle/$id');
      final Map<String, dynamic> data =
          jsonDecode(utf8.decode(response.bodyBytes));

      debugPrint("SE HA OBTENIDO EL LUGAR DE INTERES DE LA BD");
      _lugarDeInteresActual = LugarDeInteres.fromMap(data);
    } catch (e) {
      throw Exception("Error al obtener el lugar de interés: $e");
    }
  }

  Future<void> searchLugarDeInteres(String keyword) async {
    await _executeWithLoading(() async {
      final response =
          await _apiClient.get('/lugar_interes/buscar?keyword=$keyword');
      if (response.statusCode == 200) {
        final List<dynamic> lugaresDeInteresList =
            json.decode(utf8.decode(response.bodyBytes));
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

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
