import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Pantalla o sección cargando datos (antes de la primera emisión del stream).
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(semanticsLabel: 'Cargando'),
        ),
      );
}

/// Valor de una tarjeta de resumen mientras carga: no mostrar "—" o "Sin datos"
/// como si fuera un resultado real.
class LoadingValue extends StatelessWidget {
  const LoadingValue({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppTheme.textSecondary,
          semanticsLabel: 'Cargando',
        ),
      );
}
