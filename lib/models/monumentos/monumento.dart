
import 'dart:convert';

import 'package:vilaexplorer/models/lugarDeInteres/Coordenadas.dart';
import 'package:vilaexplorer/models/lugarDeInteres/TipoLugar.dart';

class Monumentos {
    int? idLugarInteres;
    String? nombreLugar;
    String? descripcion;
    DateTime? fechaAlta;
    double? puntuacionMediaLugar;
    String? imagen;
    bool? activo;
    TipoLugar? tipoLugar;
    List<Coordenada>? coordenadas;

    Monumentos({
        this.idLugarInteres,
        this.nombreLugar,
        this.descripcion,
        this.fechaAlta,
        this.puntuacionMediaLugar,
        this.imagen,
        this.activo,
        this.tipoLugar,
        this.coordenadas,
    });

    factory Monumentos.fromJson(String str) => Monumentos.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Monumentos.fromMap(Map<String, dynamic> json) => Monumentos(
        idLugarInteres: json["idLugarInteres"],
        nombreLugar: json["nombreLugar"],
        descripcion: json["descripcion"],
        fechaAlta: json["fechaAlta"] == null ? null : DateTime.parse(json["fechaAlta"]),
        puntuacionMediaLugar: json["puntuacionMediaLugar"]?.toDouble(),
        imagen: json["imagen"],
        activo: json["activo"],
        tipoLugar: json["tipoLugar"] == null ? null : TipoLugar.fromMap(json["tipoLugar"]),
        coordenadas: json["coordenadas"] == null ? [] : List<Coordenada>.from(json["coordenadas"]!.map((x) => Coordenada.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "idLugarInteres": idLugarInteres,
        "nombreLugar": nombreLugar,
        "descripcion": descripcion,
        "fechaAlta": "${fechaAlta!.year.toString().padLeft(4, '0')}-${fechaAlta!.month.toString().padLeft(2, '0')}-${fechaAlta!.day.toString().padLeft(2, '0')}",
        "puntuacionMediaLugar": puntuacionMediaLugar,
        "imagen": imagen,
        "activo": activo,
        "tipoLugar": tipoLugar?.toMap(),
        "coordenadas": coordenadas == null ? [] : List<dynamic>.from(coordenadas!.map((x) => x.toMap())),
    };
}