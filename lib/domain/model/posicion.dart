class Posicion {
  final String id;
  final String nombrePosicion;
  final String? abreviatura;
  final String zona; // 'Porteria', 'Defensa', 'Mediocampo', 'Ataque'

  Posicion({
    required this.id,
    required this.nombrePosicion,
    this.abreviatura,
    required this.zona,
  });
}
