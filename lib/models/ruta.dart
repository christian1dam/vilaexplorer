import 'dart:convert';

import 'package:vilaexplorer/models/lugarDeInteres/Coordenadas.dart';
import 'package:vilaexplorer/models/usuario/usuario.dart';

class Ruta {
  final int? idRuta;
  final String? nombreRuta;
  final Usuario? autor;
  final List<Coordenada>? coordenadas;
  final bool? activo;
  final double? distancia;
  final double? duracion;
  final bool? predefinida;
  final List<double>? bbox;

  Ruta({
    this.idRuta,
    this.nombreRuta,
    this.autor,
    this.coordenadas,
    this.activo,
    this.distancia,
    this.duracion,
    this.predefinida,
    this.bbox,
  });

  factory Ruta.fromJson(String str) => Ruta.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Ruta.fromMap(Map<String, dynamic> json) => Ruta(
        idRuta: json["idRuta"],
        nombreRuta: json["nombreRuta"],
        autor: json["autor"] == null ? null : Usuario.fromMap(json["autor"]),
        coordenadas: json["coordenadas"] == null
            ? []
            : List<Coordenada>.from(
                json["coordenadas"]!.map((x) => Coordenada.fromMap(x))),
        activo: json["activo"],
        distancia: json["distancia"]?.toDouble(),
        duracion: json["duracion"]?.toDouble(),
        predefinida: json["predefinida"],
        bbox: json["bbox"] == null
            ? []
            : List<double>.from(json["bbox"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toMap() => {
        "idRuta": idRuta,
        "nombreRuta": nombreRuta,
        "autor": autor?.toMap(),
        "coordenadas": coordenadas == null
            ? []
            : List<dynamic>.from(coordenadas!.map((x) => x.toMap())),
        "activo": activo,
        "distancia": distancia,
        "duracion": duracion,
        "predefinida": predefinida,
        "bbox": bbox == null ? [] : List<dynamic>.from(bbox!.map((x) => x)),
      };
}
