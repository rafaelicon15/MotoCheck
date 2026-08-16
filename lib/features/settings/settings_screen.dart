import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../data/database/app_database.dart';
import '../../services/drive_backup_service.dart';
import '../../services/google_auth_service.dart';
import '../../shared/providers/database_provider.dart';
import '../../shared/providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyAsync = ref.watch(currencyCodeProvider);
    final db = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionLabel(label: 'Respaldo en Google Drive'),
          const SizedBox(height: 8),
          _DriveBackupCard(db: db),
          const SizedBox(height: 24),
          _SectionLabel(label: 'Moneda'),
          const SizedBox(height: 8),
          currencyAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
            data: (current) => _CurrencySelector(
              current: current,
              onSelect: (code) async {
                await db.setSetting(kCurrencyKey, code);
                await DriveBackupService.backupIfSignedIn(db);
              },
            ),
          ),
          const SizedBox(height: 24),
          _SectionLabel(label: 'Acerca de'),
          const SizedBox(height: 8),
          _InfoCard(),
        ],
      ),
    );
  }
}

// ─── Google Drive Backup Card ─────────────────────────────────────────────────

class _DriveBackupCard extends ConsumerStatefulWidget {
  final AppDatabase db;
  const _DriveBackupCard({required this.db});

  @override
  ConsumerState<_DriveBackupCard> createState() => _DriveBackupCardState();
}

class _DriveBackupCardState extends ConsumerState<_DriveBackupCard> {
  bool _loading = false;
  String? _status;

  Future<void> _signIn() async {
    setState(() => _loading = true);
    final ok = await ref.read(googleAccountProvider.notifier).signIn();
    if (!mounted) return;
    final diagnostic = ref.read(googleAccountProvider.notifier).lastError;
    setState(() {
      _loading = false;
      _status = ok
          ? null
          : diagnostic ??
                'No se pudo conectar con Google. Revisa la consola para más detalles.';
    });
  }

  Future<void> _signOut() async {
    await ref.read(googleAccountProvider.notifier).signOut();
    setState(() => _status = null);
  }

  Future<void> _backup() async {
    final account = ref.read(googleAccountProvider).valueOrNull;
    if (account == null) return;
    setState(() {
      _loading = true;
      _status = 'Respaldando...';
    });
    try {
      await DriveBackupService.backup(db: widget.db, account: account);
      if (mounted) {
        setState(() {
          _loading = false;
          _status = '✓ Respaldo exitoso';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _status = 'Error al respaldar: $e';
        });
      }
    }
  }

  Future<void> _restore() async {
    final account = ref.read(googleAccountProvider).valueOrNull;
    if (account == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.card,
        title: const Text('¿Restaurar copia de seguridad?'),
        content: const Text(
          'Esto reemplazará todos tus datos actuales con los del último respaldo en Google Drive.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Restaurar'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _loading = true;
      _status = 'Restaurando...';
    });
    try {
      final found = await DriveBackupService.restore(
        db: widget.db,
        account: account,
      );
      if (mounted) {
        setState(() {
          _loading = false;
          _status = found
              ? '✓ Datos restaurados correctamente'
              : 'No se encontró ningún respaldo en Drive';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _status = 'Error al restaurar: $e';
        });
      }
    }
  }

  String _formatDate(String? iso) {
    if (iso == null) return 'Nunca';
    try {
      final dt = DateTime.parse(iso);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return 'Hace un momento';
      if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
      if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
      return DateFormat('d MMM yyyy, HH:mm', 'es').format(dt);
    } catch (_) {
      return 'Desconocido';
    }
  }

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(googleAccountProvider).valueOrNull;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: account == null ? _buildDisconnected() : _buildConnected(account),
    );
  }

  Widget _buildDisconnected() {
    return Column(
      children: [
        const Icon(
          Icons.cloud_upload_outlined,
          size: 40,
          color: AppTheme.textSecondary,
        ),
        const SizedBox(height: 12),
        const Text(
          'Respalda tus datos en tu Google Drive personal.\nSi cambias de celular o reinstales la app, restauras todo con un toque.',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        if (_loading)
          const CircularProgressIndicator()
        else if (googleAuthConfigurationError != null)
          Text(
            googleAuthConfigurationError!,
            style: const TextStyle(color: Colors.amber, fontSize: 12),
            textAlign: TextAlign.center,
          )
        else
          OutlinedButton.icon(
            onPressed: _signIn,
            icon: const Icon(Icons.login),
            label: const Text('Conectar con Google'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: AppTheme.primary),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        if (_status != null) ...[
          const SizedBox(height: 8),
          Text(
            _status!,
            style: const TextStyle(color: Colors.redAccent, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildConnected(GoogleSignInAccount account) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.primary.withValues(alpha: 0.2),
              child: const Icon(
                Icons.person,
                color: AppTheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.displayName ?? 'Cuenta Google',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    account.email,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: _loading ? null : _signOut,
              child: const Text(
                'Desconectar',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        FutureBuilder<String?>(
          future: ref
              .read(databaseProvider)
              .getSetting(DriveBackupService.lastBackupSettingKey),
          builder: (context, snap) {
            return Text(
              'Último respaldo: ${_formatDate(snap.data)}',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        if (_loading)
          Center(
            child: Column(
              children: [
                const CircularProgressIndicator(),
                if (_status != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _status!,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          )
        else ...[
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _backup,
                  icon: const Icon(Icons.cloud_upload, size: 16),
                  label: const Text('Respaldar ahora'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _restore,
                  icon: const Icon(Icons.cloud_download, size: 16),
                  label: const Text('Restaurar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          if (_status != null) ...[
            const SizedBox(height: 8),
            Text(
              _status!,
              style: TextStyle(
                color: _status!.startsWith('✓')
                    ? Colors.greenAccent
                    : Colors.redAccent,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ],
    );
  }
}

// ─── Currency Selector ────────────────────────────────────────────────────────

class _CurrencySelector extends StatelessWidget {
  final String current;
  final void Function(String) onSelect;
  const _CurrencySelector({required this.current, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        children: kCurrencies.entries.map((e) {
          final code = e.key;
          final info = e.value;
          final isSelected = code == current;
          return InkWell(
            onTap: () => onSelect(code),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border: isSelected
                    ? Border.all(color: AppTheme.primary.withValues(alpha: 0.4))
                    : null,
              ),
              child: Row(
                children: [
                  Text(info['flag']!, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          info['name']!,
                          style: TextStyle(
                            color: isSelected
                                ? AppTheme.primary
                                : AppTheme.textPrimary,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.normal,
                          ),
                        ),
                        Text(
                          '$code · ${info['symbol']}',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      color: AppTheme.primary,
                      size: 20,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        color: AppTheme.textSecondary,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}

// ─── Info Card ────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.motorcycle, color: AppTheme.primary, size: 28),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MotoCheck',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const Text(
                    'Versión 1.0.0',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Gestiona el mantenimiento, consumo de combustible y vida útil de refacciones de tu moto.',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
