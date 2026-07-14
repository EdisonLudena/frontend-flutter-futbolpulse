import 'package:json_annotation/json_annotation.dart';
import '../../../domain/model/jugador_posicion.dart';

part 'jugador_posicion_dto.g.dart';

@JsonSerializable()
class JugadorPosicionDto {
  final int? id;
  final String? jugador;
  final String? posicion;
  @JsonKey(name: 'es_principal')
  final bool? esPrincipal;
  
  // Campos expandidos del backend
  @JsonKey(name: 'nombre_posicion')
  final String? nombrePosicion;
  @JsonKey(name: 'abreviatura_posicion')
  final String? abreviaturaPosicion;

  JugadorPosicionDto({
    this.id,
    this.jugador,
    this.posicion,
    this.esPrincipal,
    this.nombrePosicion,
    this.abreviaturaPosicion,
  });

  factory JugadorPosicionDto.fromJson(Map<String, dynamic> json) => _$JugadorPosicionDtoFromJson(json);

  JugadorPosicion toDomain() => JugadorPosicion(
    jugadorId: jugador ?? '',
    posicionId: posicion ?? '',
    esPrincipal: esPrincipal ?? false,
  );
}
