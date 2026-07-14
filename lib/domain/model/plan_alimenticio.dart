class PlanAlimenticio {
  final String id;
  final String jugadorId;
  final String? descripcionDieta;
  final int? caloriasTotales;
  final int? proteinaGr;
  final int? carbohidratosGr;
  final int? grasasGr;
  final int? hidratacionMl;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final String? nutricionista;
  final bool activo;

  PlanAlimenticio({
    required this.id,
    required this.jugadorId,
    this.descripcionDieta,
    this.caloriasTotales,
    this.proteinaGr,
    this.carbohidratosGr,
    this.grasasGr,
    this.hidratacionMl,
    required this.fechaInicio,
    this.fechaFin,
    this.nutricionista,
    required this.activo,
  });
}
