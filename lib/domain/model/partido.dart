class Partido {
  final String id;
  final String categoriaId;
  final String? entidadId; // Nuevo campo para filtrar por Club
  final String? sedeId;
  final String rival;
  final bool esLocal;
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
    required this.rival,
    required this.esLocal,
    required this.fecha,
    required this.tipoPartido,
    required this.golesFavor,
    required this.golesContra,
    this.resultadoFinal,
    required this.estadoPartido,
    this.observaciones,
  });
}
