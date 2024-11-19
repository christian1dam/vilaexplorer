import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vilaexplorer/models/usuario/usuario.dart';

class Tradiciones {
  int idFiestaTradicion;
  String nombre;
  String fecha;
  String descripcion;
  String imagenBase64; // Actualización del campo para almacenar la imagen en base64
  Usuario autor;

  Tradiciones({
    required this.idFiestaTradicion,
    required this.nombre,
    required this.fecha,
    required this.descripcion,
    required this.imagenBase64,
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
        imagenBase64: json["imagenBase64"], // Mapear la imagen base64 desde el JSON
        autor: Usuario.fromMap(json["autor"]),
      );

  Map<String, dynamic> toMap() => {
        "idFiestaTradicion": idFiestaTradicion,
        "nombre": nombre,
        "fecha": fecha,
        "descripcion": descripcion,
        "imagenBase64": imagenBase64, // Incluir la imagen base64 en el mapa
        "autor": autor.toMap(),
      };

  // Método para convertir la imagen base64 a un widget de imagen en Flutter
  Image getImagen() {
    return Image.memory(base64Decode(imagenBase64));
  }
}