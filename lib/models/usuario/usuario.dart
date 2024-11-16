import 'dart:convert';

import 'package:vilaexplorer/models/usuario/rol.dart';
import 'package:vilaexplorer/models/usuario/role.dart';

class Usuario {
  int? idUsuario;
  String nombre;
  String email;
  String password;
  DateTime fechaCreacion;
  bool activo;
  List<Role>? roles;
  Rol? rolActual;

  Usuario({
    this.idUsuario,
    required this.nombre,
    required this.email,
    required this.password,
    required this.fechaCreacion,
    required this.activo,
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
        fechaCreacion: DateTime.parse(json["fechaCreacion"]),
        activo: json["activo"],
        roles: json["roles"] != null
            ? List<Role>.from(json["roles"].map((x) => Role.fromMap(x)))
            : null,
        rolActual:
            json["rolActual"] != null ? Rol.fromMap(json["rolActual"]) : null,
      );

  // Este método genera el mapa que se enviará al servidor
  Map<String, dynamic> toMap() => {
        "nombre": nombre,
        "email": email,
        "password": password,
        "fechaCreacion":
            "${fechaCreacion.year.toString().padLeft(4, '0')}-${fechaCreacion.month.toString().padLeft(2, '0')}-${fechaCreacion.day.toString().padLeft(2, '0')}",
        "activo": activo,
      };
}
