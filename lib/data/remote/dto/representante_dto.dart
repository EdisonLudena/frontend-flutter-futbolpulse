import 'package:json_annotation/json_annotation.dart';
import '../../../domain/model/representante.dart';

part 'representante_dto.g.dart';

@JsonSerializable()
class RepresentanteDto {
  final String id;
  @JsonKey(name: 'jugador_id')
  final String jugadorId;
  final String nombre;
  final String? telefono;
  final String? email;
  final String? parentesco;
  @JsonKey(name: 'es_contacto_emergencia')
  final bool esContactoEmergencia;
  @JsonKey(name: 'es_agente')
  final bool esAgente;

  RepresentanteDto({
    required this.id,
    required this.jugadorId,
    required this.nombre,
    this.telefono,
    this.email,
    this.parentesco,
    required this.esContactoEmergencia,
    required this.esAgente,
  });

  factory RepresentanteDto.fromJson(Map<String, dynamic> json) =>
      _$RepresentanteDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RepresentanteDtoToJson(this);

  Representante toDomain() => Representante(
        id: id,
        jugadorId: jugadorId,
        nombre: nombre,
        telefono: telefono,
        email: email,
        parentesco: parentesco,
        esContactoEmergencia: esContactoEmergencia,
        esAgente: esAgente,
      );
}
