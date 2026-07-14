class AntecedentesSalud {
  final String id;
  final String jugadorId;
  final String? tipoSangre;
  final String? alergias;
  final String? medicamentosRegulares;
  final String? condicionesCronicas;
  final String? contactoMedicoNombre;
  final String? contactoMedicoTel;
  final DateTime actualizadoEn;

  AntecedentesSalud({
    required this.id,
    required this.jugadorId,
    this.tipoSangre,
    this.alergias,
    this.medicamentosRegulares,
    this.condicionesCronicas,
    this.contactoMedicoNombre,
    this.contactoMedicoTel,
    required this.actualizadoEn,
  });
}
