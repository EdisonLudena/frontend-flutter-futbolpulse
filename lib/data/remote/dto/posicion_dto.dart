import '../../../domain/model/posicion.dart';

class PosicionDto {
  final String? id;
  final String? nombrePosicion;
  final String? abreviatura;
  final String? zona;

  PosicionDto({
    this.id,
    this.nombrePosicion,
    this.abreviatura,
    this.zona,
  });

  factory PosicionDto.fromJson(Map<String, dynamic> json) {
    return PosicionDto(
      id: json['id'] as String?,
      nombrePosicion: json['nombre_posicion'] as String?,
      abreviatura: json['abreviatura'] as String?,
      zona: json['zona'] as String?,
    );
  }

  Posicion toDomain() => Posicion(
        id: id ?? '',
        nombrePosicion: nombrePosicion ?? 'Sin nombre',
        abreviatura: abreviatura,
        zona: zona ?? 'Porteria',
      );
}
