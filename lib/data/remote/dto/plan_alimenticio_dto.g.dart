// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_alimenticio_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanAlimenticioDto _$PlanAlimenticioDtoFromJson(Map<String, dynamic> json) =>
    PlanAlimenticioDto(
      id: json['id'] as String,
      jugadorId: json['jugador_id'] as String,
      descripcionDieta: json['descripcion_dieta'] as String?,
      caloriasTotales: (json['calorias_totales'] as num?)?.toInt(),
      proteinaGr: (json['proteina_gr'] as num?)?.toInt(),
      carbohidratosGr: (json['carbohidratos_gr'] as num?)?.toInt(),
      grasasGr: (json['grasas_gr'] as num?)?.toInt(),
      hidratacionMl: (json['hidratacion_ml'] as num?)?.toInt(),
      fechaInicio: json['fecha_inicio'] as String,
      fechaFin: json['fecha_fin'] as String?,
      nutricionista: json['nutricionista'] as String?,
      activo: json['activo'] as bool,
    );

Map<String, dynamic> _$PlanAlimenticioDtoToJson(PlanAlimenticioDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jugador_id': instance.jugadorId,
      'descripcion_dieta': instance.descripcionDieta,
      'calorias_totales': instance.caloriasTotales,
      'proteina_gr': instance.proteinaGr,
      'carbohidratos_gr': instance.carbohidratosGr,
      'grasas_gr': instance.grasasGr,
      'hidratacion_ml': instance.hidratacionMl,
      'fecha_inicio': instance.fechaInicio,
      'fecha_fin': instance.fechaFin,
      'nutricionista': instance.nutricionista,
      'activo': instance.activo,
    };
