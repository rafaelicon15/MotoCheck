import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/database/app_database.dart';
import '../../../services/drive_backup_service.dart';
import '../../../shared/providers/database_provider.dart';
import '../../../shared/providers/active_moto_provider.dart';
import '../../../shared/providers/settings_provider.dart';

class MaintenanceScreen extends ConsumerWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    final moto = ref.watch(activeMotoProvider).valueOrNull;
    final currency = ref.watch(currencyCodeProvider).valueOrNull ?? kDefaultCurrency;
    final engineType = moto?.engineType ?? '4T';
    final fuelSystem = moto?.fuelSystem ?? 'carb';
    final transmissionType = moto?.transmissionType ?? 'chain';

    return Scaffold(
      appBar: AppBar(title: const Text('Mantenimientos')),
      body: StreamBuilder<List<MaintenanceRecord>>(
        stream: db.watchMaintenanceRecords(moto?.id),
        builder: (context, snap) {
          final records = snap.data ?? [];
          if (records.isEmpty) return _EmptyState();
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (_, i) =>
                _MaintenanceCard(record: records[i], db: db, currency: currency),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: AppTheme.surface,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          builder: (_) => _AddMaintenanceSheet(
              db: db, motoId: moto?.id, currency: currency,
              engineType: engineType, fuelSystem: fuelSystem,
              transmissionType: transmissionType),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Agregar servicio'),
      ),
    );
  }
}

// ─── Formulario de mantenimiento ──────────────────────────────────────────────

class _AddMaintenanceSheet extends StatefulWidget {
  final AppDatabase db;
  final int? motoId;
  final String currency;
  final String engineType;
  final String fuelSystem;
  final String transmissionType;
  const _AddMaintenanceSheet(
      {required this.db,
      required this.motoId,
      required this.currency,
      required this.engineType,
      required this.fuelSystem,
      required this.transmissionType});

  @override
  State<_AddMaintenanceSheet> createState() => _AddMaintenanceSheetState();
}

class _AddMaintenanceSheetState extends State<_AddMaintenanceSheet> {
  final _descCtrl = TextEditingController();
  final _kmCtrl = TextEditingController();
  final _costCtrl = TextEditingController();
  final _workshopCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _nextKmCtrl = TextEditingController();

  final Set<String> _selectedItems = {};
  DateTime _date = DateTime.now();
  DateTime? _nextDate;
  String? _oilType;
  String? _oilViscosity;

  bool get _hasOilChange =>
      _selectedItems.contains('Cambio de aceite') && widget.engineType == '4T';
  bool get _isEmpty => _selectedItems.isEmpty;

  @override
  void dispose() {
    _descCtrl.dispose();
    _kmCtrl.dispose();
    _costCtrl.dispose();
    _workshopCtrl.dispose();
    _notesCtrl.dispose();
    _nextKmCtrl.dispose();
    super.dispose();
  }

  void _toggle(String item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 20, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [
              const Icon(Icons.build, color: AppTheme.maintenance),
              const SizedBox(width: 8),
              const Text('Nuevo servicio',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 16),

            // Fecha
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2015),
                    lastDate: DateTime.now());
                if (picked != null) setState(() => _date = picked);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                    color: AppTheme.card, borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  const Icon(Icons.calendar_today,
                      color: AppTheme.textSecondary, size: 18),
                  const SizedBox(width: 10),
                  Text(DateFormat('dd/MM/yyyy').format(_date),
                      style: const TextStyle(color: AppTheme.textPrimary)),
                ]),
              ),
            ),
            const SizedBox(height: 16),

            // ── Selección múltiple de items ──
            const Text('¿Qué se realizó?',
                style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5)),
            const SizedBox(height: 8),

            // Chips seleccionados (resumen)
            if (_selectedItems.isNotEmpty) ...[
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: _selectedItems.map((item) => Chip(
                  label: Text(item,
                      style: const TextStyle(fontSize: 11, color: AppTheme.primary)),
                  backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
                  side: BorderSide(color: AppTheme.primary.withValues(alpha: 0.4)),
                  deleteIconColor: AppTheme.primary,
                  onDeleted: () => _toggle(item),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                )).toList(),
              ),
              const SizedBox(height: 12),
            ],

            // Categorías expandibles
            ..._buildCategories(),

            const SizedBox(height: 16),

            // Descripción
            TextField(
              controller: _descCtrl,
              decoration: const InputDecoration(
                  labelText: 'Descripción / Notas del servicio (opcional)'),
              maxLines: 2,
            ),
            const SizedBox(height: 12),

            // Km y Costo
            Row(children: [
              Expanded(child: TextField(
                controller: _kmCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Km al servicio', suffixText: 'km'),
              )),
              const SizedBox(width: 12),
              Expanded(child: TextField(
                controller: _costCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Costo',
                  prefixText: '${currencySymbol(widget.currency)} ',
                ),
              )),
            ]),
            const SizedBox(height: 12),

            TextField(
              controller: _workshopCtrl,
              decoration: const InputDecoration(labelText: 'Taller / Mecánico (opcional)'),
            ),

            // ── Datos de aceite (solo 4T + "Cambio de aceite" seleccionado) ──
            if (_hasOilChange) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.fuel.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.fuel.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.opacity, color: AppTheme.fuel, size: 16),
                      const SizedBox(width: 6),
                      const Text('Datos del aceite',
                          style: TextStyle(
                              color: AppTheme.fuel,
                              fontWeight: FontWeight.w700,
                              fontSize: 13)),
                    ]),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _oilType,
                      hint: const Text('Tipo de aceite'),
                      decoration: const InputDecoration(),
                      dropdownColor: AppTheme.surface,
                      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                      items: AppConstants.oilTypes4T
                          .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                          .toList(),
                      onChanged: (v) => setState(() => _oilType = v),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: _oilViscosity,
                      hint: const Text('Viscosidad'),
                      decoration: const InputDecoration(),
                      dropdownColor: AppTheme.surface,
                      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13),
                      items: AppConstants.oilViscosities
                          .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                          .toList(),
                      onChanged: (v) => setState(() => _oilViscosity = v),
                    ),
                  ],
                ),
              ),
            ],

            // Próximo servicio
            const SizedBox(height: 16),
            const Text('Próximo servicio (opcional)',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 90)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 730)));
                    if (picked != null) setState(() => _nextDate = picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                        color: AppTheme.card, borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      _nextDate != null
                          ? DateFormat('dd/MM/yyyy').format(_nextDate!)
                          : 'Fecha',
                      style: TextStyle(
                          color: _nextDate != null
                              ? AppTheme.textPrimary
                              : AppTheme.textSecondary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: TextField(
                controller: _nextKmCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'O en km'),
              )),
            ]),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _isEmpty ? null : _save,
              child: const Text('Guardar servicio'),
            ),
            if (_isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text('Selecciona al menos un ítem realizado',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                    textAlign: TextAlign.center),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCategories() {
    final is2T = widget.engineType == '2T';
    final isCarb = widget.fuelSystem == 'carb';
    final isChain = widget.transmissionType == 'chain';
    final isBelt = widget.transmissionType == 'belt';
    final result = <Widget>[];

    for (final cat in AppConstants.maintenanceCategories.entries) {
      var items = cat.value.toList();

      // Para 2T: quitar cambio de aceite, filtro de aceite y calibración de válvulas
      if (is2T) {
        items = items.where((i) =>
            i != 'Cambio de aceite' &&
            i != 'Cambio de filtro de aceite' &&
            !i.startsWith('Calibración de válvulas')).toList();
        if (cat.key == 'Distribución / tren de válvulas') {
          items = const [];
        }
      }

      // Para transmisión no-cadena: quitar lubricación y limpieza de cadena
      if (cat.key == 'Lubricación' && !isChain) {
        items = items.where((i) =>
            i != 'Lubricación de cadena' &&
            i != 'Limpieza de cadena').toList();
      }

      // Para CVT/automáticas: quitar guaya de clutch (no tienen palanca de clutch)
      if (cat.key == 'Lubricación' && isBelt) {
        items = items.where((i) => i != 'Guaya / Cable de clutch').toList();
      }

      if (items.isEmpty) continue;

      result.add(_CategorySection(
        label: cat.key,
        items: items,
        selectedItems: _selectedItems,
        onToggle: _toggle,
      ));
    }

    // Categoría de transmisión dinámica
    final transmItems = isChain
        ? AppConstants.chainTransmissionItems
        : widget.transmissionType == 'shaft'
            ? AppConstants.shaftTransmissionItems
            : AppConstants.beltCvtTransmissionItems;
    final transmLabel = isChain
        ? 'Transmisión (cadena)'
        : widget.transmissionType == 'shaft'
            ? 'Cardan'
            : 'Transmisión CVT';

    result.add(_CategorySection(
      label: transmLabel,
      items: transmItems,
      selectedItems: _selectedItems,
      onToggle: _toggle,
    ));

    // Categoría dinámica según sistema de combustible
    final fuelItems = isCarb
        ? AppConstants.carbMaintenanceItems
        : AppConstants.injectionMaintenanceItems;
    final fuelLabel = isCarb ? 'Carburador' : 'Inyección electrónica';

    result.add(_CategorySection(
      label: fuelLabel,
      items: fuelItems,
      selectedItems: _selectedItems,
      onToggle: _toggle,
    ));

    return result;
  }

  Future<void> _save() async {
    if (_selectedItems.isEmpty) return;
    final odometerKm = int.tryParse(_kmCtrl.text) ?? 0;
    final primaryType =
        _selectedItems.length == 1 ? _selectedItems.first : 'Mantenimiento general';
    final itemsStr = _selectedItems.join(',');
    final desc = _descCtrl.text.isEmpty
        ? _selectedItems.join(' · ')
        : _descCtrl.text;

    await widget.db.insertMaintenance(MaintenanceRecordsCompanion.insert(
      motoId: drift.Value(widget.motoId),
      date: _date,
      odometerKm: odometerKm,
      type: primaryType,
      description: desc,
      cost: drift.Value(double.tryParse(_costCtrl.text)),
      workshop:
          drift.Value(_workshopCtrl.text.isEmpty ? null : _workshopCtrl.text),
      nextServiceDate: drift.Value(_nextDate),
      nextServiceKm: drift.Value(int.tryParse(_nextKmCtrl.text)),
      notes: drift.Value(_notesCtrl.text.isEmpty ? null : _notesCtrl.text),
      oilType: drift.Value(_hasOilChange ? _oilType : null),
      oilViscosity: drift.Value(_hasOilChange ? _oilViscosity : null),
      maintenanceItems: drift.Value(itemsStr),
    ));
    await widget.db.markPartsServicedFromMaintenance(
      motoId: widget.motoId,
      maintenanceItems: _selectedItems,
      odometerKm: odometerKm,
      changedAt: _date,
      cost: double.tryParse(_costCtrl.text),
    );
    await widget.db.updateMotoCurrentKmIfGreater(widget.motoId, odometerKm);
    await DriveBackupService.backupIfSignedIn(widget.db);
    if (mounted) Navigator.pop(context);
  }
}

// ─── Sección de categoría (expandible) ───────────────────────────────────────

class _CategorySection extends StatefulWidget {
  final String label;
  final List<String> items;
  final Set<String> selectedItems;
  final void Function(String) onToggle;
  const _CategorySection({
    required this.label,
    required this.items,
    required this.selectedItems,
    required this.onToggle,
  });

  @override
  State<_CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<_CategorySection> {
  bool _expanded = false;
  int get _selectedCount =>
      widget.items.where((i) => widget.selectedItems.contains(i)).length;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(10),
        border: _selectedCount > 0
            ? Border.all(color: AppTheme.maintenance.withValues(alpha: 0.4))
            : null,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(children: [
                Expanded(
                  child: Text(widget.label,
                      style: TextStyle(
                        color: _selectedCount > 0
                            ? AppTheme.maintenance
                            : AppTheme.textPrimary,
                        fontWeight: _selectedCount > 0
                            ? FontWeight.w700
                            : FontWeight.normal,
                        fontSize: 13,
                      )),
                ),
                if (_selectedCount > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.maintenance.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('$_selectedCount',
                        style: const TextStyle(
                            color: AppTheme.maintenance,
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                  ),
                const SizedBox(width: 6),
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: AppTheme.textSecondary,
                  size: 18,
                ),
              ]),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: widget.items.map((item) {
                  final selected = widget.selectedItems.contains(item);
                  return FilterChip(
                    label: Text(item,
                        style: TextStyle(
                          fontSize: 12,
                          color: selected
                              ? AppTheme.maintenance
                              : AppTheme.textSecondary,
                        )),
                    selected: selected,
                    onSelected: (_) => widget.onToggle(item),
                    selectedColor: AppTheme.maintenance.withValues(alpha: 0.15),
                    checkmarkColor: AppTheme.maintenance,
                    backgroundColor: AppTheme.surface,
                    side: BorderSide(
                        color: selected
                            ? AppTheme.maintenance
                            : Colors.white12),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Tarjeta de mantenimiento ─────────────────────────────────────────────────

class _MaintenanceCard extends StatelessWidget {
  final MaintenanceRecord record;
  final AppDatabase db;
  final String currency;
  const _MaintenanceCard(
      {required this.record, required this.db, required this.currency});

  List<String> get _items {
    if (record.maintenanceItems != null && record.maintenanceItems!.isNotEmpty) {
      return record.maintenanceItems!.split(',');
    }
    return [record.type];
  }

  @override
  Widget build(BuildContext context) {
    final hasUpcoming = record.nextServiceDate != null &&
        record.nextServiceDate!.isAfter(DateTime.now());
    final daysLeft =
        hasUpcoming ? record.nextServiceDate!.difference(DateTime.now()).inDays : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: hasUpcoming && daysLeft! <= 7
            ? Border.all(color: AppTheme.warning.withValues(alpha: 0.5))
            : Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Cabecera
        Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: AppTheme.maintenance.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.build, color: AppTheme.maintenance, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              _items.length == 1 ? _items.first : 'Mantenimiento general',
              style: const TextStyle(
                  color: AppTheme.textPrimary, fontWeight: FontWeight.w600),
            ),
            if (record.description.isNotEmpty &&
                record.description != _items.join(' · '))
              Text(record.description,
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 11)),
          ])),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppTheme.danger, size: 20),
            onPressed: () async {
              await db.deleteMaintenance(record.id);
              await DriveBackupService.backupIfSignedIn(db);
            },
          ),
        ]),

        // Items como chips (si hay más de uno)
        if (_items.length > 1) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: _items
                .map((item) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.maintenance.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(item,
                          style: const TextStyle(
                              color: AppTheme.maintenance,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ))
                .toList(),
          ),
        ],

        // Badge de aceite
        if (record.oilType != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.fuel.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(children: [
              const Icon(Icons.opacity, size: 14, color: AppTheme.fuel),
              const SizedBox(width: 6),
              Text(
                '${record.oilType}${record.oilViscosity != null ? ' · ${record.oilViscosity}' : ''}',
                style: const TextStyle(
                    color: AppTheme.fuel, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ]),
          ),
        ],

        const SizedBox(height: 8),
        Row(children: [
          const Icon(Icons.calendar_today, size: 13, color: AppTheme.textSecondary),
          const SizedBox(width: 4),
          Text(DateFormat('dd MMM yyyy').format(record.date),
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(width: 12),
          const Icon(Icons.speed, size: 13, color: AppTheme.textSecondary),
          const SizedBox(width: 4),
          Text('${record.odometerKm} km',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          if (record.cost != null) ...[
            const Spacer(),
            Text('${currencySymbol(currency)} ${record.cost!.toStringAsFixed(0)}',
                style: const TextStyle(
                    color: AppTheme.success,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
          ],
        ]),

        if (record.workshop != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(children: [
              const Icon(Icons.store, size: 13, color: AppTheme.textSecondary),
              const SizedBox(width: 4),
              Text(record.workshop!,
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            ]),
          ),

        if (hasUpcoming) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: (daysLeft! <= 7 ? AppTheme.warning : AppTheme.maintenance)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(children: [
              Icon(Icons.alarm,
                  size: 14,
                  color: daysLeft <= 7 ? AppTheme.warning : AppTheme.maintenance),
              const SizedBox(width: 6),
              Text(
                'Próximo en $daysLeft días · ${DateFormat('dd MMM').format(record.nextServiceDate!)}',
                style: TextStyle(
                    color: daysLeft <= 7 ? AppTheme.warning : AppTheme.maintenance,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ]),
          ),
        ],
      ]),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(children: [
          Icon(Icons.build_outlined,
              size: 64, color: AppTheme.textSecondary.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          const Text('Sin servicios registrados',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
          const SizedBox(height: 8),
          const Text('Registra el historial de mantenimiento de tu moto',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}
