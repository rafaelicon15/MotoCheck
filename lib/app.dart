import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/maintenance/screens/maintenance_screen.dart';
import 'features/fuel/screens/fuel_screen.dart';
import 'features/parts/screens/parts_screen.dart';
import 'features/settings/settings_screen.dart';
import 'services/google_auth_service.dart';

class MotoCheckApp extends StatelessWidget {
  const MotoCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MotoCheck',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      locale: const Locale('es'),
      supportedLocales: const [
        Locale('es'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: const AuthGate(),
    );
  }
}

// ─── Auth Gate ────────────────────────────────────────────────────────────────

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountAsync = ref.watch(googleAccountProvider);

    return accountAsync.when(
      loading: () => const _SplashScreen(),
      error: (_, __) => const AuthScreen(),
      data: (account) =>
          account == null ? const AuthScreen() : const MainShell(),
    );
  }
}

// ─── Splash (mientras silent sign-in carga) ───────────────────────────────────

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Center(
                child: Text('🏍', style: TextStyle(fontSize: 42)),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'MotoCheck',
              style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 32),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppTheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shell principal (5 tabs) ─────────────────────────────────────────────────

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    MaintenanceScreen(),
    FuelScreen(),
    PartsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0x1AFFFFFF), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
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
