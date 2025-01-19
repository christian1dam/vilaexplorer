import 'dart:convert';

import 'package:vilaexplorer/models/usuario/usuario.dart';

class Favorito {
  int? idFavorito;
  Usuario? usuario;
  int? idEntidad;
  String? tipoEntidad;

  Favorito({
    this.idFavorito,
    this.usuario,
    this.idEntidad,
    this.tipoEntidad,
  });

  factory Favorito.fromJson(String str) => Favorito.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Favorito.fromMap(Map<String, dynamic> json) => Favorito(
        idFavorito: json["idFavorito"],
        usuario:
            json["usuario"] == null ? null : Usuario.fromMap(json["usuario"]),
        idEntidad: json["idEntidad"],
        tipoEntidad: json["tipoEntidad"],
      );

  Map<String, dynamic> toMap() => {
        "idFavorito": idFavorito,
        "usuario": usuario?.toMap(),
        "idEntidad": idEntidad,
        "tipoEntidad": tipoEntidad,
      };
}