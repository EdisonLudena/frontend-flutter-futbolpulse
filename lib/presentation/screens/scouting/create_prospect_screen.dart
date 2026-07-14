import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/model/prospecto_seguimiento.dart';
import '../../providers/repository_providers.dart';
import 'scouting_dashboard_screen.dart';

class CreateProspectScreen extends ConsumerStatefulWidget {
  final ProspectoSeguimiento? prospectoParaEditar;
  const CreateProspectScreen({super.key, this.prospectoParaEditar});

  @override
  ConsumerState<CreateProspectScreen> createState() => _CreateProspectScreenState();
}

class _CreateProspectScreenState extends ConsumerState<CreateProspectScreen> {
  late TextEditingController _nombreCtrl;
  late TextEditingController _equipoCtrl;
  late TextEditingController _obsCtrl;
  String _estado = 'Seguimiento';

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.prospectoParaEditar?.nombreJugador);
    _equipoCtrl = TextEditingController(text: widget.prospectoParaEditar?.equipoActual);
    _obsCtrl = TextEditingController(text: widget.prospectoParaEditar?.observaciones);
    if (widget.prospectoParaEditar != null) _estado = widget.prospectoParaEditar!.estado;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.prospectoParaEditar == null ? 'Nuevo Prospecto' : 'Editar Prospecto')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(controller: _nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre del Jugador')),
          const SizedBox(height: 16),
          TextField(controller: _equipoCtrl, decoration: const InputDecoration(labelText: 'Equipo Actual')),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _estado,
            // Normalizamos a los valores que Django acepta
            items: ['Seguimiento', 'Descartado'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) => setState(() => _estado = v!),
            decoration: const InputDecoration(labelText: 'Estado en el Sistema'),
          ),
          const SizedBox(height: 16),
          TextField(controller: _obsCtrl, decoration: const InputDecoration(labelText: 'Observaciones Técnicas'), maxLines: 3),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () async {
              try {
                final data = {
                  'nombre_jugador': _nombreCtrl.text,
                  'equipo_actual': _equipoCtrl.text,
                  'estado': _estado,
                  'observaciones': _obsCtrl.text,
                };
                if (widget.prospectoParaEditar != null) {
                  await ref.read(scoutingRepositoryProvider).updateProspecto(widget.prospectoParaEditar!.id, data);
                } else {
                  await ref.read(scoutingRepositoryProvider).createProspecto(data);
                }
                ref.invalidate(prospectosProvider);
                if (mounted) Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
              }
            },
            child: const Text('GUARDAR PROSPECTO'),
          ),
        ],
      ),
    );
  }
}
