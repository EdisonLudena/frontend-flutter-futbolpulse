class Entidad {
  final String id;
  final String usuarioId;
  final String nombreEntidad;
  final String? logoUrl;
  final String? ciudad;
  final String pais;
  final String? telefonoContacto;
  final String estado;
  final DateTime creadoEn;
  final String? emailCreador; // Expanded read-only

  Entidad({
    required this.id,
    required this.usuarioId,
    required this.nombreEntidad,
    this.logoUrl,
    this.ciudad,
    required this.pais,
    this.telefonoContacto,
    required this.estado,
    required this.creadoEn,
    this.emailCreador,
  });
}
