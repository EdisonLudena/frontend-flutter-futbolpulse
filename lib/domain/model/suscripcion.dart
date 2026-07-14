class Suscripcion {
  final String id;
  final String usuarioId;
  final String plan; // 'Basico', 'Premium'
  final String estado; // 'Activo', 'Cancelado', 'Vencido', 'Suspendido'
  final DateTime fechaInicio;
  final DateTime fechaVencimiento;
  final String? metodoPago;
  final String? referenciaPago;
  final DateTime creadoEn;

  Suscripcion({
    required this.id,
    required this.usuarioId,
    required this.plan,
    required this.estado,
    required this.fechaInicio,
    required this.fechaVencimiento,
    this.metodoPago,
    this.referenciaPago,
    required this.creadoEn,
  });
}
