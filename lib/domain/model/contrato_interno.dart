class ContratoInterno {
  final String id;
  final String jugadorId;
  final String tipoContrato; // 'Beca', 'Profesional', 'Amateur', 'Prueba'
  final double? monto;
  final String moneda;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final String? descripcion;
  final String? archivoUrl;
  final DateTime creadoEn;

  ContratoInterno({
    required this.id,
    required this.jugadorId,
    required this.tipoContrato,
    this.monto,
    required this.moneda,
    required this.fechaInicio,
    this.fechaFin,
    this.descripcion,
    this.archivoUrl,
    required this.creadoEn,
  });
}
