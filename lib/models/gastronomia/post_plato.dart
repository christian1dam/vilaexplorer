
class PostPlato {
  final String nombre;
  final String descripcion;
  final String ingredientes;
  final String receta;
  final bool? estado;
  final double? puntuacionMediaPlato;
  final String? imagen;
  final int? tipoPlato;
  final int? autor;
  final int? aprobador;
  final bool? eliminado;

  PostPlato({
    required this.nombre,
    required this.descripcion,
    required this.receta,
    this.tipoPlato,
    required this.ingredientes,
    this.estado,
    this.puntuacionMediaPlato,
    this.imagen,
    this.autor,
    this.aprobador,
    this.eliminado,
  });

  Map<String, dynamic> toJson() {
    return {
      "nombre": nombre,
      "descripcion": descripcion,
      "ingredientes": ingredientes,
      "receta": receta,
      "estado": estado,
      "puntuacionMediaPlato": puntuacionMediaPlato,
      "imagen": imagen,
      "tipoPlato": tipoPlato, // O toJson() si así lo has definido
      "autor": autor,
      "aprobador": aprobador,
      "eliminado": eliminado
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "nombre": nombre,
      "descripcion": descripcion,
      "ingredientes": ingredientes,
      "receta": receta,
      "estado": estado,
      "puntuacionMediaPlato": puntuacionMediaPlato,
      "imagen": imagen,
      "eliminado": eliminado
    };
  }
}
