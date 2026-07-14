class Representante {
  final String id;
  final String jugadorId;
  final String nombre;
  final String? telefono;
  final String? email;
  final String? parentesco;
  final bool esContactoEmergencia;
  final bool esAgente;

  Representante({
    required this.id,
    required this.jugadorId,
    required this.nombre,
    this.telefono,
    this.email,
    this.parentesco,
    required this.esContactoEmergencia,
    required this.esAgente,
  });
}
