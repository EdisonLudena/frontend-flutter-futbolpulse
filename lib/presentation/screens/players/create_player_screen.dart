import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/repository_providers.dart';
import '../../providers/ui_provider.dart';
import 'players_screen.dart';
import '../../../theme/app_colors.dart';
import '../../../domain/model/jugador.dart';
import '../../../domain/model/categoria.dart';

class CreatePlayerScreen extends ConsumerStatefulWidget {
  final Jugador? jugadorParaEditar;
  const CreatePlayerScreen({super.key, this.jugadorParaEditar});

  @override
  ConsumerState<CreatePlayerScreen> createState() => _CreatePlayerScreenState();
}

class _CreatePlayerScreenState extends ConsumerState<CreatePlayerScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl, _lastNameCtrl, _dorsalCtrl, _cedulaCtrl, _nacCtrl;
  late DateTime _birthDate;
  String _pie = 'Derecho';
  String _estado = 'Activo';
  String? _catId;
  List<Categoria> _categorias = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final j = widget.jugadorParaEditar;
    _nameCtrl = TextEditingController(text: j?.nombres ?? '');
    _lastNameCtrl = TextEditingController(text: j?.apellidos ?? '');
    _dorsalCtrl = TextEditingController(text: j?.numeroCamiseta?.toString() ?? '');
    _cedulaCtrl = TextEditingController(text: j?.documentoIdentidad ?? '');
    _nacCtrl = TextEditingController(text: j?.nacionalidad ?? 'Ecuatoriana');
    _birthDate = j?.fechaNacimiento ?? DateTime(2010, 1, 1);
    _pie = j?.pieDominante ?? 'Derecho';
    _estado = j?.estado ?? 'Activo';
    _catId = j?.categoriaId;
    
    _loadData();
  }

  void _loadData() async {
    final activeOrg = ref.read(activeOrgProvider);
    if (activeOrg != null) {
      final cats = await ref.read(catalogRepositoryProvider).getCategorias(entidadId: activeOrg.id);
      setState(() {
        _categorias = cats;
        if (_catId == null && cats.isNotEmpty) _catId = cats.first.id;
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_catId == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecciona una categoría')));
        return;
      }

      setState(() => _isLoading = true);
      try {
        final activeOrg = ref.read(activeOrgProvider);
        final data = {
          'entidad': activeOrg?.id,
          'categoria': _catId,
          'nombres': _nameCtrl.text,
          'apellidos': _lastNameCtrl.text,
          'numero_camiseta': int.tryParse(_dorsalCtrl.text),
          'documento_identidad': _cedulaCtrl.text,
          'pie_dominante': _pie,
          'nacionalidad': _nacCtrl.text,
          'estado': _estado,
          'fecha_nacimiento': _birthDate.toIso8601String().substring(0, 10),
        };

        if (widget.jugadorParaEditar != null) {
          await ref.read(playerRepositoryProvider).updateJugador(widget.jugadorParaEditar!.id, data);
        } else {
          await ref.read(playerRepositoryProvider).createJugador(data);
        }
        ref.invalidate(playersProvider);
        context.pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.jugadorParaEditar == null ? 'Nuevo Jugador' : 'Editar Jugador')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Nombres')),
              const SizedBox(height: 16),
              TextFormField(controller: _lastNameCtrl, decoration: const InputDecoration(labelText: 'Apellidos')),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _dorsalCtrl, decoration: const InputDecoration(labelText: 'Dorsal'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _pie,
                      items: ['Derecho', 'Izquierdo', 'Ambidiestro'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                      onChanged: (v) => setState(() => _pie = v!),
                      decoration: const InputDecoration(labelText: 'Pie'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(controller: _cedulaCtrl, decoration: const InputDecoration(labelText: 'Cédula / Documento')),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _categorias.any((c) => c.id == _catId) ? _catId : null,
                items: _categorias.map((c) => DropdownMenuItem(value: c.id, child: Text(c.nombre))).toList(),
                onChanged: (v) => setState(() => _catId = v),
                decoration: const InputDecoration(labelText: 'Categoría'),
              ),
              const SizedBox(height: 24),
              _isLoading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _submit, child: const Text('GUARDAR JUGADOR')),
            ],
          ),
        ),
      ),
    );
  }
}
