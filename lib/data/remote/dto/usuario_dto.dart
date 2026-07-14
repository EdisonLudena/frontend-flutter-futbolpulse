import 'package:json_annotation/json_annotation.dart';
import '../../../domain/model/usuario.dart';

part 'usuario_dto.g.dart';

@JsonSerializable()
class UsuarioDto {
  final String? id;
  final String? email;
  @JsonKey(name: 'nombre_completo')
  final String? nombreCompleto;
  @JsonKey(name: 'tipo_usuario')
  final String? tipoUsuario;
  final String? estado;
  @JsonKey(name: 'fecha_registro')
  final String? fechaRegistro;
  @JsonKey(name: 'ultimo_login')
  final String? ultimoLogin;
  final String? idioma;
  @JsonKey(name: 'unidad_medida')
  final String? unidadMedida;
  @JsonKey(name: 'notificaciones_activas')
  final bool? notificacionesActivas;
  @JsonKey(name: 'is_staff')
  final bool? isStaff;
  @JsonKey(name: 'is_active')
  final bool? isActive;

  UsuarioDto({
    this.id,
    this.email,
    this.nombreCompleto,
    this.tipoUsuario,
    this.estado,
    this.fechaRegistro,
    this.ultimoLogin,
    this.idioma,
    this.unidadMedida,
    this.notificacionesActivas,
    this.isStaff,
    this.isActive,
  });

  factory UsuarioDto.fromJson(Map<String, dynamic> json) =>
      _$UsuarioDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UsuarioDtoToJson(this);

  Usuario toDomain() => Usuario(
        id: id ?? '',
        email: email ?? '',
        nombreCompleto: nombreCompleto ?? 'Usuario',
        tipoUsuario: tipoUsuario ?? 'Player',
        estado: estado ?? 'Activo',
        fechaRegistro: fechaRegistro != null ? DateTime.parse(fechaRegistro!) : DateTime.now(),
        ultimoLogin: ultimoLogin != null ? DateTime.parse(ultimoLogin!) : null,
        idioma: idioma ?? 'es',
        unidadMedida: unidadMedida ?? 'Metrico',
        notificacionesActivas: notificacionesActivas ?? true,
        isStaff: isStaff ?? false,
        isActive: isActive ?? true,
      );
}
