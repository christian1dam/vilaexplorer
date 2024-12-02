import 'dart:convert';

class CategoriaPlato {
  final int idCategoriaPlato;
  final String nombreCategoria;
  final bool activo;
  
  CategoriaPlato({
    required this.idCategoriaPlato,
    required this.nombreCategoria,
    required this.activo,
  });

  // Factory para crear un objeto desde un Map (JSON decodificado)
  factory CategoriaPlato.fromMap(Map<String, dynamic> map) {
    return CategoriaPlato(
      idCategoriaPlato: map["idCategoriaPlato"],
      nombreCategoria: map["nombreCategoria"],
      activo: map["activo"],
    );
  }

  // Factory para crear un objeto desde un JSON decodificado (Map)
  // Esto es simplemente un alias de fromMap para consistencia
  factory CategoriaPlato.fromJson(Map<String, dynamic> json) {
    return CategoriaPlato.fromMap(json);
  }

  // Método para convertir el objeto a un Map (JSON serializado)
  Map<String, dynamic> toMap() {
    return {
      "idCategoriaPlato": idCategoriaPlato,
      "nombreCategoria": nombreCategoria,
      "activo": activo,
    };
  }

  // Método para convertir el objeto a JSON String
  String toJson() {
    return jsonEncode(toMap());
  }
}
