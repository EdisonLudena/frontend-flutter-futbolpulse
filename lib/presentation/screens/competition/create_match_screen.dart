import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/repository_providers.dart';
import '../../providers/ui_provider.dart';
import '../../providers/subscription_provider.dart';
import 'matches_screen.dart';
import '../../../theme/app_colors.dart';
import '../../../domain/model/partido.dart';
import '../../../domain/model/categoria.dart';

class CreateMatchScreen extends ConsumerStatefulWidget {
  final Partido? partidoParaEditar;
  const CreateMatchScreen({super.key, this.partidoParaEditar});

  @override
  ConsumerState<CreateMatchScreen> createState() => _CreateMatchScreenState();
}

class _CreateMatchScreenState extends ConsumerState<CreateMatchScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _equipoLocalController;
  late TextEditingController _equipoVisitanteController;
  late DateTime _selectedDate;
  late String _estado;
  String? _selectedCategoryId;
  bool _isLoading = false;
  List<Categoria> _categorias = [];

  @override
  void initState() {
    super.initState();
    final p = widget.partidoParaEditar;
    _equipoLocalController = TextEditingController(text: p?.equipoLocal ?? '');
    _equipoVisitanteController = TextEditingController(text: p?.equipoVisitante ?? '');
    _selectedDate = p?.fecha ?? DateTime.now();
    _estado = p?.estadoPartido ?? 'Programado';
    _selectedCategoryId = p?.categoriaId;
    
    // Cargar categorías disponibles para el club activo
    Future.microtask(() => _loadCategories());
  }

  Future<void> _loadCategories() async {
    final activeOrg = ref.read(activeOrgProvider);
    final isPremium = ref.read(subscriptionProvider).isPremium;
    
    final cats = await ref.read(catalogRepositoryProvider).getCategorias(
      entidadId: isPremium ? activeOrg?.id : null
    );
    
    setState(() {
      _categorias = cats;
      if (_selectedCategoryId == null && cats.isNotEmpty) {
        _selectedCategoryId = cats.first.id;
      }
    });
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedCategoryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecciona una categoría'), backgroundColor: AppColors.error)
        );
        return;
      }

      setState(() => _isLoading = true);
      try {
        final data = {
          'equipo_local': _equipoLocalController.text,
          'equipo_visitante': _equipoVisitanteController.text,
          'fecha': _selectedDate.toUtc().toIso8601String(),
          'estado_partido': _estado,
          'categoria': _selectedCategoryId,
        };

        if (widget.partidoParaEditar != null) {
          await ref.read(competitionRepositoryProvider).updatePartido(widget.partidoParaEditar!.id, data);
        } else {
          await ref.read(competitionRepositoryProvider).createPartido(data);
        }
        
        ref.invalidate(matchesProvider);
        if (mounted) context.pop();
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.partidoParaEditar != null;
    
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar Partido' : 'Nuevo Partido')),
      body: _categorias.isEmpty && !_isLoading
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.category_outlined, size: 64, color: Colors.white24),
                  const SizedBox(height: 16),
                  const Text('No hay categorías creadas para este club.', textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('VOLVER Y CREAR CATEGORÍA'),
                  )
                ],
              ),
            ),
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _equipoLocalController,
                    decoration: const InputDecoration(labelText: 'Equipo Local', prefixIcon: Icon(Icons.shield_outlined)),
                    validator: (v) => v == null || v.isEmpty ? 'Obligatorio' : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _equipoVisitanteController,
                    decoration: const InputDecoration(labelText: 'Equipo Visitante', prefixIcon: Icon(Icons.shield_outlined)),
                    validator: (v) => v == null || v.isEmpty ? 'Obligatorio' : null,
                  ),
                  const SizedBox(height: 20),
                  
                  DropdownButtonFormField<String>(
                    value: _selectedCategoryId,
                    decoration: const InputDecoration(labelText: 'Categoría / Equipo', prefixIcon: Icon(Icons.group_work_outlined)),
                    items: _categorias.map((c) => DropdownMenuItem(value: c.id, child: Text(c.nombre))).toList(),
                    onChanged: (v) => setState(() => _selectedCategoryId = v),
                    validator: (v) => v == null ? 'Selecciona una categoría' : null,
                  ),
                  const SizedBox(height: 20),
                  
                  DropdownButtonFormField<String>(
                    value: _estado,
                    decoration: const InputDecoration(labelText: 'Estado del Partido', prefixIcon: Icon(Icons.info_outline)),
                    items: ['Programado', 'En curso', 'Finalizado', 'Suspendido']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) => setState(() => _estado = v!),
                  ),
                  const SizedBox(height: 20),
                  
                  ListTile(
                    title: const Text('Fecha y Hora'),
                    subtitle: Text(_selectedDate.toString().substring(0, 16)),
                    trailing: const Icon(Icons.calendar_today, color: AppColors.gold),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (date != null && mounted) {
                        final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_selectedDate));
                        if (time != null) {
                          setState(() => _selectedDate = DateTime(date.year, date.month, date.day, time.hour, time.minute));
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                  _isLoading 
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submit, 
                        style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                        child: Text(isEditing ? 'GUARDAR CAMBIOS' : 'CREAR PARTIDO')
                      ),
                ],
              ),
            ),
          ),
    );
  }
}
