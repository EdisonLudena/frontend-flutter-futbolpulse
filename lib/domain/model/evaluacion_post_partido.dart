class EvaluacionPostPartido {
  final String id;
  final String partidoId;
  final String jugadorId;
  final double calificacion;
  final String? puntosPositivos;
  final String? puntosAMejorar;
  final bool esVisibleJugador;
  final DateTime creadoEn;

  // Campos expandidos (Solo lectura)
  final String? nombreJugador;
  final String? rivalPartido;

  EvaluacionPostPartido({
    required this.id,
    required this.partidoId,
    required this.jugadorId,
    required this.calificacion,
    this.puntosPositivos,
    this.puntosAMejorar,
    required this.esVisibleJugador,
    required this.creadoEn,
    this.nombreJugador,
    this.rivalPartido,
  });
}
