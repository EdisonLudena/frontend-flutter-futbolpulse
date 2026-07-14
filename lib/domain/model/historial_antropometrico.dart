class HistorialAntropometrico {
  final String id;
  final String jugadorId;
  final double pesoKg;
  final double alturaCm;
  final double? grasaCorporal;
  final double? masaMuscular;
  final double? imc;
  final DateTime fechaToma;
  final String? observaciones;

  HistorialAntropometrico({
    required this.id,
    required this.jugadorId,
    required this.pesoKg,
    required this.alturaCm,
    this.grasaCorporal,
    this.masaMuscular,
    this.imc,
    required this.fechaToma,
    this.observaciones,
  });
}
