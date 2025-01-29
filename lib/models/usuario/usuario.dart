import 'dart:convert';

class Usuario {
  int? idUsuario;

  Usuario({
    this.idUsuario,
  });

  factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        idUsuario: json["idUsuario"],
      );

  Map<String, dynamic> toMap() => {
        "idUsuario": idUsuario,
      };
}
