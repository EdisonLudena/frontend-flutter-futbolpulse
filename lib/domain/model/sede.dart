class Sede {
  final String id;
  final String entidadId;
  final String nombreSede;
  final String? direccion;
  final double? latitud;
  final double? longitud;
  final int? capacidad;
  final String? tipoSuperficie;
  final String? nombreEntidad; // Expanded read-only

  Sede({
    required this.id,
    required this.entidadId,
    required this.nombreSede,
    this.direccion,
    this.latitud,
    this.longitud,
    this.capacidad,
    this.tipoSuperficie,
    this.nombreEntidad,
  });
}
