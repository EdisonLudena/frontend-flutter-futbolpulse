class Validators {
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null ? '$fieldName es obligatorio' : 'Este campo es obligatorio';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'El email es obligatorio';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Email inválido';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'La contraseña es obligatoria';
    if (value.length < 8) return 'Mínimo 8 caracteres';
    // Regla: Al menos una mayúscula y un número
    if (!value.contains(RegExp(r'[A-Z]'))) return 'Debe tener al menos una mayúscula';
    if (!value.contains(RegExp(r'[0-9]'))) return 'Debe tener al menos un número';
    return null;
  }
}
