import '../../../domain/model/historial_antropometrico.dart';
import '../../../core/utils/parsers.dart';

class HistorialAntropometricoDto {
  final String? id;
  final String? jugador;
  final double? pesoKg;
  final double? alturaCm;
  final double? grasaCorporal;
  final double? masaMuscular;
  final double? imc;
  final String? fechaToma;
  final String? observaciones;

  HistorialAntropometricoDto({
    this.id,
    this.jugador,
    this.pesoKg,
    this.alturaCm,
    this.grasaCorporal,
    this.masaMuscular,
    this.imc,
    this.fechaToma,
    this.observaciones,
  });

  factory HistorialAntropometricoDto.fromJson(Map<String, dynamic> json) {
    return HistorialAntropometricoDto(
      id: json['id']?.toString(),
      jugador: json['jugador']?.toString(),
      pesoKg: parseDecimal(json['peso_kg']),
      alturaCm: parseDecimal(json['altura_cm']),
      grasaCorporal: parseDecimal(json['grasa_corporal']),
      masaMuscular: parseDecimal(json['masa_muscular']),
      imc: parseDecimal(json['imc']),
      fechaToma: json['fecha_toma']?.toString(),
      observaciones: json['observaciones']?.toString(),
    );
  }

  HistorialAntropometrico toDomain() => HistorialAntropometrico(
        id: id ?? '',
        jugadorId: jugador ?? '',
        pesoKg: pesoKg ?? 0.0,
        alturaCm: alturaCm ?? 0.0,
        grasaCorporal: grasaCorporal,
        masaMuscular: masaMuscular,
        imc: imc,
        fechaToma: fechaToma != null ? DateTime.parse(fechaToma!) : DateTime.now(),
        observaciones: observaciones,
      );
}
