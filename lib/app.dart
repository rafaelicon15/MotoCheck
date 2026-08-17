import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/fuel/screens/fuel_screen.dart';
import 'features/maintenance/screens/maintenance_screen.dart';
import 'features/parts/screens/parts_screen.dart';
import 'features/settings/settings_screen.dart';

class MotoCheckApp extends StatelessWidget {
  const MotoCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MotoCheck',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      locale: const Locale('es'),
      supportedLocales: const [Locale('es'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: const MainShell(),
    );
  }
}

class MainShell extends ConsumerStatefulWidget {
  /// Permite inyectar pantallas ligeras en pruebas de navegación.
  const MainShell({super.key, this.screens});

  final List<Widget>? screens;

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens =
        widget.screens ??
        const [
          DashboardScreen(),
          MaintenanceScreen(),
          FuelScreen(),
          PartsScreen(),
          SettingsScreen(),
        ];
    assert(_screens.length == 5, 'MainShell requiere cinco pantallas.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0x1AFFFFFF), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.build_outlined),
              activeIcon: Icon(Icons.build),
              label: 'Servicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_gas_station_outlined),
              activeIcon: Icon(Icons.local_gas_station),
              label: 'Combustible',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_suggest_outlined),
              activeIcon: Icon(Icons.settings_suggest),
              label: 'Refacciones',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tune_outlined),
              activeIcon: Icon(Icons.tune),
              label: 'Config.',
            ),
          ],
        ),
      ),
    );
  }
}
