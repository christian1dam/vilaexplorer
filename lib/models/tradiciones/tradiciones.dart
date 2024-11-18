import 'dart:convert';

import 'package:vilaexplorer/models/usuario/usuario.dart';

class Tradiciones {
  int idFiestaTradicion;
  String nombre;
  String descripcion;
  String imagen;
  Usuario autor;

  Tradiciones({
    required this.idFiestaTradicion,
    required this.nombre,
    required this.descripcion,
    required this.imagen,
    required this.autor,
  });

  factory Tradiciones.fromJson(String str) =>
      Tradiciones.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Tradiciones.fromMap(Map<String, dynamic> json) => Tradiciones(
        idFiestaTradicion: json["idFiestaTradicion"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        imagen: json["imagen"],
        autor: Usuario.fromMap(json["autor"]),
      );

  Map<String, dynamic> toMap() => {
        "idFiestaTradicion": idFiestaTradicion,
        "nombre": nombre,
        "descripcion": descripcion,
        "imagen": imagen,
        "autor": autor.toMap(),
      };
}