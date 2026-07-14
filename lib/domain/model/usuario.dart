class Usuario {
  final String id;
  final String email;
  final String nombreCompleto;
  final String tipoUsuario; // 'Coach', 'Scout', 'Player'
  final String estado; // 'Activo', 'Inactivo', 'Suspendido'
  final DateTime fechaRegistro;
  final DateTime? ultimoLogin;
  final String idioma;
  final String unidadMedida;
  final bool notificacionesActivas;
  final bool isStaff;
  final bool isActive;

  Usuario({
    required this.id,
    required this.email,
    required this.nombreCompleto,
    required this.tipoUsuario,
    required this.estado,
    required this.fechaRegistro,
    this.ultimoLogin,
    required this.idioma,
    required this.unidadMedida,
    required this.notificacionesActivas,
    this.isStaff = false,
    this.isActive = true,
  });

  Usuario copyWith({
    String? id,
    String? email,
    String? nombreCompleto,
    String? tipoUsuario,
    String? estado,
    DateTime? fechaRegistro,
    DateTime? ultimoLogin,
    String? idioma,
    String? unidadMedida,
    bool? notificacionesActivas,
    bool? isStaff,
    bool? isActive,
  }) {
    return Usuario(
      id: id ?? this.id,
      email: email ?? this.email,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      tipoUsuario: tipoUsuario ?? this.tipoUsuario,
      estado: estado ?? this.estado,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      ultimoLogin: ultimoLogin ?? this.ultimoLogin,
      idioma: idioma ?? this.idioma,
      unidadMedida: unidadMedida ?? this.unidadMedida,
      notificacionesActivas: notificacionesActivas ?? this.notificacionesActivas,
      isStaff: isStaff ?? this.isStaff,
      isActive: isActive ?? this.isActive,
    );
  }
}
