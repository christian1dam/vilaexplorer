import 'dart:convert';
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
    bool result = false;

    for (final fav in _favoritosDelUsuario) {
      if (fav is LugarDeInteres && idEntidad == fav.idLugarInteres) {
        result = true;
        break;
      } else if (fav is Plato && idEntidad == fav.platoId) {
        result = true;
        break;
      } else if (fav is Tradicion && idEntidad == fav.idFiestaTradicion) {
        result = true;
        break;
      }
    }

    return result;
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
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        if (data.containsKey("idLugarInteres")) {
          _favoritosDelUsuario.add(LugarDeInteres.fromMap(data));
        } else if (data.containsKey("platoId")) {
          _favoritosDelUsuario.add(Plato.fromMap(data));
        } else if (data.containsKey("idFiestaTradicion")) {
          _favoritosDelUsuario.add(Tradicion.fromMap(data));
        }

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
    final endpoint =
        "/favorito/eliminar?idEntidad=$idEntidad&idUsuario=$idUsuario";
    try {
      final response = await _apiClient.delete(endpoint);
      if (response.statusCode == 204) {
        debugPrint("Favorito eliminado correctamente.");
        for (int i = 0; i < _favoritosDelUsuario.length; i++) {
          final fav = _favoritosDelUsuario[i];
          if (fav is LugarDeInteres && idEntidad == fav.idLugarInteres) {
            _favoritosDelUsuario.removeAt(i);
            break;
          } else if (fav is Plato && idEntidad == fav.platoId) {
            _favoritosDelUsuario.removeAt(i);
            break;
          } else if (fav is Tradicion && idEntidad == fav.idFiestaTradicion) {
            _favoritosDelUsuario.removeAt(i);
            break;
          }
        }
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
      await eliminarFavorito(favoritoExistente.platoId, idUsuario);
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
  }
}
