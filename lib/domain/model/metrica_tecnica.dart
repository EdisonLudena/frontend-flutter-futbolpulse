class MetricaTecnica {
  final String id;
  final String reporteId;
  final int? control;
  final int? paseCorto;
  final int? paseLargo;
  final int? tiro;
  final int? regate;
  final int? cabeceo;
  final int? velocidad;
  final int? resistencia;
  final double? puntajeTecnico;

  MetricaTecnica({
    required this.id,
    required this.reporteId,
    this.control,
    this.paseCorto,
    this.paseLargo,
    this.tiro,
    this.regate,
    this.cabeceo,
    this.velocidad,
    this.resistencia,
    this.puntajeTecnico,
  });
}
