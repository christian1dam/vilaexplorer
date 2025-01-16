
import 'dart:convert';


class Coordenada {
    int? idCoordenadas;
    double? latitud;
    double? longitud;

    Coordenada({
        this.idCoordenadas,
        this.latitud,
        this.longitud,
    });

    factory Coordenada.fromJson(String str) => Coordenada.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Coordenada.fromMap(Map<String, dynamic> json) => Coordenada(
        idCoordenadas: json["idCoordenadas"],
        latitud: json["latitud"]?.toDouble(),
        longitud: json["longitud"]?.toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "idCoordenadas": idCoordenadas,
        "latitud": latitud,
        "longitud": longitud,
    };
}