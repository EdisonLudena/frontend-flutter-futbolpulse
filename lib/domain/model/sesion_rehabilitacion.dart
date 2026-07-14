class SesionRehabilitacion {
  final String id;
  final String lesionId;
  final String ejerciciosRealizados;
  final int? duracionMinutos;
  final int? dolorNivel; // 0-10
  final DateTime fechaSesion;
  final String? fisioterapeuta;
  final String? observaciones;

  SesionRehabilitacion({
    required this.id,
    required this.lesionId,
    required this.ejerciciosRealizados,
    this.duracionMinutos,
    this.dolorNivel,
    required this.fechaSesion,
    this.fisioterapeuta,
    this.observaciones,
  });
}
