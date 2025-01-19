import 'dart:convert';

import 'package:vilaexplorer/models/usuario/rol.dart';
import 'package:vilaexplorer/models/usuario/role.dart';

class Usuario {
  int? idUsuario;
  String? nombre;
  String? email;
  String? password;
  DateTime? fechaCreacion;
  bool? activo;
  List<Role>? roles;
  Rol? rolActual;

  Usuario({
    this.idUsuario,
    this.nombre,
    this.email,
    this.password,
    this.fechaCreacion,
    this.activo,
    this.roles,
    this.rolActual,
  });

  factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        idUsuario: json["idUsuario"],
        nombre: json["nombre"],
        email: json["email"],
        password: json["password"],
        fechaCreacion: json["fechaCreacion"] == null
            ? null
            : DateTime.parse(json["fechaCreacion"]),
        activo: json["activo"],
        roles: json["roles"] == null
            ? []
            : List<Role>.from(json["roles"]!.map((x) => Role.fromMap(x))),
        rolActual:
            json["rolActual"] == null ? null : Rol.fromMap(json["rolActual"]),
      );

  Map<String, dynamic> toMap() => {
        "idUsuario": idUsuario,
        "nombre": nombre,
        "email": email,
        "password": password,
        "fechaCreacion": fechaCreacion != null
            ? "${fechaCreacion!.year.toString().padLeft(4, '0')}-${fechaCreacion!.month.toString().padLeft(2, '0')}-${fechaCreacion!.day.toString().padLeft(2, '0')}"
            : null,
        "activo": activo,
        "roles": roles == null
            ? []
            : List<dynamic>.from(roles!.map((x) => x.toMap())),
        "rolActual": rolActual?.toMap(),
      };
}
