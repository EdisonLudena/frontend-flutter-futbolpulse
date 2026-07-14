class MetricaTactica {
  final String id;
  final String reporteId;
  final int? ubicacion;
  final int? lecturaJuego;
  final int? sacrificio;
  final int? liderazgo;
  final int? presion;
  final int? trabajoEquipo;
  final double? puntajeTactico;

  MetricaTactica({
    required this.id,
    required this.reporteId,
    this.ubicacion,
    this.lecturaJuego,
    this.sacrificio,
    this.liderazgo,
    this.presion,
    this.trabajoEquipo,
    this.puntajeTactico,
  });
}
