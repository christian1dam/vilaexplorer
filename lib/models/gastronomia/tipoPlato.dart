import 'dart:convert';

import 'package:vilaexplorer/models/gastronomia/categoriaPlato.dart';

class TipoPlato {
    int idTipoPlato;
    String nombreTipo;
    bool activo;
    CategoriaPlato categoriaPlato;

    TipoPlato({
        required this.idTipoPlato,
        required this.nombreTipo,
        required this.activo,
        required this.categoriaPlato,
    });

    factory TipoPlato.fromJson(String str) => TipoPlato.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TipoPlato.fromMap(Map<String, dynamic> json) => TipoPlato(
        idTipoPlato: json["idTipoPlato"],
        nombreTipo: json["nombreTipo"],
        activo: json["activo"],
        categoriaPlato: CategoriaPlato.fromMap(json["categoriaPlato"]),
    );

    Map<String, dynamic> toMap() => {
        "idTipoPlato": idTipoPlato,
        "nombreTipo": nombreTipo,
        "activo": activo,
        "categoriaPlato": categoriaPlato.toMap(),
    };
}