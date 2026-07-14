import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../providers/repository_providers.dart';
import 'players_screen.dart';
import '../../../domain/model/jugador.dart';

class LineupTab extends ConsumerStatefulWidget {
  const LineupTab({super.key});

  @override
  ConsumerState<LineupTab> createState() => _LineupTabState();
}

class _LineupTabState extends ConsumerState<LineupTab> {
  String _selectedFormation = '4-4-2';
  
  // Mapa de asignaciones: Key de la formación visual -> JugadorID
  // Se guarda solo en memoria local durante la sesión actual
  final Map<String, String?> _assignedPlayers = {}; 

  void _resetAll() {
    setState(() {
      _selectedFormation = '4-4-2';
      _assignedPlayers.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pizarra táctica reiniciada'), backgroundColor: AppColors.pitchPrimary)
    );
  }

  final Map<String, List<Map<String, dynamic>>> _formations = {
    '4-4-2': [
      {'key': 'GK', 'top': 430.0, 'left': 0.42},
      {'key': 'LB', 'top': 330.0, 'left': 0.05},
      {'key': 'LCB', 'top': 345.0, 'left': 0.28},
      {'key': 'RCB', 'top': 345.0, 'left': 0.58},
      {'key': 'RB', 'top': 330.0, 'left': 0.8},
      {'key': 'LM', 'top': 210.0, 'left': 0.05},
      {'key': 'LCM', 'top': 225.0, 'left': 0.28},
      {'key': 'RCM', 'top': 225.0, 'left': 0.58},
      {'key': 'RM', 'top': 210.0, 'left': 0.8},
      {'key': 'LST', 'top': 70.0, 'left': 0.28},
      {'key': 'RST', 'top': 70.0, 'left': 0.58},
    ],
    '4-3-3': [
      {'key': 'GK', 'top': 430.0, 'left': 0.42},
      {'key': 'LB', 'top': 330.0, 'left': 0.05},
      {'key': 'LCB', 'top': 345.0, 'left': 0.28},
      {'key': 'RCB', 'top': 345.0, 'left': 0.58},
      {'key': 'RB', 'top': 330.0, 'left': 0.8},
      {'key': 'CM', 'top': 240.0, 'left': 0.42},
      {'key': 'LCM', 'top': 220.0, 'left': 0.18},
      {'key': 'RCM', 'top': 220.0, 'left': 0.68},
      {'key': 'LW', 'top': 80.0, 'left': 0.08},
      {'key': 'ST', 'top': 60.0, 'left': 0.42},
      {'key': 'RW', 'top': 80.0, 'left': 0.78},
    ],
    '3-4-3': [
      {'key': 'GK', 'top': 430.0, 'left': 0.42},
      {'key': 'LCB', 'top': 345.0, 'left': 0.15},
      {'key': 'CB', 'top': 355.0, 'left': 0.42},
      {'key': 'RCB', 'top': 345.0, 'left': 0.7},
      {'key': 'LM', 'top': 220.0, 'left': 0.05},
      {'key': 'LCM', 'top': 240.0, 'left': 0.28},
      {'key': 'RCM', 'top': 240.0, 'left': 0.58},
      {'key': 'RM', 'top': 220.0, 'left': 0.8},
      {'key': 'LW', 'top': 80.0, 'left': 0.1},
      {'key': 'ST', 'top': 60.0, 'left': 0.42},
      {'key': 'RW', 'top': 80.0, 'left': 0.75},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final playersAsync = ref.watch(playersProvider);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedFormation,
                  decoration: const InputDecoration(labelText: 'PIZARRA TÁCTICA', prefixIcon: Icon(Icons.grid_view_rounded)),
                  items: _formations.keys.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                  onChanged: (v) {
                    setState(() {
                      _selectedFormation = v!;
                      _assignedPlayers.clear(); // Limpiar al cambiar sistema para evitar errores visuales
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: _resetAll,
                icon: const Icon(Icons.refresh_rounded, color: AppColors.gold),
                tooltip: 'Reiniciar Pizarra',
              )
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  height: 520,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D6A4F),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white24, width: 2),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15)],
                  ),
                  child: Stack(
                    children: [
                      Center(child: Container(width: double.infinity, height: 1.5, color: Colors.white24)),
                      Center(child: Container(width: 110, height: 110, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white24, width: 1.5)))),
                      
                      ..._buildPitchPositions(
                        _formations[_selectedFormation]!, 
                        playersAsync.value ?? []
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'Uso Temporal: Esta pizarra no guarda datos en el servidor.',
                    style: TextStyle(fontSize: 10, color: Colors.black26, fontStyle: FontStyle.italic),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPitchPositions(List<Map<String, dynamic>> formationPos, List<Jugador> players) {
    final List<Widget> widgets = [];
    final screenWidth = MediaQuery.of(context).size.width - 64;

    for (var posData in formationPos) {
      final key = posData['key'];
      final assignedPlayerId = _assignedPlayers[key];
      
      final player = assignedPlayerId != null 
          ? players.where((p) => p.id == assignedPlayerId).firstOrNull 
          : null;

      widgets.add(
        Positioned(
          top: (posData['top'] as num).toDouble(),
          left: screenWidth * (posData['left'] as num).toDouble(),
          child: InkWell(
            onTap: () => _showPlayerPicker(key, players),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: player != null ? AppColors.gold : Colors.white.withOpacity(0.2),
                  child: Icon(player != null ? Icons.person : Icons.add, color: Colors.white, size: 16),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(4)),
                  child: Text(
                    player?.nombreCompleto.split(' ').first ?? key,
                    style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  void _showPlayerPicker(String positionKey, List<Jugador> players) {
    // FILTRO: Solo bloqueamos jugadores visibles en la cancha actual
    final currentInFieldIds = _assignedPlayers.values.where((id) => id != null).toList();
    final currentPlayerId = _assignedPlayers[positionKey];

    final availablePlayers = players.where((p) {
      if (p.id == currentPlayerId) return true;
      return !currentInFieldIds.contains(p.id);
    }).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ASIGNAR A $positionKey', style: AppTextStyles.sectionTitle()),
                if (currentPlayerId != null)
                  TextButton.icon(
                    onPressed: () {
                      setState(() => _assignedPlayers[positionKey] = null);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.person_remove_outlined, color: AppColors.error, size: 18),
                    label: const Text('QUITAR', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const Divider(height: 32),
            Expanded(
              child: availablePlayers.isEmpty 
                ? const Center(child: Text('No hay más jugadores disponibles', style: TextStyle(color: Colors.black26)))
                : ListView.builder(
                    itemCount: availablePlayers.length,
                    itemBuilder: (context, i) {
                      final j = availablePlayers[i];
                      final isSelected = j.id == currentPlayerId;
                      return ListTile(
                        selected: isSelected,
                        leading: CircleAvatar(
                          backgroundColor: isSelected ? AppColors.gold : AppColors.pitchPrimaryFaint,
                          child: Text('${j.numeroCamiseta ?? "?"}', style: TextStyle(color: isSelected ? Colors.white : AppColors.pitchPrimary, fontSize: 12)),
                        ),
                        title: Text(j.nombreCompleto),
                        onTap: () {
                          setState(() => _assignedPlayers[positionKey] = j.id);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
