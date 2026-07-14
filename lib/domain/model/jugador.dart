class Jugador {
  final String id;
  final String entidadId;
  final String? categoriaId;
  final String nombres;
  final String apellidos;
  final DateTime fechaNacimiento;
  final String? fotoUrl;
  final int? numeroCamiseta;
  final String pieDominante; // 'Derecho', 'Izquierdo', 'Ambidiestro'
  final String? nacionalidad;
  final String? documentoIdentidad;
  final String estado; // 'Activo', 'Lesionado', 'Suspendido', 'Inactivo'
  final DateTime creadoEn;
  
  // Expanded fields
  final String? nombreEntidad;
  final String? nombreCategoria;

  Jugador({
    required this.id,
    required this.entidadId,
    this.categoriaId,
    required this.nombres,
    required this.apellidos,
    required this.fechaNacimiento,
    this.fotoUrl,
    this.numeroCamiseta,
    required this.pieDominante,
    this.nacionalidad,
    this.documentoIdentidad,
    required this.estado,
    required this.creadoEn,
    this.nombreEntidad,
    this.nombreCategoria,
  });

  String get nombreCompleto => '$nombres $apellidos';
}
