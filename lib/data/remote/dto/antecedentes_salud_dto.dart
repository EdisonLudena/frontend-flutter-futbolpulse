import '../../../domain/model/antecedentes_salud.dart';

class AntecedentesSaludDto {
  final String? id;
  final String? jugador;
  final String? tipoSangre;
  final String? alergias;
  final String? medicamentosRegulares;
  final String? condicionesCronicas;
  final String? contactoMedicoNombre;
  final String? contactoMedicoTel;
  final String? actualizadoEn;

  AntecedentesSaludDto({
    this.id,
    this.jugador,
    this.tipoSangre,
    this.alergias,
    this.medicamentosRegulares,
    this.condicionesCronicas,
    this.contactoMedicoNombre,
    this.contactoMedicoTel,
    this.actualizadoEn,
  });

  factory AntecedentesSaludDto.fromJson(Map<String, dynamic> json) {
    return AntecedentesSaludDto(
      id: json['id']?.toString(),
      jugador: json['jugador']?.toString(),
      tipoSangre: json['tipo_sangre']?.toString(),
      alergias: json['alergias']?.toString(),
      medicamentosRegulares: json['medicamentos_regulares']?.toString(),
      condicionesCronicas: json['condiciones_cronicas']?.toString(),
      contactoMedicoNombre: json['contacto_medico_nombre']?.toString(),
      contactoMedicoTel: json['contacto_medico_tel']?.toString(),
      actualizadoEn: json['actualizado_en']?.toString(),
    );
  }

  AntecedentesSalud toDomain() => AntecedentesSalud(
        id: id ?? '',
        jugadorId: jugador ?? '',
        tipoSangre: tipoSangre ?? 'Desconocido',
        alergias: alergias ?? 'Ninguna',
        medicamentosRegulares: medicamentosRegulares ?? 'Ninguno',
        condicionesCronicas: condicionesCronicas ?? 'Ninguna',
        contactoMedicoNombre: contactoMedicoNombre ?? '',
        contactoMedicoTel: contactoMedicoTel ?? '',
        actualizadoEn: actualizadoEn != null ? DateTime.parse(actualizadoEn!) : DateTime.now(),
      );
}
