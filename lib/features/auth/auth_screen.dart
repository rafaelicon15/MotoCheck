import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../services/google_auth_service.dart';
import '../../services/drive_backup_service.dart';
import '../../shared/providers/database_provider.dart';
import '../../data/database/app_database.dart' show UnsupportedBackupException;
import '../../app.dart' show onboardingDoneKey, welcomeSignInInProgressProvider;
import '../../shared/widgets/app_logo.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _loading = false;
  String? _error;

  Future<void> _handleSignIn() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    // Mantiene esta pantalla visible hasta terminar con el respaldo.
    final inProgress = ref.read(welcomeSignInInProgressProvider.notifier);
    inProgress.state = true;

    final ok = await ref.read(googleAccountProvider.notifier).signIn();
    final account = ref.read(googleAccountProvider).valueOrNull;

    if (!ok || account == null) {
      inProgress.state = false;
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'No se pudo conectar con Google. Intenta de nuevo.';
        });
      }
      return;
    }

    try {
      final backupTime = await DriveBackupService.getLastBackupTime(account: account);

      if (backupTime != null && mounted) {
        setState(() => _loading = false);
        final shouldRestore = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => _RestoreDialog(backupTime: backupTime),
        );

        if (shouldRestore == true && mounted) {
          setState(() => _loading = true);
          final db = ref.read(databaseProvider);
          await DriveBackupService.restore(db: db, account: account);
        }
      }
    } catch (e) {
      if (mounted) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppTheme.card,
            title: const Text('No se pudo restaurar', style: TextStyle(fontSize: 16)),
            content: Text(
              e is UnsupportedBackupException
                  ? e.toString()
                  : 'No pudimos leer tu respaldo de Drive. Puedes intentarlo después desde Configuración.',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14, height: 1.5),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Entendido')),
            ],
          ),
        );
      }
    }

    await ref.read(databaseProvider).setSetting(onboardingDoneKey, 'true');
    inProgress.state = false; // AuthGate entra a MainShell.
  }

  Future<void> _continueWithoutAccount() async {
    await ref.read(databaseProvider).setSetting(onboardingDoneKey, 'true');
    // AuthGate observa el flag y entra a MainShell.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Logo
              const AppLogo(size: 90),
              const SizedBox(height: 20),
              const Text(
                'MotoCheck',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tu historial de mantenimiento,\nsiempre contigo.',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 15,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 2),

              // Features list
              _FeatureRow(
                icon: Icons.build_outlined,
                color: AppTheme.maintenance,
                text: 'Registra servicios y mantenimientos',
              ),
              const SizedBox(height: 14),
              _FeatureRow(
                icon: Icons.local_gas_station_outlined,
                color: AppTheme.fuel,
                text: 'Controla consumo de combustible',
              ),
              const SizedBox(height: 14),
              _FeatureRow(
                icon: Icons.cloud_sync_outlined,
                color: AppTheme.primary,
                text: 'Respaldo opcional en tu Google Drive',
              ),

              const Spacer(flex: 2),

              // Acción principal: empezar sin cuenta (lo que promete la landing).
              // Google queda como opción para quien ya tiene un respaldo.
              if (_loading)
                const CircularProgressIndicator()
              else ...[
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _continueWithoutAccount,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Empezar',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _handleSignIn,
                    icon: const Text('G',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                    label: const Text('Ya tengo respaldo en Google Drive',
                        style: TextStyle(fontSize: 14)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textPrimary,
                      side: const BorderSide(color: Color(0x33FFFFFF)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!,
                    style: const TextStyle(
                        color: AppTheme.danger, fontSize: 13),
                    textAlign: TextAlign.center),
              ],
              const SizedBox(height: 12),
              const Text(
                'Sin registro: tus datos se guardan en tu celular.\nPuedes activar el respaldo en Drive cuando quieras.',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  const _FeatureRow(
      {required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 20),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Text(text,
            style: const TextStyle(
                color: AppTheme.textPrimary, fontSize: 14)),
      ),
    ]);
  }
}

class _RestoreDialog extends StatelessWidget {
  final DateTime backupTime;
  const _RestoreDialog({required this.backupTime});

  @override
  Widget build(BuildContext context) {
    final formatted = DateFormat("d 'de' MMMM yyyy, HH:mm", 'es')
        .format(backupTime.toLocal());

    return AlertDialog(
      backgroundColor: AppTheme.card,
      title: Row(children: [
        const Icon(Icons.cloud_download_outlined,
            color: AppTheme.primary, size: 22),
        const SizedBox(width: 10),
        const Expanded(
          child: Text('Respaldo encontrado',
              style: TextStyle(fontSize: 16)),
        ),
      ]),
      content: Text(
        'Encontramos un respaldo del $formatted.\n\n¿Deseas restaurar tus datos?',
        style: const TextStyle(
            color: AppTheme.textSecondary, fontSize: 14, height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Empezar desde cero',
              style: TextStyle(color: AppTheme.textSecondary)),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(Icons.restore, size: 16),
          label: const Text('Restaurar'),
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.primary,
          ),
        ),
      ],
    );
  }
}
