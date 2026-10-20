import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../data/database/app_database.dart';
import '../../shared/providers/navigation_provider.dart';

const _dismissedKey = 'getting_started_dismissed';

/// Primeros pasos tras registrar la moto: refacciones comunes, primera carga y
/// último servicio. Se oculta sola al completarse o si el usuario la descarta.
class GettingStartedCard extends ConsumerStatefulWidget {
  final AppDatabase db;
  final MotoProfileData moto;
  const GettingStartedCard({super.key, required this.db, required this.moto});

  @override
  ConsumerState<GettingStartedCard> createState() => _GettingStartedCardState();
}

class _GettingStartedCardState extends ConsumerState<GettingStartedCard> {
  // Las consultas se crean una vez por moto: recrearlas en cada build reinicia
  // los StreamBuilder y la tarjeta puede no llegar a mostrarse.
  late Stream<bool> _dismissed;
  late Stream<bool> _hasParts;
  late Stream<bool> _hasFuel;
  late Stream<bool> _hasMaintenance;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void didUpdateWidget(GettingStartedCard old) {
    super.didUpdateWidget(old);
    if (old.moto.id != widget.moto.id || old.db != widget.db) _subscribe();
  }

  void _subscribe() {
    final db = widget.db;
    final id = widget.moto.id;
    _dismissed = db.watchSetting(_dismissedKey).map((v) => v == 'true');
    _hasParts = db.watchParts(id).map((l) => l.isNotEmpty);
    _hasFuel = db.watchFuelRecords(id).map((l) => l.isNotEmpty);
    _hasMaintenance = db.watchMaintenanceRecords(id).map((l) => l.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _dismissed,
      builder: (context, dismissed) {
        if (dismissed.data != false) return const SizedBox.shrink();
        return StreamBuilder<bool>(
          stream: _hasParts,
          builder: (context, parts) => StreamBuilder<bool>(
            stream: _hasFuel,
            builder: (context, fuel) => StreamBuilder<bool>(
              stream: _hasMaintenance,
              builder: (context, maintenance) {
                if (!parts.hasData || !fuel.hasData || !maintenance.hasData) {
                  return const SizedBox.shrink();
                }
                return _buildCard([
                  _Step(
                    title: 'Carga las refacciones de tu moto',
                    subtitle: 'Aceite, cadena, frenos y más, con su vida útil en km',
                    done: parts.data!,
                    tab: MainTab.parts,
                  ),
                  _Step(
                    title: 'Registra tu última carga de gasolina',
                    subtitle: 'Con dos cargas de tanque lleno calculamos tu km/L',
                    done: fuel.data!,
                    tab: MainTab.fuel,
                  ),
                  _Step(
                    title: 'Registra tu último servicio',
                    subtitle: 'Así sabremos cuándo toca el siguiente',
                    done: maintenance.data!,
                    tab: MainTab.maintenance,
                  ),
                ]);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(List<_Step> steps) {
    final completed = steps.where((s) => s.done).length;
    if (completed == steps.length) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 8),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Expanded(
              child: Text('Primeros pasos',
                  style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
            ),
            Text('$completed de ${steps.length}',
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            IconButton(
              tooltip: 'Ocultar primeros pasos',
              icon: const Icon(Icons.close, size: 18, color: AppTheme.textSecondary),
              onPressed: () => widget.db.setSetting(_dismissedKey, 'true'),
            ),
          ]),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: completed / steps.length,
              minHeight: 4,
              backgroundColor: AppTheme.cardBorder,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 6),
          for (final step in steps)
            _StepTile(
              step: step,
              onTap: () => ref.read(mainTabProvider.notifier).state = step.tab,
            ),
        ],
      ),
    );
  }
}

class _Step {
  final String title;
  final String subtitle;
  final bool done;
  final MainTab tab;
  const _Step({required this.title, required this.subtitle, required this.done, required this.tab});
}

class _StepTile extends StatelessWidget {
  final _Step step;
  final VoidCallback onTap;
  const _StepTile({required this.step, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(right: 8),
      enabled: !step.done,
      onTap: step.done ? null : onTap,
      // Transición tipo "morph" (como morphicons en la landing): el círculo
      // gira y rebota hasta convertirse en palomita al completar el paso.
      leading: AnimatedSwitcher(
        duration: const Duration(milliseconds: 420),
        switchInCurve: Curves.easeOutBack,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) => RotationTransition(
          turns: Tween(begin: -0.25, end: 0.0).animate(animation),
          child: ScaleTransition(scale: animation, child: child),
        ),
        child: Icon(
          step.done ? Icons.check_circle : Icons.radio_button_unchecked,
          key: ValueKey(step.done),
          color: step.done ? AppTheme.success : AppTheme.primary,
          semanticLabel: step.done ? 'Completado' : 'Pendiente',
        ),
      ),
      title: Text(
        step.title,
        style: TextStyle(
          color: step.done ? AppTheme.textSecondary : AppTheme.textPrimary,
          fontSize: 14,
          decoration: step.done ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: step.done
          ? null
          : Text(step.subtitle,
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
      trailing: step.done
          ? null
          : const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
    );
  }
}
