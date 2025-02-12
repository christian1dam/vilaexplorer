import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/models/favorito.dart';
import 'package:vilaexplorer/models/gastronomia/plato.dart';
import 'package:vilaexplorer/models/lugarDeInteres/LugarDeInteres.dart';
import 'package:vilaexplorer/models/tipo_entidad.dart';
import 'package:vilaexplorer/models/tradiciones/tradiciones.dart';
import 'package:vilaexplorer/models/usuario/usuario.dart';

class FavoritoService extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  List<dynamic> _favoritosDelUsuario = [];

  List<dynamic> get favoritosDelUsuario => _favoritosDelUsuario;

  bool esFavorito(int idEntidad, TipoEntidad tipoEntidad) {
    return _favoritosDelUsuario.any(
      (favorito) {
        
        if (tipoEntidad == TipoEntidad.LUGAR_INTERES &&
            favorito is LugarDeInteres) {
          return favorito.idLugarInteres == idEntidad;
        } else if (tipoEntidad == TipoEntidad.PLATO && favorito is Plato) {
          return favorito.platoId == idEntidad;
        } else if (tipoEntidad == TipoEntidad.FIESTA_TRADICION &&
            favorito is Tradiciones) {
          return favorito.idFiestaTradicion == idEntidad;
        }
        return false;
      },
    );
  }

  Future<void> getFavoritosByUsuario(int idUsuario) async {
    final endpoint = "/favorito/usuario/$idUsuario";
    try {
      final response = await _apiClient.get(endpoint);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        _favoritosDelUsuario = data
            .map((json) {
              if (json.containsKey("idLugarInteres")) {
                return LugarDeInteres.fromMap(json);
              } else if (json.containsKey("platoId")) {
                return Plato.fromMap(json);
              } else if (json.containsKey("idFiestaTradicion")) {
                return Tradiciones.fromMap(json);
              } else {
                debugPrint(
                    "No se pudo determinar el tipo de entidad para el JSON: $json");
                return null;
              }
            })
            .where((favorito) => favorito != null)
            .toList();

        notifyListeners();
      } else {
        debugPrint("Error al obtener favoritos: ${response.statusCode}");
        _favoritosDelUsuario = [];
      }
    } catch (e) {
      debugPrint("Error al obtener favoritos: $e");
      _favoritosDelUsuario = [];
    }
  }

  Future<bool> crearFavorito(Favorito favorito) async {
    final endpoint = "/favorito/crear";
    try {
      final response = await _apiClient.postAuth(
        endpoint,
        body: favorito.toMap(),
      );

      if (response.statusCode == 200) {
        debugPrint("Favorito creado correctamente.");
        notifyListeners();
        return true;
      } else {
        debugPrint("Error al crear favorito: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("Error al crear favorito: $e");
      return false;
    }
  }

  Future<bool> eliminarFavorito(int idFavorito) async {
    final endpoint = "/favorito/eliminar/$idFavorito";
    try {
      final response = await _apiClient.delete(endpoint);
      if (response.statusCode == 204) {
        debugPrint("Favorito eliminado correctamente.");
        _favoritosDelUsuario.removeWhere((f) => f.idFavorito == idFavorito);
        notifyListeners();
        return true;
      } else if (response.statusCode == 404) {
        debugPrint("Favorito no encontrado: ${response.statusCode}");
        return false;
      } else {
        debugPrint("Error al eliminar favorito: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      debugPrint("Error al eliminar favorito: $e");
      return false;
    }
  }

  Future<void> gestionarFavorito({
    required int idUsuario,
    required int idEntidad,
    required String tipoEntidad,
  }) async {
    await getFavoritosByUsuario(idUsuario);

    final favoritoExistente = _favoritosDelUsuario.firstWhereOrNull(
      (f) => f.idEntidad == idEntidad && f.tipoEntidad == tipoEntidad,
    );

    if (favoritoExistente != null) {
      await eliminarFavorito(favoritoExistente.idFavorito!);
    } else {
      final nuevoFavorito = Favorito(
        idEntidad: idEntidad,
        tipoEntidad: tipoEntidad,
        usuario: Usuario(idUsuario: idUsuario),
      );

      await crearFavorito(nuevoFavorito);
    }

    await getFavoritosByUsuario(idUsuario);
  }
}
