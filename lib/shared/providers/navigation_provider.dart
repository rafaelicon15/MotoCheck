import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Pestañas de MainShell, en el orden de la barra inferior.
enum MainTab { home, maintenance, fuel, parts, settings }

/// Pestaña visible; cualquier pantalla puede cambiarla (p. ej. "Primeros pasos").
final mainTabProvider = StateProvider<MainTab>((ref) => MainTab.home);
