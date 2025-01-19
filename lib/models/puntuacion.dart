import 'dart:convert';
import 'package:vilaexplorer/models/usuario/usuario.dart';

class Puntuacion {
  int? idPuntuacion;
  int? puntuacion;
  Usuario? usuario;
  int? idEntidad;
  String? tipoEntidad;

  Puntuacion({
    this.idPuntuacion,
    this.puntuacion,
    this.usuario,
    this.idEntidad,
    this.tipoEntidad,
  });

  factory Puntuacion.fromJson(String str) =>
      Puntuacion.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Puntuacion.fromMap(Map<String, dynamic> json) => Puntuacion(
        idPuntuacion: json["idPuntuacion"],
        puntuacion: json["puntuacion"],
        usuario:
            json["usuario"] == null ? null : Usuario.fromMap(json["usuario"]),
        idEntidad: json["idEntidad"],
        tipoEntidad: json["tipoEntidad"],
      );

  Map<String, dynamic> toMap() => {
        "idPuntuacion": idPuntuacion,
        "puntuacion": puntuacion,
        "usuario": usuario?.toMap(),
        "idEntidad": idEntidad,
        "tipoEntidad": tipoEntidad,
      };
}
