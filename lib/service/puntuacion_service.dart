import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/api/api_client.dart';
import 'package:vilaexplorer/models/lugarDeInteres/LugarDeInteres.dart';
import 'package:vilaexplorer/models/puntuacion.dart';
import 'package:vilaexplorer/models/usuario/usuario.dart';

import 'package:vilaexplorer/service/lugar_interes_service.dart';

class PuntuacionService extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  Future<bool> hasPuntuado({
    required int idUsuario,
    required int idEntidad,
    required String tipoEntidad,
  }) async {
    final endpoint = "/puntuacion/usuario/$idUsuario/entidad/$tipoEntidad/$idEntidad";

    try {
      final response = await _apiClient.get(endpoint);
      return response.statusCode == 200 && jsonDecode(response.body).isNotEmpty;
    } catch (e) {
      debugPrint("Error al verificar puntuación: $e");
      return false;
    }
  }

  Future<LugarDeInteres> crearPuntuacion(Puntuacion puntuacion) async {
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
        debugPrint("Puntuación creada correctamente.");
        return LugarDeInteres.fromMap(
            json.decode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception(
            "Error al crear la puntuación: ${response.statusCode}\nError body: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error al crear puntuación: $e");

      throw Exception("${e.hashCode} + ${e.toString()} + ${e.runtimeType}");
    }
  }

  Future<LugarDeInteres> actualizarPuntuacion({
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
        debugPrint("Puntuación actualizada correctamente.");
        return LugarDeInteres.fromMap(
            json.decode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception("Error al crear la puntuación: ${response.statusCode}\nError body: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error al actualizar puntuación: $e");
    }
  }

  Future<void> gestionarPuntuacion(
      {required int idUsuario,
      required int idEntidad,
      required String tipoEntidad,
      required int puntuacion,
      required BuildContext context}) async {
    final yaPuntuado = await hasPuntuado(
      idUsuario: idUsuario,
      idEntidad: idEntidad,
      tipoEntidad: tipoEntidad,
    );

    if (yaPuntuado) {
      LugarDeInteres lugarDeInteres = await actualizarPuntuacion(
        idUsuario: idUsuario,
        idEntidad: idEntidad,
        tipoEntidad: tipoEntidad,
        nuevaPuntuacion: puntuacion,
      );

      if (context.mounted) {
        Provider.of<LugarDeInteresService>(context, listen: false).setLugarDeInteres = lugarDeInteres;
      }
      
    } else {
      final puntuacionModel = Puntuacion(
          idEntidad: idEntidad,
          puntuacion: puntuacion,
          usuario: Usuario(
            idUsuario: idUsuario,
          ),
          tipoEntidad: tipoEntidad);

      LugarDeInteres lugarDeInteres = await crearPuntuacion(puntuacionModel);

      
      if (context.mounted) {
        Provider.of<LugarDeInteresService>(context, listen: false).setLugarDeInteres = lugarDeInteres;
      }
    }
  }
}
