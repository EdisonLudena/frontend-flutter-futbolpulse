import 'package:json_annotation/json_annotation.dart';
import '../../../domain/model/jugador.dart';

part 'jugador_dto.g.dart';

@JsonSerializable()
class JugadorDto {
  final String? id;
  
  // DRF puede devolver 'entidad' o 'entidad_id'. Usamos entidad como principal.
  final String? entidad;
  @JsonKey(name: 'entidad_id')
  final String? entidadId;
  
  final String? categoria;
  @JsonKey(name: 'categoria_id')
  final String? categoriaId;

  final String? nombres;
  final String? apellidos;
  @JsonKey(name: 'fecha_nacimiento')
  final String? fechaNacimiento;
  @JsonKey(name: 'foto_url')
  final String? fotoUrl;
  @JsonKey(name: 'numero_camiseta')
  final int? numeroCamiseta;
  @JsonKey(name: 'pie_dominante')
  final String? pieDominante;
  final String? nacionalidad;
  @JsonKey(name: 'documento_identidad')
  final String? documentoIdentidad;
  final String? estado;
  @JsonKey(name: 'creado_en')
  final String? creadoEn;

  @JsonKey(name: 'nombre_entidad', includeToJson: false)
  final String? nombreEntidad;
  @JsonKey(name: 'nombre_categoria', includeToJson: false)
  final String? nombreCategoria;

  JugadorDto({
    this.id,
    this.entidad,
    this.entidadId,
    this.categoria,
    this.categoriaId,
    this.nombres,
    this.apellidos,
    this.fechaNacimiento,
    this.fotoUrl,
    this.numeroCamiseta,
    this.pieDominante,
    this.nacionalidad,
    this.documentoIdentidad,
    this.estado,
    this.creadoEn,
    this.nombreEntidad,
    this.nombreCategoria,
  });

  factory JugadorDto.fromJson(Map<String, dynamic> json) =>
      _$JugadorDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JugadorDtoToJson(this);

  Jugador toDomain() => Jugador(
        id: id ?? '',
        entidadId: entidad ?? entidadId ?? '',
        categoriaId: categoria ?? categoriaId,
        nombres: nombres ?? 'Sin nombre',
        apellidos: apellidos ?? '',
        fechaNacimiento: fechaNacimiento != null ? DateTime.parse(fechaNacimiento!) : DateTime.now(),
        fotoUrl: fotoUrl,
        numeroCamiseta: numeroCamiseta,
        pieDominante: pieDominante ?? 'Derecho',
        nacionalidad: nacionalidad,
        documentoIdentidad: documentoIdentidad,
        estado: estado ?? 'Activo',
        creadoEn: creadoEn != null ? DateTime.parse(creadoEn!) : DateTime.now(),
        nombreEntidad: nombreEntidad,
        nombreCategoria: nombreCategoria,
      );
}
