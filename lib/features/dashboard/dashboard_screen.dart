import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../data/database/app_database.dart';
import '../../services/drive_backup_service.dart';
import '../../shared/providers/database_provider.dart';
import '../../shared/providers/active_moto_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    final motoAsync = ref.watch(activeMotoProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.motorcycle, color: AppTheme.primary, size: 22),
            const SizedBox(width: 8),
            const Text('MotoCheck'),
          ],
        ),
      ),
      body: motoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (moto) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MotoSelectorCard(db: db, activeMoto: moto),
              const SizedBox(height: 16),
              if (moto != null) ...[
                _SectionTitle(title: 'Resumen rápido'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 108,
                        child: _StatCard(
                          label: 'Último km/L',
                          icon: Icons.local_gas_station,
                          color: AppTheme.fuel,
                          valueWidget: _LastKmL(db: db, motoId: moto.id),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 108,
                        child: _StatCard(
                          label: 'Próximo servicio',
                          icon: Icons.build,
                          color: AppTheme.maintenance,
                          valueWidget: _NextService(db: db, motoId: moto.id),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _PartsAlertCard(db: db, moto: moto),
              ] else ...[
                _NoMotoPrompt(db: db),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Selector de motos ────────────────────────────────────────────────────────

class _MotoSelectorCard extends ConsumerWidget {
  final AppDatabase db;
  final MotoProfileData? activeMoto;
  const _MotoSelectorCard({required this.db, required this.activeMoto});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allMotos = ref.watch(allMotosProvider).valueOrNull ?? [];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD84315), Color(0xFF8E280F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.motorcycle, size: 44, color: Colors.white),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activeMoto != null
                      ? '${activeMoto!.brand} ${activeMoto!.model}'
                      : 'Sin moto activa',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  activeMoto != null
                      ? '${activeMoto!.year}  ·  ${activeMoto!.currentKm} km'
                      : 'Agrega tu moto para comenzar',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (activeMoto != null) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children: [
                      if (activeMoto!.displacement != null)
                        _MotoBadge(
                          label: '${activeMoto!.displacement}cc',
                          color: Colors.teal,
                        ),
                      _MotoBadge(
                        label: activeMoto!.engineType,
                        color: activeMoto!.engineType == '2T'
                            ? Colors.amber
                            : Colors.lightBlue,
                      ),
                      if (activeMoto!.engineType == '4T')
                        _MotoBadge(
                          label: activeMoto!.fuelSystem == 'injection'
                              ? '💉 Inyección'
                              : '🔩 Carburada',
                          color: activeMoto!.fuelSystem == 'injection'
                              ? Colors.deepPurple
                              : Colors.brown,
                        ),
                      _MotoBadge(
                        label: activeMoto!.coolingType == 'liquid'
                            ? '🌡 Radiador'
                            : '💨 Aire',
                        color: activeMoto!.coolingType == 'liquid'
                            ? Colors.cyan
                            : Colors.orange,
                      ),
                      if (activeMoto!.engineType == '4T' &&
                          activeMoto!.oilFilterType == 'permanent')
                        const _MotoBadge(
                          label: 'Filtro metálico',
                          color: Colors.grey,
                        ),
                      if (activeMoto!.engineType == '2T' &&
                          activeMoto!.twoStrokeOilMethod != null)
                        _MotoBadge(
                          label: activeMoto!.twoStrokeOilMethod == 'autolube'
                              ? '🛢 Autolube'
                              : activeMoto!.twoStrokeOilMethod == 'premix'
                              ? '⛽ Premezclado'
                              : 'Sin aceite sep.',
                          color: Colors.purple,
                        ),
                      if (activeMoto!.engineType == '4T' &&
                          activeMoto!.oilType != null)
                        _MotoBadge(
                          label:
                              '${activeMoto!.oilType} ${activeMoto!.oilViscosity ?? ''}',
                          color: Colors.green.shade600,
                        ),
                      _MotoBadge(
                        label: activeMoto!.rimType == 'spoke'
                            ? '🔩 Rayos'
                            : activeMoto!.rimType == 'spoke_double_wall'
                            ? '🛞 Rayos 2P'
                            : '⭕ Paleta',
                        color: Colors.blueGrey,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Column(
            children: [
              if (activeMoto != null)
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                  onPressed: () => _showMotoForm(context, db, activeMoto),
                  tooltip: 'Editar',
                ),
              IconButton(
                icon: Icon(
                  allMotos.length > 1
                      ? Icons.swap_horiz
                      : Icons.add_circle_outline,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () =>
                    _showMotoManager(context, db, allMotos, activeMoto),
                tooltip: allMotos.length > 1 ? 'Cambiar moto' : 'Agregar moto',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showMotoManager(
    BuildContext context,
    AppDatabase db,
    List<MotoProfileData> motos,
    MotoProfileData? active,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Mis motos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ...motos.map(
              (m) => ListTile(
                leading: Icon(
                  Icons.motorcycle,
                  color: m.isActive ? AppTheme.primary : AppTheme.textSecondary,
                ),
                title: Text(
                  '${m.brand} ${m.model}',
                  style: TextStyle(
                    color: m.isActive ? AppTheme.primary : AppTheme.textPrimary,
                    fontWeight: m.isActive
                        ? FontWeight.w700
                        : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  '${m.year} · ${m.currentKm} km · ${m.engineType}'
                  '${m.coolingType == 'liquid' ? ' · Radiador' : ''}',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: AppTheme.primary,
                        size: 20,
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showMotoForm(context, db, m);
                      },
                    ),
                    if (m.isActive)
                      const Icon(Icons.check_circle, color: AppTheme.primary)
                    else
                      TextButton(
                        onPressed: () async {
                          await db.setActiveMoto(m.id);
                          if (ctx.mounted) Navigator.pop(ctx);
                        },
                        child: const Text('Activar'),
                      ),
                  ],
                ),
                onLongPress: () async {
                  final confirm = await showDialog<bool>(
                    context: ctx,
                    builder: (_) => AlertDialog(
                      backgroundColor: AppTheme.surface,
                      title: const Text('Eliminar moto'),
                      content: Text('¿Eliminar ${m.brand} ${m.model}?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await db.deleteMoto(m.id);
                    await DriveBackupService.backupIfSignedIn(db);
                  }
                  if (ctx.mounted) Navigator.pop(ctx);
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add_circle, color: AppTheme.primary),
              title: const Text(
                'Agregar nueva moto',
                style: TextStyle(color: AppTheme.primary),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _showMotoForm(context, db, null);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMotoForm(
    BuildContext context,
    AppDatabase db,
    MotoProfileData? moto,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _MotoFormSheet(db: db, moto: moto),
    );
  }
}

// ─── Formulario de moto (StatefulWidget para manejar el estado local) ─────────

class _MotoFormSheet extends StatefulWidget {
  final AppDatabase db;
  final MotoProfileData? moto;
  const _MotoFormSheet({required this.db, required this.moto});

  @override
  State<_MotoFormSheet> createState() => _MotoFormSheetState();
}

class _MotoFormSheetState extends State<_MotoFormSheet> {
  late final TextEditingController brandCtrl;
  late final TextEditingController modelCtrl;
  late final TextEditingController yearCtrl;
  late final TextEditingController kmCtrl;
  late final TextEditingController plateCtrl;
  late final TextEditingController displacementCtrl;

  late String engineType;
  late String fuelSystem;
  late String coolingType;
  late String oilFilterType;
  late String transmissionType;
  late String rimType;
  late String? twoStrokeOilMethod;
  late String? oilType;
  late String? oilViscosity;
  late int? displacement;
  late double? tankCapacity;
  late final TextEditingController tankCapacityCtrl;

  bool get is2T => engineType == '2T';
  bool get isLiquidCooled => coolingType == 'liquid';

  @override
  void initState() {
    super.initState();
    final m = widget.moto;
    brandCtrl = TextEditingController(text: m?.brand ?? '');
    modelCtrl = TextEditingController(text: m?.model ?? '');
    yearCtrl = TextEditingController(text: m?.year.toString() ?? '');
    kmCtrl = TextEditingController(text: m?.currentKm.toString() ?? '');
    plateCtrl = TextEditingController(text: m?.plate ?? '');
    displacementCtrl = TextEditingController(
      text: m?.displacement?.toString() ?? '',
    );
    engineType = m?.engineType ?? '4T';
    fuelSystem = m?.fuelSystem ?? 'carb';
    coolingType = m?.coolingType ?? 'air';
    oilFilterType = m?.oilFilterType ?? 'replaceable';
    transmissionType = m?.transmissionType ?? 'chain';
    rimType = m?.rimType ?? 'alloy';
    twoStrokeOilMethod = m?.twoStrokeOilMethod;
    oilType = m?.oilType;
    oilViscosity = m?.oilViscosity;
    displacement = m?.displacement;
    tankCapacity = m?.tankCapacity;
    tankCapacityCtrl = TextEditingController(
      text: m?.tankCapacity != null
          ? m!.tankCapacity!.toStringAsFixed(
              m.tankCapacity! == m.tankCapacity!.floorToDouble() ? 0 : 1,
            )
          : '',
    );
  }

  @override
  void dispose() {
    brandCtrl.dispose();
    modelCtrl.dispose();
    yearCtrl.dispose();
    kmCtrl.dispose();
    plateCtrl.dispose();
    displacementCtrl.dispose();
    tankCapacityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.moto == null ? 'Nueva moto' : 'Editar moto',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),

            // Marca / Modelo
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: brandCtrl,
                    decoration: const InputDecoration(labelText: 'Marca'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: modelCtrl,
                    decoration: const InputDecoration(labelText: 'Modelo'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Año / Km
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: yearCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Año'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: kmCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Km actuales'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Cilindrada + Capacidad del tanque
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: displacementCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Cilindrada',
                      suffixText: 'cc',
                    ),
                    onChanged: (v) => displacement = int.tryParse(v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: tankCapacityCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Tanque',
                      suffixText: 'L',
                    ),
                    onChanged: (v) => tankCapacity = double.tryParse(v),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: plateCtrl,
                    decoration: const InputDecoration(labelText: 'Placa'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Tipo de motor ──
            _FormSectionLabel(label: 'Tipo de motor', icon: Icons.settings),
            const SizedBox(height: 10),
            _ToggleRow(
              options: const [
                _ToggleOption('4T', '4 Tiempos', Icons.opacity),
                _ToggleOption('2T', '2 Tiempos', Icons.flash_on),
              ],
              selected: engineType,
              onSelect: (v) => setState(() {
                engineType = v;
                if (v == '2T') {
                  oilType = null;
                  oilViscosity = null;
                  twoStrokeOilMethod ??= 'autolube';
                } else {
                  twoStrokeOilMethod = null;
                }
              }),
            ),
            const SizedBox(height: 16),

            // ── Sistema de combustible (solo 4T) ──
            if (!is2T) ...[
              _FormSectionLabel(
                label: 'Sistema de combustible',
                icon: Icons.local_gas_station,
              ),
              const SizedBox(height: 10),
              _ToggleRow(
                options: const [
                  _ToggleOption('carb', '🔩 Carburada', Icons.settings),
                  _ToggleOption(
                    'injection',
                    '💉 Inyección electrónica',
                    Icons.memory,
                  ),
                ],
                selected: fuelSystem,
                onSelect: (v) => setState(() => fuelSystem = v),
              ),
              const SizedBox(height: 16),
            ],

            // ── Tipo de transmisión ──
            _FormSectionLabel(
              label: 'Tipo de transmisión',
              icon: Icons.settings_input_component,
            ),
            const SizedBox(height: 10),
            _TransmissionSelector(
              selected: transmissionType,
              onSelect: (v) => setState(() => transmissionType = v),
            ),
            const SizedBox(height: 16),

            // ── Tipo de rines ──
            _FormSectionLabel(
              label: 'Tipo de rines',
              icon: Icons.circle_outlined,
            ),
            const SizedBox(height: 10),
            _RimTypeSelector(
              selected: rimType,
              onSelect: (v) => setState(() => rimType = v),
            ),
            const SizedBox(height: 16),

            // ── Refrigeración ──
            _FormSectionLabel(
              label: 'Refrigeración del motor',
              icon: Icons.thermostat,
            ),
            const SizedBox(height: 10),
            _ToggleRow(
              options: const [
                _ToggleOption('air', '💨 Por aire', Icons.air),
                _ToggleOption(
                  'liquid',
                  '🌡 Por líquido (radiador)',
                  Icons.water_drop,
                ),
              ],
              selected: coolingType,
              onSelect: (v) => setState(() => coolingType = v),
            ),
            const SizedBox(height: 16),

            // ── Opciones específicas 4T ──
            if (!is2T) ...[
              _FormSectionLabel(
                label: 'Filtro de aceite',
                icon: Icons.filter_alt,
              ),
              const SizedBox(height: 10),
              _ToggleRow(
                options: const [
                  _ToggleOption(
                    'replaceable',
                    '📄 Reemplazable',
                    Icons.swap_horiz,
                  ),
                  _ToggleOption(
                    'permanent',
                    '⚙️ Metálico permanente',
                    Icons.settings,
                  ),
                ],
                selected: oilFilterType,
                onSelect: (v) => setState(() => oilFilterType = v),
              ),
              const SizedBox(height: 16),

              _FormSectionLabel(label: 'Aceite del motor', icon: Icons.opacity),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: oilType,
                      hint: const Text('Tipo de aceite'),
                      decoration: const InputDecoration(),
                      dropdownColor: AppTheme.surface,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                      ),
                      items: AppConstants.oilTypes4T
                          .map(
                            (t) => DropdownMenuItem(value: t, child: Text(t)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => oilType = v),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: oilViscosity,
                      hint: const Text('Viscosidad'),
                      decoration: const InputDecoration(),
                      dropdownColor: AppTheme.surface,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                      ),
                      items: AppConstants.oilViscosities
                          .map(
                            (v) => DropdownMenuItem(value: v, child: Text(v)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => oilViscosity = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // ── Opciones específicas 2T ──
            if (is2T) ...[
              _FormSectionLabel(
                label: 'Método de lubricación 2T',
                icon: Icons.opacity,
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.amber.withValues(alpha: 0.3),
                  ),
                ),
                child: const Text(
                  'Los motores 2T no tienen cárter de aceite. La lubricación se hace mezclando aceite con la gasolina (premezclado) o mediante un sistema de inyección automática (autolube).',
                  style: TextStyle(color: Colors.amber, fontSize: 11),
                ),
              ),
              const SizedBox(height: 10),
              _TwoStrokeMethodSelector(
                selected: twoStrokeOilMethod,
                onSelect: (v) => setState(() => twoStrokeOilMethod = v),
              ),
              const SizedBox(height: 16),
            ],

            ElevatedButton(onPressed: _save, child: const Text('Guardar')),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (brandCtrl.text.isEmpty || modelCtrl.text.isEmpty) return;
    final db = widget.db;
    final moto = widget.moto;

    if (moto == null) {
      final existing = await db.getActiveMoto();
      final newId = await db.insertMoto(
        MotoProfileCompanion.insert(
          brand: brandCtrl.text,
          model: modelCtrl.text,
          year: int.tryParse(yearCtrl.text) ?? 2020,
          currentKm: int.tryParse(kmCtrl.text) ?? 0,
          plate: drift.Value(plateCtrl.text.isEmpty ? null : plateCtrl.text),
          displacement: drift.Value(displacement),
          tankCapacity: drift.Value(tankCapacity),
          engineType: drift.Value(engineType),
          fuelSystem: drift.Value(is2T ? 'carb' : fuelSystem),
          twoStrokeOilMethod: drift.Value(is2T ? twoStrokeOilMethod : null),
          coolingType: drift.Value(coolingType),
          oilType: drift.Value(is2T ? null : oilType),
          oilViscosity: drift.Value(is2T ? null : oilViscosity),
          oilFilterType: drift.Value(is2T ? 'none' : oilFilterType),
          transmissionType: drift.Value(transmissionType),
          rimType: drift.Value(rimType),
          isActive: drift.Value(existing == null),
          updatedAt: DateTime.now(),
        ),
      );
      if (existing == null) await db.setActiveMoto(newId);
      await DriveBackupService.backupIfSignedIn(db);
    } else {
      await db.updateMoto(
        moto.copyWith(
          brand: brandCtrl.text,
          model: modelCtrl.text,
          year: int.tryParse(yearCtrl.text) ?? moto.year,
          currentKm: int.tryParse(kmCtrl.text) ?? moto.currentKm,
          plate: drift.Value(plateCtrl.text.isEmpty ? null : plateCtrl.text),
          displacement: drift.Value(displacement),
          tankCapacity: drift.Value(tankCapacity),
          engineType: engineType,
          fuelSystem: is2T ? 'carb' : fuelSystem,
          twoStrokeOilMethod: drift.Value(is2T ? twoStrokeOilMethod : null),
          coolingType: coolingType,
          oilType: drift.Value(is2T ? null : oilType),
          oilViscosity: drift.Value(is2T ? null : oilViscosity),
          oilFilterType: is2T ? 'none' : oilFilterType,
          transmissionType: transmissionType,
          rimType: rimType,
          updatedAt: DateTime.now(),
        ),
      );
      await DriveBackupService.backupIfSignedIn(db);
    }
    if (mounted) Navigator.pop(context);
  }
}

// ─── Selector de tipo de transmisión ─────────────────────────────────────────

class _TransmissionSelector extends StatelessWidget {
  final String selected;
  final void Function(String) onSelect;
  const _TransmissionSelector({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: AppConstants.transmissionTypes.map((t) {
        final value = t['value']!;
        final isSelected = selected == value;
        return GestureDetector(
          onTap: () => onSelect(value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primary.withValues(alpha: 0.12)
                  : AppTheme.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? AppTheme.primary : AppTheme.cardBorder,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Text(t['emoji']!, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t['label']!,
                        style: TextStyle(
                          color: isSelected
                              ? AppTheme.primary
                              : AppTheme.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        t['desc']!,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: AppTheme.primary,
                    size: 18,
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Selector de tipo de rin ──────────────────────────────────────────────────

class _RimTypeSelector extends StatelessWidget {
  final String selected;
  final void Function(String) onSelect;
  const _RimTypeSelector({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: AppConstants.rimTypes.map((r) {
        final value = r['value'] as String;
        final isSelected = selected == value;
        return GestureDetector(
          onTap: () => onSelect(value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primary.withValues(alpha: 0.12)
                  : AppTheme.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? AppTheme.primary : AppTheme.cardBorder,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Text(
                  r['emoji'] as String,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r['label'] as String,
                        style: TextStyle(
                          color: isSelected
                              ? AppTheme.primary
                              : AppTheme.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        r['desc'] as String,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: AppTheme.primary,
                    size: 18,
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Selector de método 2T ────────────────────────────────────────────────────

class _TwoStrokeMethodSelector extends StatelessWidget {
  final String? selected;
  final void Function(String) onSelect;
  const _TwoStrokeMethodSelector({
    required this.selected,
    required this.onSelect,
  });

  static const _methods = [
    (
      'autolube',
      '🛢 Inyección / Autolube',
      'Depósito de aceite separado.\nEl sistema lo inyecta automáticamente.',
    ),
    (
      'premix',
      '⛽ Premezclado',
      'El aceite se mezcla directo en el tanque con la gasolina.',
    ),
    (
      'none',
      '🚫 Sin aceite separado',
      'No usa aceite en el motor\n(ej. scooters 2T sin autolube).',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _methods.map((m) {
        final isSelected = selected == m.$1;
        return GestureDetector(
          onTap: () => onSelect(m.$1),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primary.withValues(alpha: 0.12)
                  : AppTheme.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? AppTheme.primary : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.$2,
                        style: TextStyle(
                          color: isSelected
                              ? AppTheme.primary
                              : AppTheme.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        m.$3,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: AppTheme.primary,
                    size: 18,
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Widgets de formulario reutilizables ──────────────────────────────────────

class _FormSectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  const _FormSectionLabel({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.textSecondary, size: 16),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _ToggleOption {
  final String value;
  final String label;
  final IconData icon;
  const _ToggleOption(this.value, this.label, this.icon);
}

class _ToggleRow extends StatelessWidget {
  final List<_ToggleOption> options;
  final String selected;
  final void Function(String) onSelect;
  const _ToggleRow({
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options.map((o) {
        final isSelected = selected == o.value;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(o.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primary.withValues(alpha: 0.15)
                    : AppTheme.card,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? AppTheme.primary : AppTheme.cardBorder,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Text(
                o.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _MotoBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _MotoBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xCC111117),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.32)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─── Sin moto configurada ─────────────────────────────────────────────────────

class _NoMotoPrompt extends StatelessWidget {
  final AppDatabase db;
  const _NoMotoPrompt({required this.db});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.motorcycle,
              size: 72,
              color: AppTheme.textSecondary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            const Text(
              'Agrega tu primera moto',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text(
              'Toca el ícono + en la tarjeta de arriba',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Widgets de resumen ───────────────────────────────────────────────────────

class _LastKmL extends StatelessWidget {
  final AppDatabase db;
  final int motoId;
  const _LastKmL({required this.db, required this.motoId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FuelRecord>>(
      stream: db.watchFuelRecords(motoId),
      builder: (context, snap) {
        final records = [...(snap.data ?? <FuelRecord>[])]
          ..sort((a, b) => a.odometerKm.compareTo(b.odometerKm));

        double? latestKml;
        for (int i = records.length - 1; i > 0; i--) {
          final prev = records[i - 1];
          final curr = records[i];
          if (!prev.isFull || !curr.isFull) continue;
          final kmDiff = curr.odometerKm - prev.odometerKm;
          if (kmDiff <= 0 || curr.liters <= 0) continue;
          final kml = kmDiff / curr.liters;
          if (kml < 3 || kml > 60) continue;
          latestKml = kml;
          break;
        }

        if (latestKml == null) {
          return const Text(
            '—',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          );
        }
        return Text(
          '${latestKml.toStringAsFixed(1)} km/L',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        );
      },
    );
  }
}

class _NextService extends StatelessWidget {
  final AppDatabase db;
  final int motoId;
  const _NextService({required this.db, required this.motoId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.watchMaintenanceRecords(motoId),
      builder: (context, snap) {
        final records = snap.data ?? [];
        final upcoming = records
            .where(
              (r) =>
                  r.nextServiceDate != null &&
                  r.nextServiceDate!.isAfter(DateTime.now()),
            )
            .toList();
        if (upcoming.isEmpty) {
          return const Text(
            'Sin próx.',
            style: TextStyle(fontSize: 14, color: Colors.white),
          );
        }
        upcoming.sort(
          (a, b) => a.nextServiceDate!.compareTo(b.nextServiceDate!),
        );
        final days = upcoming.first.nextServiceDate!
            .difference(DateTime.now())
            .inDays;
        return Text(
          'En $days días',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        );
      },
    );
  }
}

class _PartsAlertCard extends StatelessWidget {
  final AppDatabase db;
  final MotoProfileData moto;
  const _PartsAlertCard({required this.db, required this.moto});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.watchParts(moto.id),
      builder: (context, snap) {
        final parts = snap.data ?? [];
        final currentKm = moto.currentKm;

        final alerts = parts.where((p) {
          if (p.filterType == 'permanent') return false;
          final remaining = (p.lastChangedKm + p.intervalKm) - currentKm;
          return remaining <= 500;
        }).toList();

        if (alerts.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.success.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: AppTheme.success),
                const SizedBox(width: 10),
                const Text(
                  'Todo en orden — sin alertas de refacciones',
                  style: TextStyle(color: AppTheme.success),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(title: 'Alertas de refacciones'),
            const SizedBox(height: 8),
            ...alerts.map((p) {
              final remaining = (p.lastChangedKm + p.intervalKm) - currentKm;
              final isOverdue = remaining <= 0;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: (isOverdue ? AppTheme.danger : AppTheme.warning)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: (isOverdue ? AppTheme.danger : AppTheme.warning)
                        .withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: isOverdue ? AppTheme.danger : AppTheme.warning,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        p.name,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      isOverdue ? 'Vencida' : 'En $remaining km',
                      style: TextStyle(
                        color: isOverdue ? AppTheme.danger : AppTheme.warning,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Widget valueWidget;
  const _StatCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.valueWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, color: color, size: 15),
              ),
            ],
          ),
          const SizedBox(height: 12),
          valueWidget,
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
