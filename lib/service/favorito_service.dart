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
            favorito is Tradicion) {
          return favorito.idFiestaTradicion == idEntidad;
        }
        return false;
      },
    );
  }

  Future<void> getFavoritosByUsuario(int idUsuario) async {
    _favoritosDelUsuario = [];

    final endpoint = "/favorito/usuario/$idUsuario";
    try {
      final response = await _apiClient.get(endpoint);

      if (response.statusCode == 200) {
        
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        for (int i = 0; i < data.length; i++) {
          if (data[i].containsKey("idLugarInteres")) {
            _favoritosDelUsuario.add(LugarDeInteres.fromMap(data[i]));
          } else if (data[i].containsKey("platoId")) {
            _favoritosDelUsuario.add(Plato.fromMap(data[i]));
          } else if (data[i].containsKey("idFiestaTradicion")) {
            _favoritosDelUsuario.add(Tradicion.fromMap(data[i]));
          }
        }
        notifyListeners();
      } else {
        debugPrint("Error al obtener favoritos: ${response.statusCode}");
        _favoritosDelUsuario = [];
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error al obtener favoritos: $e");
      throw Exception(e);
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

  Future<bool> eliminarFavorito(int idEntidad, int idUsuario) async {
    final endpoint = "/favorito/eliminar?idEntidad=$idEntidad&idUsuario=$idUsuario";
    try {
      final response = await _apiClient.delete(endpoint);
      if (response.statusCode == 204) {
        debugPrint("Favorito eliminado correctamente.");
        _favoritosDelUsuario.removeWhere((f) => f.idFavorito == idEntidad);
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

    Object? favoritoExistente;

    for (final fav in _favoritosDelUsuario) {
      if (fav is LugarDeInteres && idEntidad == fav.idLugarInteres) {
        favoritoExistente = fav;
        break;
      } else if (fav is Plato && idEntidad == fav.platoId) {
        favoritoExistente = fav;
        break;
      } else if (fav is Tradicion && idEntidad == fav.idFiestaTradicion) {
        favoritoExistente = fav;
        break;
      }
    }

    if (favoritoExistente != null && favoritoExistente is LugarDeInteres) {
      await eliminarFavorito(favoritoExistente.idLugarInteres!, idUsuario);
    } else if (favoritoExistente != null && favoritoExistente is Plato) {
      await eliminarFavorito(favoritoExistente.platoId!, idUsuario);
    } else if (favoritoExistente != null && favoritoExistente is Tradicion) {
      await eliminarFavorito(favoritoExistente.idFiestaTradicion, idUsuario);
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
