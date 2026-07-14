import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../../core/utils/validators.dart';
import '../../widgets/loading_overlay.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _selectedRole = 'Coach';
  bool _obscurePassword = true;

  final List<String> _roles = ['Coach', 'Scout', 'Player'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await ref.read(authProvider.notifier).register(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              password2: _confirmPasswordController.text,
              nombreCompleto: _nameController.text.trim(),
              tipoUsuario: _selectedRole,
            );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registro exitoso. Ahora puedes iniciar sesión.')),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final textTheme = Theme.of(context).textTheme;

    return LoadingOverlay(
      isLoading: authState.isChecking,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Crear Cuenta'),
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'ÚNETE AL EQUIPO',
                    style: textTheme.headlineLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre Completo',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) => Validators.required(v, 'El nombre'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedRole,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Usuario',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    items: _roles.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedRole = value!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    obscureText: _obscurePassword,
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirmar Contraseña',
                      prefixIcon: Icon(Icons.lock_reset_outlined),
                    ),
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return Validators.required(value, 'Confirmar contraseña');
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('REGISTRARSE'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
