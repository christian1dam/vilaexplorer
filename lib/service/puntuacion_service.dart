import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vilaexplorer/api/api_client.dart';
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
    final endpoint =
        "/puntuacion/usuario/$idUsuario/entidad/$tipoEntidad/$idEntidad";

    try {
      final response = await _apiClient.get(endpoint);
      return response.statusCode == 200 && jsonDecode(response.body).isNotEmpty;
    } catch (e) {
      print("Error al verificar puntuación: $e");
      return false;
    }
  }

  Future<void> crearPuntuacion(Puntuacion puntuacion) async {
    final endpoint = "/puntuacion/crear";

    print("Entrando a crearPuntuacion");
    print("Endpoint: $endpoint");
    print("Puntuación enviada: ${puntuacion.toMap()}");

    try {
      print(
          "Enviando puntuación: ${puntuacion.toMap()}");

      final response = await _apiClient.postAuth(
        endpoint,
        body: puntuacion.toMap(),
      );

      if (response.statusCode == 201) {
        print("Puntuación creada correctamente.");
      } else {
        print("Error al crear la puntuación: ${response.statusCode}");
        print("Error body: ${response.body}");
      }
    } catch (e) {
      print("Error al crear puntuación: $e");
      print("${e.hashCode} + ${e.toString()} + ${e.runtimeType}");
    }
  }

  Future<void> actualizarPuntuacion({
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
        print("Puntuación actualizada correctamente.");
      } else {
        print("Error al actualizar la puntuación: ${response.statusCode}");
      }
    } catch (e) {
      print("Error al actualizar puntuación: $e");
    }
  }

  Future<void> gestionarPuntuacion({
    required int idUsuario,
    required int idEntidad,
    required String tipoEntidad,
    required int puntuacion,
    required BuildContext context
  }) async {

    final yaPuntuado = await hasPuntuado(
      idUsuario: idUsuario,
      idEntidad: idEntidad,
      tipoEntidad: tipoEntidad,
    );

    if (yaPuntuado) {
      await actualizarPuntuacion(
        idUsuario: idUsuario,
        idEntidad: idEntidad,
        tipoEntidad: tipoEntidad,
        nuevaPuntuacion: puntuacion,
      );
    } else {
      final puntuacionModel = Puntuacion(
          idEntidad: idEntidad,
          puntuacion: puntuacion,
          usuario: Usuario(
            idUsuario: idUsuario,
          ),
          tipoEntidad: tipoEntidad);
      await crearPuntuacion(puntuacionModel);
    }

    if (context.mounted) {
      await Provider.of<LugarDeInteresService>(context, listen: false).fetchLugaresDeInteresActivos();
    }
  }
}
