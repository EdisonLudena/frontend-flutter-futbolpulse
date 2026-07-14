import 'package:json_annotation/json_annotation.dart';
import '../../../domain/model/categoria.dart';

part 'categoria_dto.g.dart';

@JsonSerializable()
class CategoriaDto {
  final String? id;
  @JsonKey(name: 'entidad_id')
  final String? entidadId;
  final String? nombre;
  @JsonKey(name: 'edad_minima')
  final int? edadMinima;
  @JsonKey(name: 'edad_maxima')
  final int? edadMaxima;
  final String? genero;
  final bool? activo;

  CategoriaDto({
    this.id,
    this.entidadId,
    this.nombre,
    this.edadMinima,
    this.edadMaxima,
    this.genero,
    this.activo,
  });

  factory CategoriaDto.fromJson(Map<String, dynamic> json) =>
      _$CategoriaDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriaDtoToJson(this);

  Categoria toDomain() => Categoria(
        id: id ?? '',
        entidadId: entidadId ?? '',
        nombre: nombre ?? 'Sin nombre',
        edadMinima: edadMinima,
        edadMaxima: edadMaxima,
        genero: genero ?? 'Masculino',
        activo: activo ?? true,
      );
}
