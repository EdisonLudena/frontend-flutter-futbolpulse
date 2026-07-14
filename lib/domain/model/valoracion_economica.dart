class ValoracionEconomica {
  final String id;
  final String jugadorId;
  final double valorEstimado;
  final String moneda;
  final DateTime fechaValoracion;
  final String? metodoValoracion;
  final String? observaciones;

  ValoracionEconomica({
    required this.id,
    required this.jugadorId,
    required this.valorEstimado,
    required this.moneda,
    required this.fechaValoracion,
    this.metodoValoracion,
    this.observaciones,
  });

  // Getter auxiliar para evitar confusiones de nombres con el DTO
  double get valor_estimado => valorEstimado;
}
