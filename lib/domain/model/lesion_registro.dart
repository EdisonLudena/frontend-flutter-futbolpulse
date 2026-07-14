class LesionRegistro {
  final String id;
  final String jugadorId;
  final String descripcion;
  final String zonaCuerpo;
  final String? tipoLesion;
  final String? gravedad; // 'Leve', 'Moderada', 'Grave'
  final DateTime fechaInicio;
  final DateTime? fechaAlta;
  final bool activa;
  final String? medicoTratante;
  final String? observaciones;

  LesionRegistro({
    required this.id,
    required this.jugadorId,
    required this.descripcion,
    required this.zonaCuerpo,
    this.tipoLesion,
    this.gravedad,
    required this.fechaInicio,
    this.fechaAlta,
    required this.activa,
    this.medicoTratante,
    this.observaciones,
  });
}
