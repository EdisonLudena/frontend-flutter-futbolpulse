import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/repository_providers.dart';
import '../../providers/auth_provider.dart';
import 'evaluations_screen.dart';
import '../../../theme/app_colors.dart';
import '../../../domain/model/evaluacion_post_partido.dart';
import '../../../domain/model/partido.dart';
import '../../../domain/model/jugador.dart';

class CreateEvaluationScreen extends ConsumerStatefulWidget {
  final EvaluacionPostPartido? evaluacionParaEditar;
  const CreateEvaluationScreen({super.key, this.evaluacionParaEditar});

  @override
  ConsumerState<CreateEvaluationScreen> createState() => _CreateEvaluationScreenState();
}

class _CreateEvaluationScreenState extends ConsumerState<CreateEvaluationScreen> {
  final _formKey = GlobalKey<FormState>();
  late double _calificacion;
  late TextEditingController _positivosController;
  late TextEditingController _mejorarController;
  late bool _esVisible;
  String? _selectedMatchId;
  String? _selectedPlayerId;
  
  bool _isInitialLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  List<Partido> _partidos = [];
  List<Jugador> _jugadores = [];

  @override
  void initState() {
    super.initState();
    final ev = widget.evaluacionParaEditar;
    _calificacion = ev?.calificacion ?? 5.0;
    _positivosController = TextEditingController(text: ev?.puntosPositivos ?? '');
    _mejorarController = TextEditingController(text: ev?.puntosAMejorar ?? '');
    _esVisible = ev?.esVisibleJugador ?? false;
    
    // Inicializamos con los IDs que vienen del objeto
    _selectedMatchId = (ev?.partidoId != null && ev!.partidoId.isNotEmpty) ? ev.partidoId : null;
    _selectedPlayerId = (ev?.jugadorId != null && ev!.jugadorId.isNotEmpty) ? ev.jugadorId : null;
    
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final repo = ref.read(competitionRepositoryProvider);
      final results = await Future.wait([
        repo.getPartidos(),
        repo.getJugadores(),
      ]);
      
      if (mounted) {
        setState(() {
          _partidos = results[0] as List<Partido>;
          _jugadores = results[1] as List<Jugador>;

          // Si el ID de la evaluación no está en la lista actual del server, lo reseteamos para que el usuario elija uno válido
          if (_selectedMatchId != null && !_partidos.any((m) => m.id == _selectedMatchId)) {
            _selectedMatchId = null;
          }
          if (_selectedPlayerId != null && !_jugadores.any((j) => j.id == _selectedPlayerId)) {
            _selectedPlayerId = null;
          }

          _isInitialLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isInitialLoading = false;
        });
      }
    }
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedMatchId == null || _selectedPlayerId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecciona un partido y un jugador'))
        );
        return;
      }

      setState(() => _isSaving = true);
      try {
        final repo = ref.read(competitionRepositoryProvider);
        final data = {
          'partido': _selectedMatchId,
          'jugador': _selectedPlayerId,
          'calificacion': _calificacion,
          'puntos_positivos': _positivosController.text,
          'puntos_a_mejorar': _mejorarController.text,
          'es_visible_jugador': _esVisible,
        };

        if (widget.evaluacionParaEditar != null) {
          await repo.updateEvaluacion(widget.evaluacionParaEditar!.id, data);
        } else {
          await repo.saveEvaluacion(data);
        }
        
        ref.invalidate(evaluationsProvider);
        if (mounted) context.pop();
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.evaluacionParaEditar != null;

    if (_isInitialLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(isEditing ? 'Editar Evaluación' : 'Nueva Evaluación')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar Evaluación' : 'Nueva Evaluación')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedMatchId,
                decoration: const InputDecoration(labelText: 'Seleccionar Partido', prefixIcon: Icon(Icons.sports_soccer)),
                items: _partidos.map((m) => DropdownMenuItem(value: m.id, child: Text('vs ${m.rival}'))).toList(),
                onChanged: (v) => setState(() => _selectedMatchId = v), // DESBLOQUEADO
                validator: (v) => v == null ? 'Selecciona un partido' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedPlayerId,
                decoration: const InputDecoration(labelText: 'Seleccionar Jugador', prefixIcon: Icon(Icons.person_outline)),
                items: _jugadores.map((j) => DropdownMenuItem(value: j.id, child: Text(j.nombreCompleto))).toList(),
                onChanged: (v) => setState(() => _selectedPlayerId = v), // DESBLOQUEADO
                validator: (v) => v == null ? 'Selecciona un jugador' : null,
              ),
              const SizedBox(height: 32),
              Text('CALIFICACIÓN: ${_calificacion.toStringAsFixed(1)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.gold)),
              Slider(
                value: _calificacion, min: 1.0, max: 10.0, divisions: 90,
                activeColor: AppColors.gold,
                onChanged: (v) => setState(() => _calificacion = v),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _positivosController, maxLines: 3,
                decoration: const InputDecoration(labelText: 'Puntos Positivos'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _mejorarController, maxLines: 3,
                decoration: const InputDecoration(labelText: 'Puntos a Mejorar'),
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                title: const Text('¿Visible para el jugador?'),
                value: _esVisible, activeColor: AppColors.gold,
                onChanged: (v) => setState(() => _esVisible = v),
              ),
              const SizedBox(height: 40),
              Center(
                child: _isSaving 
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit, 
                      child: Text(isEditing ? 'GUARDAR CAMBIOS' : 'GUARDAR EVALUACIÓN')
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
