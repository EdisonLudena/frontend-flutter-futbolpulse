import 'package:json_annotation/json_annotation.dart';
import '../../../domain/model/suscripcion.dart';

part 'suscripcion_dto.g.dart';

@JsonSerializable()
class SuscripcionDto {
  final String? id;
  
  // DRF devuelve 'usuario' en este endpoint según los logs
  final String? usuario;
  @JsonKey(name: 'usuario_id')
  final String? usuarioId;
  
  final String? plan;
  final String? estado;
  
  @JsonKey(name: 'fecha_inicio')
  final String? fechaInicio;
  @JsonKey(name: 'fecha_vencimiento')
  final String? fechaVencimiento;
  @JsonKey(name: 'metodo_pago')
  final String? metodoPago;
  @JsonKey(name: 'referencia_pago')
  final String? referenciaPago;
  @JsonKey(name: 'creado_en')
  final String? creadoEn;

  SuscripcionDto({
    this.id,
    this.usuario,
    this.usuarioId,
    this.plan,
    this.estado,
    this.fechaInicio,
    this.fechaVencimiento,
    this.metodoPago,
    this.referenciaPago,
    this.creadoEn,
  });

  factory SuscripcionDto.fromJson(Map<String, dynamic> json) =>
      _$SuscripcionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SuscripcionDtoToJson(this);

  Suscripcion toDomain() => Suscripcion(
        id: id ?? '',
        usuarioId: usuario ?? usuarioId ?? '',
        plan: plan ?? 'Basico',
        estado: estado ?? 'Inactivo',
        fechaInicio: fechaInicio != null ? DateTime.parse(fechaInicio!) : DateTime.now(),
        fechaVencimiento: fechaVencimiento != null ? DateTime.parse(fechaVencimiento!) : DateTime.now(),
        metodoPago: metodoPago,
        referenciaPago: referenciaPago,
        creadoEn: creadoEn != null ? DateTime.parse(creadoEn!) : DateTime.now(),
      );
}
