class TestRendimiento {
  final String id;
  final String jugadorId;
  final double? velocidad30mSeg;
  final double? velocidad60mSeg;
  final int? saltoVerticalCm;
  final int? saltoHorizontalCm;
  final double? resistenciaVo2max;
  final int? resistenciaNivel;
  final int? flexibilidadCm;
  final double? agilidadSeg;
  final DateTime fechaTest;
  final String? observaciones;

  TestRendimiento({
    required this.id,
    required this.jugadorId,
    this.velocidad30mSeg,
    this.velocidad60mSeg,
    this.saltoVerticalCm,
    this.saltoHorizontalCm,
    this.resistenciaVo2max,
    this.resistenciaNivel,
    this.flexibilidadCm,
    this.agilidadSeg,
    required this.fechaTest,
    this.observaciones,
  });
}
