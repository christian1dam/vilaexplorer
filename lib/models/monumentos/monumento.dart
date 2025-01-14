import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vilaexplorer/models/usuario/usuario.dart';

class Monumentos {
  int idLugarInteres;
  String nombreLugar;
  String fechaAlta;
  String descripcion;
  int idTipoLugar;
  String imagen;
  String imagenBase64;
  bool activo;
  Usuario autor;

  Monumentos({
    required this.idLugarInteres,
    required this.nombreLugar,
    required this.fechaAlta,
    required this.descripcion,
    required this.idTipoLugar,
    required this.imagen,
    required this.imagenBase64,
    required this.activo,
    required this.autor,
  });

  factory Monumentos.fromJson(String str) =>
      Monumentos.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Monumentos.fromMap(Map<String, dynamic> json) => Monumentos(
        idLugarInteres: json["idLugarInteres"],
        nombreLugar: json["nombreLugar"],
        fechaAlta: json["fechaAlta"],
        descripcion: json["descripcion"],
        idTipoLugar: json["idTipoLugar"],
        imagen: json["imagen"],
        imagenBase64: json["imagenBase64"],
        activo: json["activo"],
        autor: Usuario.fromMap(json["autor"]),
      );

  Map<String, dynamic> toMap() => {
        "idLugarInteres": idLugarInteres,
        "nombreLugar": nombreLugar,
        "fechaAlta": fechaAlta,
        "descripcion": descripcion,
        "idTipoLugar": idTipoLugar,
        "imagen": imagen,
        "imagenBase64": imagenBase64,
        "activo": activo,
        "autor": autor.toMap(),
      };

  // Método para convertir la imagen base64 a un widget de imagen en Flutter
  Image getImagen() {
    return Image.memory(base64Decode(imagenBase64));
  }
}
