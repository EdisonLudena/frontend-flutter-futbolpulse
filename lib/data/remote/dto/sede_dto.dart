import 'package:json_annotation/json_annotation.dart';
import '../../../domain/model/sede.dart';
import '../../../core/utils/parsers.dart';

part 'sede_dto.g.dart';

@JsonSerializable()
class SedeDto {
  final String? id;
  @JsonKey(name: 'entidad_id')
  final String? entidadId;
  @JsonKey(name: 'nombre_sede')
  final String? nombreSede;
  final String? direccion;
  @JsonKey(fromJson: parseDecimal)
  final double? latitud;
  @JsonKey(fromJson: parseDecimal)
  final double? longitud;
  final int? capacidad;
  @JsonKey(name: 'tipo_superficie')
  final String? tipoSuperficie;

  @JsonKey(name: 'nombre_entidad', includeToJson: false)
  final String? nombreEntidad;

  SedeDto({
    this.id,
    this.entidadId,
    this.nombreSede,
    this.direccion,
    this.latitud,
    this.longitud,
    this.capacidad,
    this.tipoSuperficie,
    this.nombreEntidad,
  });

  factory SedeDto.fromJson(Map<String, dynamic> json) =>
      _$SedeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SedeDtoToJson(this);

  Sede toDomain() => Sede(
        id: id ?? '',
        entidadId: entidadId ?? '',
        nombreSede: nombreSede ?? 'Sin nombre',
        direccion: direccion,
        latitud: latitud,
        longitud: longitud,
        capacidad: capacidad,
        tipoSuperficie: tipoSuperficie,
        nombreEntidad: nombreEntidad,
      );
}
