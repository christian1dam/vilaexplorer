import 'dart:convert';

import 'package:vilaexplorer/models/usuario/rol.dart';
import 'package:vilaexplorer/models/usuario/role.dart';

class Usuario {
    int idUsuario;
    String nombre;
    String email;
    String password;
    DateTime fechaCreacion;
    bool activo;
    List<Role> roles;
    Rol rolActual;

    Usuario({
        required this.idUsuario,
        required this.nombre,
        required this.email,
        required this.password,
        required this.fechaCreacion,
        required this.activo,
        required this.roles,
        required this.rolActual,
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
        roles: List<Role>.from(json["roles"].map((x) => Role.fromMap(x))),
        rolActual: Rol.fromMap(json["rolActual"]),
    );

    Map<String, dynamic> toMap() => {
        "idUsuario": idUsuario,
        "nombre": nombre,
        "email": email,
        "password": password,
        "fechaCreacion": "${fechaCreacion.year.toString().padLeft(4, '0')}-${fechaCreacion.month.toString().padLeft(2, '0')}-${fechaCreacion.day.toString().padLeft(2, '0')}",
        "activo": activo,
        "roles": List<dynamic>.from(roles.map((x) => x.toMap())),
        "rolActual": rolActual.toMap(),
    };
}
