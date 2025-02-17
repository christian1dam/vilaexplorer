import 'dart:convert';
import 'package:vilaexplorer/models/usuario/usuario.dart';

class Tradicion {
  int idFiestaTradicion;
  String nombre;
  String fecha;
  String descripcion;
  double puntuacionMediaTradicion;
  String imagen;
  bool activo;
  Usuario autor;

  Tradicion({
    required this.idFiestaTradicion,
    required this.nombre,
    required this.fecha,
    required this.descripcion,
    required this.puntuacionMediaTradicion,
    required this.imagen,
    required this.activo,
    required this.autor,
  });

  factory Tradicion.fromJson(String str) =>
      Tradicion.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Tradicion.fromMap(Map<String, dynamic> json) => Tradicion(
        idFiestaTradicion: json["idFiestaTradicion"],
        nombre: json["nombre"],
        fecha: json["fecha"],
        descripcion: json["descripcion"],
        puntuacionMediaTradicion: json["puntuacionMediaTradicion"],
        imagen: json["imagen"],
        activo: json["activo"],
        autor: Usuario.fromMap(json["autor"]),
      );

  Map<String, dynamic> toMap() => {
        "idFiestaTradicion": idFiestaTradicion,
        "nombre": nombre,
        "fecha": fecha,
        "descripcion": descripcion,
        "puntuacionMediaTradicion": puntuacionMediaTradicion,
        "imagen": imagen,
        "activo": activo,
        "autor": autor.toMap(),
      };
}