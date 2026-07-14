import 'package:json_annotation/json_annotation.dart';
import '../../../domain/model/entidad.dart';

part 'entidad_dto.g.dart';

@JsonSerializable()
class EntidadDto {
  final String? id;
  @JsonKey(name: 'usuario_id')
  final String? usuarioId;
  @JsonKey(name: 'nombre_entidad')
  final String? nombreEntidad;
  @JsonKey(name: 'logo_url')
  final String? logoUrl;
  final String? ciudad;
  final String? pais;
  @JsonKey(name: 'telefono_contacto')
  final String? telefonoContacto;
  final String? estado;
  @JsonKey(name: 'creado_en')
  final String? creadoEn;
  
  @JsonKey(name: 'email_creador', includeToJson: false)
  final String? emailCreador;

  EntidadDto({
    this.id,
    this.usuarioId,
    this.nombreEntidad,
    this.logoUrl,
    this.ciudad,
    this.pais,
    this.telefonoContacto,
    this.estado,
    this.creadoEn,
    this.emailCreador,
  });

  factory EntidadDto.fromJson(Map<String, dynamic> json) =>
      _$EntidadDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EntidadDtoToJson(this);

  Entidad toDomain() => Entidad(
        id: id ?? '',
        usuarioId: usuarioId ?? '',
        nombreEntidad: nombreEntidad ?? 'Sin nombre',
        logoUrl: logoUrl,
        ciudad: ciudad,
        pais: pais ?? 'Ecuador',
        telefonoContacto: telefonoContacto,
        estado: estado ?? 'Activo',
        creadoEn: creadoEn != null ? DateTime.parse(creadoEn!) : DateTime.now(),
        emailCreador: emailCreador,
      );
}
