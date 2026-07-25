class Partido {
  final String id;
  final String categoriaId;
  final String? entidadId; // Mantenemos para compatibilidad si es necesario
  final String? sedeId;
  final String equipoLocal;
  final String equipoVisitante;
  final DateTime fecha;
  final String tipoPartido;
  final int golesFavor;
  final int golesContra;
  final String? resultadoFinal;
  final String estadoPartido;
  final String? observaciones;

  Partido({
    required this.id,
    required this.categoriaId,
    this.entidadId,
    this.sedeId,
    required this.equipoLocal,
    required this.equipoVisitante,
    required this.fecha,
    required this.tipoPartido,
    required this.golesFavor,
    required this.golesContra,
    this.resultadoFinal,
    required this.estadoPartido,
    this.observaciones,
  });
}
