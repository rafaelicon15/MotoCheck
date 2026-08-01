import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/database/app_database.dart';
import '../../../services/drive_backup_service.dart';
import '../../../shared/providers/database_provider.dart';
import '../../../shared/providers/active_moto_provider.dart';
import '../../../shared/providers/settings_provider.dart';

// Umbrales de rendimiento realista para motos
const _kMaxKml = 60.0;
const _kMinKml = 3.0;

bool _isKmlValid(double kml) => kml >= _kMinKml && kml <= _kMaxKml;

class FuelScreen extends ConsumerStatefulWidget {
  const FuelScreen({super.key});

  @override
  ConsumerState<FuelScreen> createState() => _FuelScreenState();
}

class _FuelScreenState extends ConsumerState<FuelScreen> {
  // null = todos, 'Regular', 'Premium', 'booster'
  String? _activeFilter;

  List<FuelRecord> _applyFilter(List<FuelRecord> records) {
    if (_activeFilter == null) return records;
    if (_activeFilter == 'booster') {
      return records.where((r) => r.usedOctaneBooster).toList();
    }
    return records
        .where((r) => r.fuelType == _activeFilter && !r.usedOctaneBooster)
        .toList();
  }

  Set<String> _availableFilters(List<FuelRecord> records) {
    final filters = <String>{};
    for (final r in records) {
      if (r.usedOctaneBooster) {
        filters.add('booster');
      } else {
        filters.add(r.fuelType);
      }
    }
    return filters;
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    final moto = ref.watch(activeMotoProvider).valueOrNull;
    final currency =
        ref.watch(currencyCodeProvider).valueOrNull ?? kDefaultCurrency;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Combustible'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(currencySymbol(currency),
                  style: const TextStyle(
                      color: AppTheme.fuel,
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<FuelRecord>>(
        stream: db.watchFuelRecords(moto?.id),
        builder: (context, snap) {
          final records = snap.data ?? [];
          final availableFilters = _availableFilters(records);
          // Si el filtro activo ya no tiene registros, limpiarlo
          if (_activeFilter != null &&
              !availableFilters.contains(_activeFilter)) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => setState(() => _activeFilter = null));
          }
          final filtered = _applyFilter(records);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (records.length >= 2) ...[
                  _EfficiencyChart(records: records),
                  const SizedBox(height: 16),
                  _SummaryRow(
                      records: records, tankCapacity: moto?.tankCapacity),
                  const SizedBox(height: 16),
                  _OctaneComparisonCard(records: records),
                  const SizedBox(height: 16),
                ],
                Row(children: [
                  const Text('Historial de cargas',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary)),
                  if (filtered.length != records.length) ...[
                    const SizedBox(width: 8),
                    Text('(${filtered.length})',
                        style: const TextStyle(
                            fontSize: 13, color: AppTheme.textSecondary)),
                  ],
                ]),
                if (availableFilters.length >= 2) ...[
                  const SizedBox(height: 10),
                  _FuelFilterBar(
                    available: availableFilters,
                    active: _activeFilter,
                    onSelect: (f) =>
                        setState(() => _activeFilter = _activeFilter == f ? null : f),
                  ),
                ],
                const SizedBox(height: 12),
                if (records.isEmpty)
                  _EmptyState()
                else if (filtered.isEmpty)
                  _FilterEmptyState(filter: _activeFilter!)
                else
                  ...filtered.map((r) => _FuelCard(
                      record: r,
                      db: db,
                      allRecords: records,
                      currency: currency)),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final db2 = ref.read(databaseProvider);
          final moto2 = ref.read(activeMotoProvider).valueOrNull;
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: AppTheme.surface,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            builder: (_) =>
                _AddFuelSheet(db: db2, motoId: moto2?.id, currency: currency),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Registrar carga'),
      ),
    );
  }
}

// ─── Barra de filtros ─────────────────────────────────────────────────────────

class _FuelFilterBar extends StatelessWidget {
  final Set<String> available;
  final String? active;
  final void Function(String) onSelect;

  const _FuelFilterBar(
      {required this.available,
      required this.active,
      required this.onSelect});

  String _label(String key) {
    switch (key) {
      case 'Regular':
        return 'Regular';
      case 'Premium':
        return 'Premium';
      case 'booster':
        return '+Octanaje';
      default:
        return key;
    }
  }

  Color _color(String key) {
    switch (key) {
      case 'Premium':
        return AppTheme.warning;
      case 'booster':
        return AppTheme.parts;
      default:
        return AppTheme.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    const order = ['Regular', 'Premium', 'booster'];
    final sorted = order.where(available.contains).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // "Todos" chip
          _FilterChip(
            label: 'Todos',
            color: AppTheme.fuel,
            isActive: active == null,
            onTap: () {
              if (active != null) onSelect(active!); // deselect
            },
          ),
          const SizedBox(width: 8),
          ...sorted.map((key) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _FilterChip(
                  label: _label(key),
                  color: _color(key),
                  isActive: active == key,
                  onTap: () => onSelect(key),
                ),
              )),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;
  const _FilterChip(
      {required this.label,
      required this.color,
      required this.isActive,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.2) : AppTheme.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? color : Colors.white10,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? color : AppTheme.textSecondary,
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _FilterEmptyState extends StatelessWidget {
  final String filter;
  const _FilterEmptyState({required this.filter});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Text(
          'Sin registros de este tipo',
          style: TextStyle(color: AppTheme.textSecondary.withValues(alpha: 0.7)),
        ),
      ),
    );
  }
}

// ─── Formulario nueva carga ───────────────────────────────────────────────────

class _AddFuelSheet extends StatefulWidget {
  final AppDatabase db;
  final int? motoId;
  final String currency;
  const _AddFuelSheet({required this.db, required this.motoId, required this.currency});

  @override
  State<_AddFuelSheet> createState() => _AddFuelSheetState();
}

class _AddFuelSheetState extends State<_AddFuelSheet> {
  final _litersCtrl = TextEditingController();
  final _kmCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _octaneBrandCtrl = TextEditingController();

  String _fuelType = 'Regular';
  bool _usedOctaneBooster = false;
  bool _isFull = true;
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _litersCtrl.dispose();
    _kmCtrl.dispose();
    _priceCtrl.dispose();
    _notesCtrl.dispose();
    _octaneBrandCtrl.dispose();
    super.dispose();
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
              const Icon(Icons.local_gas_station, color: AppTheme.fuel),
              const SizedBox(width: 8),
              const Text('Nueva carga', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 20),

            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now());
                if (picked != null) setState(() => _date = picked);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  const Icon(Icons.calendar_today, color: AppTheme.textSecondary, size: 18),
                  const SizedBox(width: 10),
                  Text(DateFormat('dd/MM/yyyy').format(_date),
                      style: const TextStyle(color: AppTheme.textPrimary)),
                ]),
              ),
            ),
            const SizedBox(height: 12),

            Row(children: [
              Expanded(child: TextField(
                controller: _litersCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Litros', suffixText: 'L'),
              )),
              const SizedBox(width: 12),
              Expanded(child: TextField(
                controller: _kmCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Odómetro', suffixText: 'km'),
              )),
            ]),
            const SizedBox(height: 12),

            TextField(
              controller: _priceCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Precio por litro (opcional)',
                prefixText: '${currencySymbol(widget.currency)} ',
              ),
            ),
            const SizedBox(height: 16),

            const Text('Tipo de gasolina', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
            const SizedBox(height: 8),
            Row(
              children: AppConstants.fuelTypes.map((type) {
                final selected = _fuelType == type;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _fuelType = type),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selected ? AppTheme.fuel.withValues(alpha: 0.2) : AppTheme.card,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: selected ? AppTheme.fuel : Colors.transparent, width: 1.5),
                      ),
                      child: Text(type,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: selected ? AppTheme.fuel : AppTheme.textSecondary,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.normal)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // ─── Llenado completo ─────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                const Icon(Icons.local_gas_station_outlined,
                    color: AppTheme.textSecondary, size: 18),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Llené el tanque completo',
                        style: TextStyle(color: AppTheme.textPrimary)),
                    Text('Necesario para calcular km/L',
                        style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                  ]),
                ),
                Switch(
                  value: _isFull,
                  onChanged: (v) => setState(() => _isFull = v),
                  activeThumbColor: AppTheme.fuel,
                ),
              ]),
            ),
            if (!_isFull) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.warning.withValues(alpha: 0.25)),
                ),
                child: const Row(children: [
                  Icon(Icons.info_outline, color: AppTheme.warning, size: 14),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Este registro no se usará para calcular rendimiento.',
                      style: TextStyle(color: AppTheme.warning, fontSize: 11),
                    ),
                  ),
                ]),
              ),
            ],
            const SizedBox(height: 12),

            // ─── Elevador de octanaje ─────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                const Icon(Icons.science_outlined, color: AppTheme.textSecondary, size: 18),
                const SizedBox(width: 10),
                const Expanded(child: Text('Elevador de octanaje', style: TextStyle(color: AppTheme.textPrimary))),
                Switch(
                  value: _usedOctaneBooster,
                  onChanged: (v) => setState(() => _usedOctaneBooster = v),
                  activeThumbColor: AppTheme.fuel,
                ),
              ]),
            ),

            if (_usedOctaneBooster) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _octaneBrandCtrl,
                decoration: const InputDecoration(
                  labelText: 'Marca del elevador',
                  hintText: 'ej: STP, Rislone, Lucas, BG 44K...',
                ),
              ),
            ],
            const SizedBox(height: 12),

            TextField(controller: _notesCtrl, decoration: const InputDecoration(labelText: 'Notas (opcional)')),
            const SizedBox(height: 20),

            ElevatedButton(onPressed: _save, child: const Text('Guardar carga')),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final liters = double.tryParse(_litersCtrl.text);
    final km = int.tryParse(_kmCtrl.text);
    if (liters == null || km == null) return;

    await widget.db.insertFuelRecord(FuelRecordsCompanion.insert(
      motoId: drift.Value(widget.motoId),
      date: _date,
      liters: liters,
      odometerKm: km,
      fuelType: _fuelType,
      pricePerLiter: drift.Value(double.tryParse(_priceCtrl.text)),
      usedOctaneBooster: drift.Value(_usedOctaneBooster),
      octaneBrand: drift.Value(_usedOctaneBooster && _octaneBrandCtrl.text.isNotEmpty
          ? _octaneBrandCtrl.text.trim()
          : null),
      notes: drift.Value(_notesCtrl.text.isEmpty ? null : _notesCtrl.text),
      isFull: drift.Value(_isFull),
    ));
    await widget.db.updateMotoCurrentKmIfGreater(widget.motoId, km);
    await DriveBackupService.backupIfSignedIn(widget.db);

    if (mounted) Navigator.pop(context);
  }
}

// ─── Comparativa elevadores de octanaje ──────────────────────────────────────

class _OctaneComparisonCard extends StatelessWidget {
  final List<FuelRecord> records;
  const _OctaneComparisonCard({required this.records});

  Map<String, List<double>> get _kmlByBooster {
    final sorted = [...records]..sort((a, b) => a.odometerKm.compareTo(b.odometerKm));
    final Map<String, List<double>> result = {};

    for (int i = 1; i < sorted.length; i++) {
      final prev = sorted[i - 1];
      final curr = sorted[i];
      if (!prev.isFull || !curr.isFull) continue; // solo llenados completos
      final kmDiff = curr.odometerKm - prev.odometerKm;
      if (kmDiff <= 0 || curr.liters <= 0) continue;
      final kml = kmDiff / curr.liters;
      if (!_isKmlValid(kml)) continue; // excluir anomalías
      final key = prev.usedOctaneBooster && prev.octaneBrand != null
          ? '+ ${prev.octaneBrand}'
          : prev.fuelType;
      result.putIfAbsent(key, () => []).add(kml);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final data = _kmlByBooster;
    if (data.length < 2) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.parts.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.science, color: AppTheme.parts, size: 18),
            const SizedBox(width: 8),
            const Text('Comparativa de rendimiento',
                style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 12),
          ...data.entries.map((e) {
            final avg = e.value.reduce((a, b) => a + b) / e.value.length;
            final max = data.values
                .map((v) => v.reduce((a, b) => a + b) / v.length)
                .reduce((a, b) => a > b ? a : b);
            final pct = avg / max;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                      child: Text(e.key,
                          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13)),
                    ),
                    Text('${avg.toStringAsFixed(1)} km/L',
                        style: const TextStyle(
                            color: AppTheme.parts, fontWeight: FontWeight.w700, fontSize: 13)),
                    Text(' (${e.value.length} cargas)',
                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                  ]),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct,
                      backgroundColor: Colors.white10,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.parts),
                      minHeight: 5,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─── Gráfica de eficiencia ────────────────────────────────────────────────────

class _EfficiencyChart extends StatelessWidget {
  final List<FuelRecord> records;
  const _EfficiencyChart({required this.records});

  List<Map<String, double>> get _kmlData {
    final sorted = [...records]..sort((a, b) => a.odometerKm.compareTo(b.odometerKm));
    final result = <Map<String, double>>[];
    for (int i = 1; i < sorted.length; i++) {
      final prev = sorted[i - 1];
      final curr = sorted[i];
      if (!prev.isFull || !curr.isFull) continue;
      final kmDiff = curr.odometerKm - prev.odometerKm;
      if (kmDiff <= 0 || curr.liters <= 0) continue;
      final kml = kmDiff / curr.liters;
      if (!_isKmlValid(kml)) continue;
      result.add({'index': i.toDouble(), 'kml': kml});
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final data = _kmlData;
    if (data.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.cardBorder)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.show_chart, color: AppTheme.fuel, size: 18),
          const SizedBox(width: 8),
          const Text('Eficiencia de combustible',
              style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 16),
        RepaintBoundary(
          child: SizedBox(
          height: 130,
          child: LineChart(LineChartData(
            gridData: FlGridData(
              show: true,
              getDrawingHorizontalLine: (_) => FlLine(color: Colors.white10, strokeWidth: 1),
              getDrawingVerticalLine: (_) => FlLine(color: Colors.transparent),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36,
                  getTitlesWidget: (v, _) => Text(v.toStringAsFixed(0),
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
                ),
              ),
              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: data.map((d) => FlSpot(d['index']!, d['kml']!)).toList(),
                isCurved: true,
                color: AppTheme.fuel,
                barWidth: 2.5,
                dotData: FlDotData(
                  getDotPainter: (_, _, _, _) => FlDotCirclePainter(
                    radius: 4,
                    color: AppTheme.fuel,
                    strokeWidth: 2,
                    strokeColor: AppTheme.card,
                  ),
                ),
                belowBarData: BarAreaData(show: true, color: AppTheme.fuel.withValues(alpha: 0.1)),
              ),
            ],
          )),
        ),
        ),  // RepaintBoundary
      ]),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final List<FuelRecord> records;
  final double? tankCapacity;
  const _SummaryRow({required this.records, this.tankCapacity});

  @override
  Widget build(BuildContext context) {
    if (records.length < 2) return const SizedBox();
    final sorted = [...records]..sort((a, b) => a.odometerKm.compareTo(b.odometerKm));
    double totalKml = 0;
    int count = 0;
    for (int i = 1; i < sorted.length; i++) {
      final prev = sorted[i - 1];
      final curr = sorted[i];
      if (!prev.isFull || !curr.isFull) continue;
      final kmDiff = curr.odometerKm - prev.odometerKm;
      if (kmDiff > 0 && curr.liters > 0) {
        final kml = kmDiff / curr.liters;
        if (_isKmlValid(kml)) {
          totalKml += kml;
          count++;
        }
      }
    }
    final avg = count > 0 ? totalKml / count : 0.0;
    final autonomia = (tankCapacity != null && avg > 0)
        ? '~${(avg * tankCapacity!).toStringAsFixed(0)} km'
        : null;

    return Row(children: [
      _MiniStat(label: 'Promedio', value: '${avg.toStringAsFixed(1)} km/L', color: AppTheme.fuel),
      const SizedBox(width: 10),
      if (autonomia != null) ...[
        _MiniStat(label: 'Autonomía', value: autonomia, color: AppTheme.primary),
        const SizedBox(width: 10),
        _MiniStat(label: 'Registros', value: '${records.length}', color: AppTheme.maintenance),
      ] else ...[
        _MiniStat(label: 'Registros', value: '${records.length}', color: AppTheme.maintenance),
        const SizedBox(width: 10),
        _MiniStat(label: 'Último km', value: '${sorted.last.odometerKm}', color: AppTheme.parts),
      ],
    ]);
  }
}

class _MiniStat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _MiniStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(children: [
          Text(value,
              style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
        ]),
      ),
    );
  }
}

class _FuelCard extends StatelessWidget {
  final FuelRecord record;
  final AppDatabase db;
  final List<FuelRecord> allRecords;
  final String currency;
  const _FuelCard(
      {required this.record,
      required this.db,
      required this.allRecords,
      required this.currency});

  @override
  Widget build(BuildContext context) {
    // Computar km/L y estado de validez
    final sorted = [...allRecords]
      ..sort((a, b) => a.odometerKm.compareTo(b.odometerKm));
    final idx = sorted.indexWhere((r) => r.id == record.id);

    double? rawKml;
    bool prevIsFull = true;
    if (idx > 0) {
      final prev = sorted[idx - 1];
      prevIsFull = prev.isFull;
      final d = record.odometerKm - prev.odometerKm;
      if (d > 0 && record.liters > 0) rawKml = d / record.liters;
    }

    final isPartial = !record.isFull;
    final isAnomaly = !isPartial &&
        prevIsFull &&
        rawKml != null &&
        !_isKmlValid(rawKml);
    final validKml = (!isPartial && prevIsFull && rawKml != null && !isAnomaly)
        ? rawKml
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.cardBorder)),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: (isPartial
                      ? AppTheme.textSecondary
                      : isAnomaly
                          ? AppTheme.warning
                          : AppTheme.fuel)
                  .withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(Icons.local_gas_station,
              color: isPartial
                  ? AppTheme.textSecondary
                  : isAnomaly
                      ? AppTheme.warning
                      : AppTheme.fuel,
              size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Row(children: [
              Text(DateFormat('dd MMM yyyy').format(record.date),
                  style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600)),
              const Spacer(),
              if (isPartial) ...[
                const _PartialBadge(),
                const SizedBox(width: 4),
              ],
              _FuelTypeBadge(type: record.fuelType),
              if (record.usedOctaneBooster) ...[
                const SizedBox(width: 4),
                const _OctaneBadge(),
              ],
            ]),
            const SizedBox(height: 4),
            Row(children: [
              Text(
                  '${record.liters.toStringAsFixed(2)} L  ·  ${record.odometerKm} km',
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 13)),
              if (validKml != null) ...[
                const Spacer(),
                Text('${validKml.toStringAsFixed(1)} km/L',
                    style: const TextStyle(
                        color: AppTheme.fuel,
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
              ] else if (isAnomaly) ...[
                const Spacer(),
                _AnomalyBadge(kml: rawKml),
              ],
            ]),
            if (isAnomaly)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  '⚠️ Posible carga no registrada entre medio',
                  style: TextStyle(
                      color: AppTheme.warning, fontSize: 11),
                ),
              ),
            if (record.pricePerLiter != null)
              Text(
                  '${currencySymbol(currency)} ${record.pricePerLiter!.toStringAsFixed(2)}/L',
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 12)),
            if (record.octaneBrand != null)
              Text('Elevador: ${record.octaneBrand}',
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 12)),
          ]),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline,
              color: AppTheme.danger, size: 20),
          onPressed: () async {
            await db.deleteFuelRecord(record.id);
            await DriveBackupService.backupIfSignedIn(db);
          },
        ),
      ]),
    );
  }
}

class _PartialBadge extends StatelessWidget {
  const _PartialBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
          color: AppTheme.textSecondary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20)),
      child: const Text('Parcial',
          style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w600)),
    );
  }
}

class _AnomalyBadge extends StatelessWidget {
  final double kml;
  const _AnomalyBadge({required this.kml});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          color: AppTheme.warning.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.warning_amber_rounded,
            color: AppTheme.warning, size: 11),
        const SizedBox(width: 3),
        Text('${kml.toStringAsFixed(0)} km/L',
            style: const TextStyle(
                color: AppTheme.warning,
                fontSize: 11,
                fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

class _FuelTypeBadge extends StatelessWidget {
  final String type;
  const _FuelTypeBadge({required this.type});

  Color get _color => type == 'Premium' ? AppTheme.warning : AppTheme.success;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: _color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
      child: Text(type, style: TextStyle(color: _color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

class _OctaneBadge extends StatelessWidget {
  const _OctaneBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
          color: AppTheme.parts.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.science, color: AppTheme.parts, size: 10),
        const SizedBox(width: 2),
        Text('+Oct', style: TextStyle(color: AppTheme.parts, fontSize: 10, fontWeight: FontWeight.w600)),
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
          Icon(Icons.local_gas_station_outlined, size: 60, color: AppTheme.textSecondary.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          const Text('Sin registros aún', style: TextStyle(color: AppTheme.textSecondary)),
          const SizedBox(height: 4),
          const Text('Registra tu primera carga', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        ]),
      ),
    );
  }
}
