class Alineacion {
  final String id;
  final String partidoId;
  final String jugadorId;
  final bool esTitular;
  final String? posicionPartidoId;
  final int minutoEntrada;
  final int minutoSalida;
  final int minutosJugados;

  Alineacion({
    required this.id,
    required this.partidoId,
    required this.jugadorId,
    required this.esTitular,
    this.posicionPartidoId,
    required this.minutoEntrada,
    required this.minutoSalida,
    required this.minutosJugados,
  });
}
