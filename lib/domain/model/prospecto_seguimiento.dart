class ProspectoSeguimiento {
  final String id;
  final String usuarioId;
  final String? jugadorId;
  final String? nombreJugador;
  final String? equipoActual;
  final String? posicionId;
  final DateTime? fechaNacimiento;
  final String? nacionalidad;
  final String estado; // 'Seguimiento', 'Contactado', 'En evaluación', 'Oferta enviada', 'Reclutado', 'Descartado'
  final DateTime? fechaPrimerContacto;
  final String? observaciones;
  final DateTime creadoEn;

  ProspectoSeguimiento({
    required this.id,
    required this.usuarioId,
    this.jugadorId,
    this.nombreJugador,
    this.equipoActual,
    this.posicionId,
    this.fechaNacimiento,
    this.nacionalidad,
    required this.estado,
    this.fechaPrimerContacto,
    this.observaciones,
    required this.creadoEn,
  });
}
