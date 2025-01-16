
import 'dart:convert';

class TipoLugar {
    int? idTipoLugar;
    String? nombreTipo;

    TipoLugar({
        this.idTipoLugar,
        this.nombreTipo,
    });

    factory TipoLugar.fromJson(String str) => TipoLugar.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TipoLugar.fromMap(Map<String, dynamic> json) => TipoLugar(
        idTipoLugar: json["idTipoLugar"],
        nombreTipo: json["nombreTipo"],
    );

    Map<String, dynamic> toMap() => {
        "idTipoLugar": idTipoLugar,
        "nombreTipo": nombreTipo,
    };
}
