import 'dart:convert';

class Rol {
  int idRol;
  String nombre;
  bool activo;

  Rol({
    required this.idRol,
    required this.nombre,
    required this.activo,
  });

  factory Rol.fromJson(String str) => Rol.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Rol.fromMap(Map<String, dynamic> json) => Rol(
        idRol: json["idRol"],
        nombre: json["nombre"],
        activo: json["activo"],
      );

  Map<String, dynamic> toMap() => {
        "idRol": idRol,
        "nombre": nombre,
        "activo": activo,
      };
}
