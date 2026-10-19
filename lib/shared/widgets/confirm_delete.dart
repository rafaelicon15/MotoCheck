import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Confirma un borrado: no hay deshacer y el respaldo automático lo replica en Drive.
Future<bool> confirmDelete(BuildContext context, String what) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppTheme.card,
      title: Text('¿Eliminar $what?', style: const TextStyle(fontSize: 16)),
      content: const Text('Esta acción no se puede deshacer.',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Eliminar', style: TextStyle(color: AppTheme.danger)),
        ),
      ],
    ),
  );
  return ok ?? false;
}
