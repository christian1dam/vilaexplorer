import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vilaexplorer/models/usuario/usuario.dart';

class Tradiciones {
  int idFiestaTradicion;
  String nombre;
  String fecha;
  String descripcion;
  double puntuacionMediaTradicion;
  String imagen;
  bool activo;
  Usuario autor;

  Tradiciones({
    required this.idFiestaTradicion,
    required this.nombre,
    required this.fecha,
    required this.descripcion,
    required this.puntuacionMediaTradicion,
    required this.imagen,
    required this.activo,
    required this.autor,
  });

  factory Tradiciones.fromJson(String str) =>
      Tradiciones.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Tradiciones.fromMap(Map<String, dynamic> json) => Tradiciones(
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