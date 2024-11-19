import 'dart:convert';

import 'package:vilaexplorer/models/gastronomia/tipoPlato.dart';
import 'package:vilaexplorer/models/usuario/usuario.dart';

class Plato {
  int platoId;
  String nombre;
  String descripcion;
  String ingredientes;
  String receta;
  bool estado;
  String imagen;
  String imagenBase64;
  TipoPlato tipoPlato;
  Usuario autor;
  Usuario? aprobador;

  Plato({
    required this.platoId,
    required this.nombre,
    required this.descripcion,
    required this.ingredientes,
    required this.receta,
    required this.estado,
    required this.imagen,
    required this.imagenBase64,
    required this.tipoPlato,
    required this.autor,
    this.aprobador,
  });

  factory Plato.fromJson(String str) => Plato.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Plato.fromMap(Map<String, dynamic> json) => Plato(
        platoId: json["platoId"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        ingredientes: json["ingredientes"],
        receta: json["receta"],
        estado: json["estado"],
        imagen: json["imagen"],
        imagenBase64: json["imagenBase64"],
        tipoPlato: TipoPlato.fromMap(json["tipoPlato"]),
        autor: Usuario.fromMap(json["autor"]),
        aprobador: json["aprobador"] != null ? Usuario.fromMap(json["aprobador"]) : null,
      );

  Map<String, dynamic> toMap() => {
        "platoId": platoId,
        "nombre": nombre,
        "descripcion": descripcion,
        "ingredientes": ingredientes,
        "receta": receta,
        "estado": estado,
        "imagen": imagen,
        "imagenBase64": imagenBase64,
        "tipoPlato": tipoPlato.toMap(),
        "autor": autor.toMap(),
        "aprobador": aprobador?.toMap(),
      };
}
