import 'dart:convert';

class CategoriaPlato {
  int idCategoriaPlato;
  String nombreCategoria;
  bool activo;

  CategoriaPlato({
    required this.idCategoriaPlato,
    required this.nombreCategoria,
    required this.activo,
  });

  factory CategoriaPlato.fromJson(String str) =>
      CategoriaPlato.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CategoriaPlato.fromMap(Map<String, dynamic> json) => CategoriaPlato(
        idCategoriaPlato: json["idCategoriaPlato"],
        nombreCategoria: json["nombreCategoria"],
        activo: json["activo"],
      );

  Map<String, dynamic> toMap() => {
        "idCategoriaPlato": idCategoriaPlato,
        "nombreCategoria": nombreCategoria,
        "activo": activo,
      };
}