import 'package:json_annotation/json_annotation.dart';
import '../../../domain/model/evento_live.dart';

part 'evento_live_dto.g.dart';

@JsonSerializable()
class EventoLiveDto {
  final String? id;
  final dynamic partido; 
  @JsonKey(name: 'partido_id')
  final String? partidoId;
  final dynamic jugador;
  @JsonKey(name: 'jugador_id')
  final String? jugadorId;
  final int? minuto;
  @JsonKey(name: 'tipo_evento')
  final String? tipoEvento;
  final String? descripcion;
  @JsonKey(name: 'creado_en')
  final String? creadoEn;

  EventoLiveDto({
    this.id,
    this.partido,
    this.partidoId,
    this.jugador,
    this.jugadorId,
    this.minuto,
    this.tipoEvento,
    this.descripcion,
    this.creadoEn,
  });

  factory EventoLiveDto.fromJson(Map<String, dynamic> json) =>
      _$EventoLiveDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EventoLiveDtoToJson(this);

  EventoLive toDomain() => EventoLive(
        id: id ?? '',
        partidoId: partido is String ? partido : (partidoId ?? ''),
        jugadorId: jugador is String ? jugador : (jugadorId ?? ''),
        minuto: minuto ?? 0,
        tipoEvento: tipoEvento ?? 'Evento',
        descripcion: descripcion ?? '',
        creadoEn: creadoEn != null ? DateTime.parse(creadoEn!) : DateTime.now(),
      );
}
