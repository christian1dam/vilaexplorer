import 'dart:convert';

import 'package:vilaexplorer/models/usuario/rol.dart';

class Role {
  Rol rol;
  DateTime fechaDeAsignacion;

  Role({
    required this.rol,
    required this.fechaDeAsignacion,
  });

  factory Role.fromJson(String str) => Role.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Role.fromMap(Map<String, dynamic> json) => Role(
        rol: Rol.fromMap(json["rol"]),
        fechaDeAsignacion: DateTime.parse(json["fechaDeAsignacion"]),
      );

  Map<String, dynamic> toMap() => {
        "rol": rol.toMap(),
        "fechaDeAsignacion": fechaDeAsignacion.toIso8601String(),
      };
}