class ReporteScouting {
  final String id;
  final String usuarioId;
  final String? jugadorId;
  final String? prospectoId;
  final int valoracionEstrellas; // 1-5
  final String? comentarioTecnico;
  final String? partidoObservado;
  final DateTime fechaReporte;

  ReporteScouting({
    required this.id,
    required this.usuarioId,
    this.jugadorId,
    this.prospectoId,
    required this.valoracionEstrellas,
    this.comentarioTecnico,
    this.partidoObservado,
    required this.fechaReporte,
  });
}
