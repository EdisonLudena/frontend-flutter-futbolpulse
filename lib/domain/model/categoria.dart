class Categoria {
  final String id;
  final String entidadId;
  final String nombre;
  final int? edadMinima;
  final int? edadMaxima;
  final String genero; // 'Masculino', 'Femenino', 'Mixto'
  final bool activo;

  Categoria({
    required this.id,
    required this.entidadId,
    required this.nombre,
    this.edadMinima,
    this.edadMaxima,
    required this.genero,
    required this.activo,
  });
}
