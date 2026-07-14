class EventoLive {
  final String id;
  final String partidoId;
  final String jugadorId;
  final String? jugadorSecundarioId;
  final int minuto;
  final String tipoEvento;
  final String? descripcion;
  final DateTime creadoEn;

  EventoLive({
    required this.id,
    required this.partidoId,
    required this.jugadorId,
    this.jugadorSecundarioId,
    required this.minuto,
    required this.tipoEvento,
    this.descripcion,
    required this.creadoEn,
  });
}
