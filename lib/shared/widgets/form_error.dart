import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Error de validación dentro de una hoja inferior: un SnackBar quedaría tapado
/// por la propia hoja y el usuario no vería por qué no se guardó.
class FormError extends StatelessWidget {
  final String? message;
  const FormError(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        const Icon(Icons.error_outline, color: AppTheme.danger, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(message!,
              style: const TextStyle(color: AppTheme.danger, fontSize: 13)),
        ),
      ]),
    );
  }
}
