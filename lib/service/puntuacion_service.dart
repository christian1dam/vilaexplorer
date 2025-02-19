import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/models/gastronomia/plato.dart';
import 'package:vilaexplorer/models/lugarDeInteres/LugarDeInteres.dart';
import 'package:vilaexplorer/models/puntuacion.dart';
import 'package:vilaexplorer/models/tradiciones/tradiciones.dart';
import 'package:vilaexplorer/models/usuario/usuario.dart';
import 'package:vilaexplorer/service/gastronomia_service.dart';

import 'package:vilaexplorer/service/lugar_interes_service.dart';
import 'package:vilaexplorer/service/tradiciones_service.dart';

class PuntuacionService extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  final puntuacionesPlatos = [];
  final puntuacionesLDI = [];
  final puntuacionesTradiciones = [];

  Future<Puntuacion?> usuarioHaPuntuadoEsteObjeto({
    required int idUsuario,
    required int idEntidad,
    required String tipoEntidad,
  }) async {
    final endpoint =
        "/puntuacion/existePuntuacion?idUsuario=$idUsuario&idEntidad=$idEntidad&tipoEntidad=$tipoEntidad";

    try {
      final response = await _apiClient.get(endpoint);

      if (response.statusCode == 200) {
        return Puntuacion.fromMap(jsonDecode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == 204) {
        return null;
      } else {
        throw Exception("Error en la respuesta del servidor: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al verificar puntuación: $e");
    }
  }

  Future<dynamic> crearPuntuacion(Puntuacion puntuacion) async {
    final endpoint = "/puntuacion/crear";

    debugPrint("Entrando a crearPuntuacion");
    debugPrint("Endpoint: $endpoint");
    debugPrint("Puntuación enviada: ${puntuacion.toMap()}");

    try {
      debugPrint("Enviando puntuación: ${puntuacion.toMap()}");

      final response = await _apiClient.postAuth(
        endpoint,
        body: puntuacion.toMap(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));

        if (data.containsKey('idLugarInteres')) {
          debugPrint("Puntuación actualizada correctamente.");
          return LugarDeInteres.fromMap(data);
        } else if (data.containsKey('platoId')) {
          debugPrint("Puntuación actualizada correctamente.");
          return Plato.fromMap(data);
        } else if (data.containsKey('idFiestaTradicion')) {
          debugPrint("Puntuación actualizada correctamente.");
          return Tradicion.fromMap(data);
        }

        debugPrint("Puntuación creada correctamente.");
      } else {
        throw Exception(
            "Error al crear la puntuación: ${response.statusCode}\nError body: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error al crear puntuación: $e");
      throw Exception("${e.hashCode} + ${e.toString()} + ${e.runtimeType}");
    }
  }

  Future<dynamic> actualizarPuntuacion({
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
        Map<String, dynamic> data =
            json.decode(utf8.decode(response.bodyBytes));

        if (data.containsKey('idLugarInteres')) {
          debugPrint("Puntuación actualizada correctamente.");
          return LugarDeInteres.fromMap(data);
        } else if (data.containsKey('platoId')) {
          debugPrint("Puntuación actualizada correctamente.");
          return Plato.fromMap(data);
        } else if (data.containsKey('idFiestaTradicion')) {
          debugPrint("Puntuación actualizada correctamente.");
          return Tradicion.fromMap(data);
        }
      } else {
        throw Exception(
            "Error al crear la puntuación: ${response.statusCode}\nError body: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error al actualizar puntuación: $e");
    }
  }

  Future<void> gestionarPuntuacion({
    required int idUsuario,
    required int idEntidad,
    required String tipoEntidad,
    required int puntuacion,
    required BuildContext context,
  }) async {
    Puntuacion? puntuacionDB = await usuarioHaPuntuadoEsteObjeto(
      idUsuario: idUsuario,
      idEntidad: idEntidad,
      tipoEntidad: tipoEntidad,
    );

    dynamic resultado;

    if (puntuacionDB != null) {
      resultado = await actualizarPuntuacion(
        idUsuario: idUsuario,
        idEntidad: idEntidad,
        tipoEntidad: tipoEntidad,
        nuevaPuntuacion: puntuacion,
      );
    } else {
      Puntuacion puntuacionModel = Puntuacion(
        idEntidad: idEntidad,
        puntuacion: puntuacion,
        usuario: Usuario(idUsuario: idUsuario),
        tipoEntidad: tipoEntidad,
      );

      resultado = await crearPuntuacion(puntuacionModel);
    }

    if (resultado is LugarDeInteres && context.mounted) {
      Provider.of<LugarDeInteresService>(context, listen: false)
          .setLugarDeInteres = resultado;
    } else if (resultado is Plato && context.mounted) {
      Provider.of<GastronomiaService>(context, listen: false)
          .platoSeleccionado = resultado;
    } else if (resultado is Tradicion && context.mounted) {
      Provider.of<TradicionesService>(context, listen: false)
          .tradicionSeleccionada = resultado;
    } else {
      debugPrint("Error: El resultado devuelto no es un tipo válido.");
    }
  }
}
