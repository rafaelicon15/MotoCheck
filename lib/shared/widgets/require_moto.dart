import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/navigation_provider.dart';

/// Los registros pertenecen a una moto: sin moto activa se pide crearla primero.
bool ensureActiveMoto(BuildContext context, Object? moto) {
  if (moto != null) return true;
  final container = ProviderScope.containerOf(context, listen: false);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: const Text('Primero agrega tu moto'),
    action: SnackBarAction(
      label: 'Ir a Inicio',
      onPressed: () => container.read(mainTabProvider.notifier).state = MainTab.home,
    ),
  ));
  return false;
}
