import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/model/partido.dart';
import '../../../domain/model/jugador.dart';
import '../../../theme/app_colors.dart';
import '../../providers/repository_providers.dart';
import 'matches_screen.dart';
import 'match_detail_screen.dart';

class LiveMatchTrackerScreen extends ConsumerStatefulWidget {
  final Partido partido;
  const LiveMatchTrackerScreen({super.key, required this.partido});

  @override
  ConsumerState<LiveMatchTrackerScreen> createState() => _LiveMatchTrackerScreenState();
}

class _LiveMatchTrackerScreenState extends ConsumerState<LiveMatchTrackerScreen> {
  int _minuto = 45;
  String? _selectedPlayerId;
  List<Jugador> _jugadores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    final players = await ref.read(competitionRepositoryProvider).getJugadores();
    setState(() {
      _jugadores = players;
      if (players.isNotEmpty) _selectedPlayerId = players.first.id;
      _isLoading = false;
    });
  }

  void _registrarEvento(String tipo, String descripcion) async {
    if (_selectedPlayerId == null) return;
    await ref.read(competitionRepositoryProvider).createEventoLive({
      'partido': widget.partido.id,
      'jugador': _selectedPlayerId,
      'minuto': _minuto,
      'tipo_evento': tipo,
      'descripcion': descripcion,
    });

    if (tipo == 'Gol') {
      final currentMatch = await ref.read(competitionRepositoryProvider).getPartido(widget.partido.id);
      await ref.read(competitionRepositoryProvider).updatePartido(widget.partido.id, {
        'goles_favor': currentMatch.golesFavor + 1,
      });
    }
    
    // Forzamos el refresco de los eventos y partidos
    ref.invalidate(matchEventsProvider(widget.partido.id));
    ref.invalidate(matchesProvider);

    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$tipo registrado')));
  }

  void _registrarGolRival() async {
    await ref.read(competitionRepositoryProvider).updatePartido(widget.partido.id, {
      'goles_contra': widget.partido.golesContra + 1,
    });
    ref.invalidate(matchesProvider);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gol del rival registrado')));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text('Rastreo en Vivo')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            color: AppColors.surfaceDark,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedPlayerId,
                  items: _jugadores.map((j) => DropdownMenuItem(value: j.id, child: Text(j.nombreCompleto))).toList(),
                  onChanged: (v) => setState(() => _selectedPlayerId = v),
                  decoration: const InputDecoration(labelText: 'Jugador Implicado'),
                ),
                Slider(value: _minuto.toDouble(), min: 0, max: 95, divisions: 95, label: '$_minuto\'', onChanged: (v) => setState(() => _minuto = v.toInt())),
                Text('Minuto: $_minuto\'', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, padding: const EdgeInsets.all(16), crossAxisSpacing: 16, mainAxisSpacing: 16,
              children: [
                _ActionBtn(label: 'GOL EQUIPO', icon: Icons.sports_soccer, color: AppColors.success, onTap: () => _registrarEvento('Gol', 'Gol anotado')),
                _ActionBtn(label: 'GOL RIVAL', icon: Icons.error_outline, color: Colors.orange, onTap: _registrarGolRival),
                _ActionBtn(label: 'AMARILLA', icon: Icons.square, color: AppColors.warning, onTap: () => _registrarEvento('Tarjeta amarilla', 'Amonestación')),
                _ActionBtn(label: 'ROJA', icon: Icons.square, color: AppColors.error, onTap: () => _registrarEvento('Tarjeta roja', 'Expulsión')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label; final IconData icon; final Color color; final VoidCallback onTap;
  const _ActionBtn({required this.label, required this.icon, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => Material(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16), child: InkWell(onTap: onTap, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: color, size: 40), const SizedBox(height: 8), Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold))])));
}
