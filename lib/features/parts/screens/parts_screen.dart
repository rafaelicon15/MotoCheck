import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/database/app_database.dart';
import '../../../shared/providers/database_provider.dart';
import '../../../shared/providers/active_moto_provider.dart';
import '../../../shared/providers/settings_provider.dart';

class PartsScreen extends ConsumerWidget {
  const PartsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    final moto = ref.watch(activeMotoProvider).valueOrNull;
    final currency = ref.watch(currencyCodeProvider).valueOrNull ?? kDefaultCurrency;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Refacciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.playlist_add),
            tooltip: 'Cargar refacciones comunes',
            onPressed: () => _addDefaults(db, moto),
          ),
        ],
      ),
      body: StreamBuilder<List<PartRecord>>(
        stream: db.watchParts(moto?.id),
        builder: (context, snap) {
          final parts = snap.data ?? [];
          final currentKm = moto?.currentKm ?? 0;

          if (parts.isEmpty) {
            return _EmptyState(onAddDefaults: () => _addDefaults(db, moto));
          }

          final sorted = [...parts]..sort((a, b) {
            if (a.filterType == 'permanent') return 1;
            if (b.filterType == 'permanent') return -1;
            final ra = (a.lastChangedKm + a.intervalKm) - currentKm;
            final rb = (b.lastChangedKm + b.intervalKm) - currentKm;
            return ra.compareTo(rb);
          });

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ...sorted.map((p) => _PartCard(
                    part: p,
                    currentKm: currentKm,
                    db: db,
                    motoId: moto?.id,
                    currency: currency,
                    engineType: moto?.engineType ?? '4T',
                  )),
              const SizedBox(height: 20),
              _ChangelogSection(db: db, motoId: moto?.id, currency: currency),
              const SizedBox(height: 80),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPart(context, db, moto?.id, moto?.rimType ?? 'alloy'),
        icon: const Icon(Icons.add),
        label: const Text('Nueva refacción'),
      ),
    );
  }

  Future<void> _addDefaults(AppDatabase db, MotoProfileData? moto) async {
    final engineType = moto?.engineType ?? '4T';
    final coolingType = moto?.coolingType ?? 'air';
    final oilFilterType = moto?.oilFilterType ?? 'replaceable';
    final twoStrokeMethod = moto?.twoStrokeOilMethod;
    final transmissionType = moto?.transmissionType ?? 'chain';

    // Partes base según tipo de motor
    final baseParts = engineType == '2T'
        ? AppConstants.defaultParts2T
        : AppConstants.defaultParts4T;

    for (final part in baseParts) {
      final category = part['category'] as String;
      String? filterType = part['filterType'] as String?;
      if (category == 'oil_filter') filterType = oilFilterType;

      await db.insertPart(PartRecordsCompanion.insert(
        motoId: drift.Value(moto?.id),
        name: part['name'] as String,
        intervalKm: part['intervalKm'] as int,
        lastChangedKm: 0,
        lastChangedDate: DateTime.now(),
        partCategory: drift.Value(category),
        filterType: drift.Value(filterType),
        brakeType: drift.Value(part['brakeType'] as String?),
        tireType: drift.Value(category == 'tire' ? 'standard' : null),
        chainType: drift.Value(null),
        requiresComboChange: drift.Value(false),
      ));
    }

    // Partes según tipo de transmisión
    final transmParts = transmissionType == 'shaft'
        ? AppConstants.shaftDefaultParts
        : transmissionType == 'belt'
            ? AppConstants.beltCvtDefaultParts
            : AppConstants.chainDefaultParts;

    for (final part in transmParts) {
      final category = part['category'] as String;
      await db.insertPart(PartRecordsCompanion.insert(
        motoId: drift.Value(moto?.id),
        name: part['name'] as String,
        intervalKm: part['intervalKm'] as int,
        lastChangedKm: 0,
        lastChangedDate: DateTime.now(),
        partCategory: drift.Value(category),
        filterType: drift.Value(null),
        brakeType: drift.Value(null),
        tireType: drift.Value(null),
        chainType: drift.Value(category == 'chain' ? 'standard' : null),
        requiresComboChange: drift.Value(category == 'chain'),
      ));
    }

    // 2T autolube: agregar seguimiento del depósito de aceite
    if (engineType == '2T' && twoStrokeMethod == 'autolube') {
      await db.insertPart(PartRecordsCompanion.insert(
        motoId: drift.Value(moto?.id),
        name: 'Aceite 2T (depósito autolube)',
        intervalKm: 3000,
        lastChangedKm: 0,
        lastChangedDate: DateTime.now(),
        partCategory: drift.Value('oil'),
        filterType: drift.Value(null),
        brakeType: drift.Value(null),
        tireType: drift.Value(null),
        chainType: drift.Value(null),
        requiresComboChange: drift.Value(false),
      ));
    }

    // 2T premix: agregar nota de mezcla
    if (engineType == '2T' && twoStrokeMethod == 'premix') {
      await db.insertPart(PartRecordsCompanion.insert(
        motoId: drift.Value(moto?.id),
        name: 'Aceite 2T premezclado (cada carga de gasolina)',
        intervalKm: 500,
        lastChangedKm: 0,
        lastChangedDate: DateTime.now(),
        partCategory: drift.Value('oil'),
        filterType: drift.Value(null),
        brakeType: drift.Value(null),
        tireType: drift.Value(null),
        chainType: drift.Value(null),
        requiresComboChange: drift.Value(false),
      ));
    }

    // Refrigeración líquida: agregar líquido refrigerante
    if (coolingType == 'liquid') {
      await db.insertPart(PartRecordsCompanion.insert(
        motoId: drift.Value(moto?.id),
        name: 'Líquido refrigerante',
        intervalKm: 25000,
        lastChangedKm: 0,
        lastChangedDate: DateTime.now(),
        partCategory: drift.Value('coolant'),
        filterType: drift.Value(null),
        brakeType: drift.Value(null),
        tireType: drift.Value(null),
        chainType: drift.Value(null),
        requiresComboChange: drift.Value(false),
      ));
    }
  }

  void _showAddPart(BuildContext context, AppDatabase db, int? motoId, String rimType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _AddPartSheet(db: db, motoId: motoId, rimType: rimType),
    );
  }
}

// ─── Tarjeta de refacción ─────────────────────────────────────────────────────

class _PartCard extends StatelessWidget {
  final PartRecord part;
  final int currentKm;
  final AppDatabase db;
  final int? motoId;
  final String currency;
  final String engineType;
  const _PartCard({required this.part, required this.currentKm, required this.db, required this.motoId, required this.currency, required this.engineType});

  bool get _isPermanent => part.filterType == 'permanent';
  int get _remaining => (part.lastChangedKm + part.intervalKm) - currentKm;
  double get _progress => ((currentKm - part.lastChangedKm) / part.intervalKm).clamp(0.0, 1.0);

  Color get _statusColor {
    if (_isPermanent) return AppTheme.textSecondary;
    if (_remaining <= 0) return AppTheme.danger;
    if (_remaining <= 500) return AppTheme.warning;
    return AppTheme.success;
  }

  String get _categoryIcon {
    switch (part.partCategory) {
      case 'oil': return '🛢';
      case 'oil_filter': return '🔧';
      case 'fuel_filter': return '⛽';
      case 'chain': return '⛓️';
      case 'sprocket': return '⚙️';
      case 'brake_front':
      case 'brake_rear': return '🛑';
      case 'tire': return '🛞';
      case 'sealant': return '💧';
      case 'coolant': return '🌡';
      default: return '🔩';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: !_isPermanent && _remaining <= 500
            ? Border.all(color: _statusColor.withOpacity(0.5))
            : Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(_categoryIcon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(part.name,
                  style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700)),
              if (part.brakeType != null)
                Text(part.brakeType == 'pads' ? 'Pastillas de freno' : 'Bandas de freno',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
              if (part.tireType != null && part.tireType != 'standard')
                Text(
                  part.tireType == 'sealant'
                      ? '💧 Con antipinchazo'
                      : part.tireType == 'tube'
                          ? '🔵 Con cámara'
                          : '⭕ Tubeless',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                ),
              if (part.chainType != null) ...[
                Text(
                  'Cadena ${AppConstants.chainTypeByValue(part.chainType!)['label']}',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                ),
                Text(
                  'Lubricar cada ${AppConstants.chainTypeByValue(part.chainType!)['lubKm']} km',
                  style: const TextStyle(color: AppTheme.parts, fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ],
            ]),
          ),
          if (_isPermanent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: AppTheme.textSecondary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20)),
              child: const Text('METÁLICO',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 10, fontWeight: FontWeight.w700)),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
              child: Text(
                _remaining <= 0 ? 'VENCIDA' : _remaining <= 500 ? 'PRÓXIMA' : 'OK',
                style: TextStyle(color: _statusColor, fontSize: 10, fontWeight: FontWeight.w700),
              ),
            ),
        ]),
        const SizedBox(height: 8),

        if (_isPermanent)
          const Text('No requiere cambio (filtro permanente)',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12))
        else ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(_statusColor),
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.refresh, size: 13, color: AppTheme.textSecondary),
            const SizedBox(width: 4),
            Text('Cada ${part.intervalKm} km',
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            const Spacer(),
            Text(
              _remaining > 0 ? 'Faltan $_remaining km' : 'Vencida ${_remaining.abs()} km',
              style: TextStyle(color: _statusColor, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ]),
        ],
        const SizedBox(height: 4),
        Row(children: [
          const Icon(Icons.calendar_today, size: 13, color: AppTheme.textSecondary),
          const SizedBox(width: 4),
          Text('Último: ${DateFormat('dd/MM/yyyy').format(part.lastChangedDate)} · ${part.lastChangedKm} km',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _registerChange(context),
              icon: const Icon(Icons.check, size: 16),
              label: Text(
                _isPermanent
                    ? 'Registrar limpieza'
                    : (part.partCategory == 'oil' && engineType == '2T')
                        ? 'Registrar recarga'
                        : 'Registrar cambio',
                style: const TextStyle(fontSize: 12),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.parts,
                side: BorderSide(color: AppTheme.parts.withOpacity(0.5)),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppTheme.danger, size: 20),
            onPressed: () => db.deletePart(part.id),
          ),
        ]),
      ]),
    );
  }

  void _registerChange(BuildContext context) {
    final kmCtrl = TextEditingController(text: currentKm.toString());
    final costCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(_isPermanent ? 'Limpieza: ${part.name}' : 'Cambio: ${part.name}',
            style: const TextStyle(fontSize: 16)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: kmCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Km actuales'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: costCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: 'Costo (opcional)', prefixText: '${currencySymbol(currency)} '),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final km = int.tryParse(kmCtrl.text) ?? currentKm;
              final cost = double.tryParse(costCtrl.text);
              await db.updatePart(part.copyWith(
                lastChangedKm: km,
                lastChangedDate: DateTime.now(),
                cost: drift.Value(cost),
              ));
              await db.insertPartHistory(PartHistoryCompanion.insert(
                partId: part.id,
                motoId: drift.Value(motoId),
                partName: part.name,
                km: km,
                changedAt: DateTime.now(),
                cost: drift.Value(cost),
              ));
              if (ctx.mounted) {
                Navigator.pop(ctx);
                // Si es cadena, ofrecer cambio de piñón/corona
                if (part.requiresComboChange && context.mounted) {
                  _showComboChangeDialog(context, km);
                }
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showComboChangeDialog(BuildContext context, int km) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Cambio de cadena', style: TextStyle(fontSize: 16)),
        content: const Text(
          '¿También cambiaste piñón, corona y/o gomas del porta corona?\n\n'
          'Se recomienda cambiarlos juntos para evitar desgaste prematuro de la cadena.',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('No')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              // Buscar y actualizar piñón y corona
              final sprockets = await db.getPartsByCategory(motoId, 'sprocket');
              for (final s in sprockets) {
                await db.updatePart(s.copyWith(
                  lastChangedKm: km,
                  lastChangedDate: DateTime.now(),
                ));
                await db.insertPartHistory(PartHistoryCompanion.insert(
                  partId: s.id,
                  motoId: drift.Value(motoId),
                  partName: s.name,
                  km: km,
                  changedAt: DateTime.now(),
                ));
              }
              if (ctx.mounted) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('Piñón y corona actualizados')),
                );
              }
            },
            child: const Text('Sí, también los cambié'),
          ),
        ],
      ),
    );
  }
}

// ─── Formulario agregar refacción ─────────────────────────────────────────────

class _AddPartSheet extends StatefulWidget {
  final AppDatabase db;
  final int? motoId;
  final String rimType;
  const _AddPartSheet({required this.db, required this.motoId, required this.rimType});

  @override
  State<_AddPartSheet> createState() => _AddPartSheetState();
}

class _AddPartSheetState extends State<_AddPartSheet> {
  final _nameCtrl = TextEditingController();
  final _intervalCtrl = TextEditingController();
  final _lastKmCtrl = TextEditingController();

  String _category = 'general';
  String _filterType = 'replaceable';
  String _brakeType = 'pads';
  late String _tireType;
  String _chainType = 'standard';
  bool _isPermanentFilter = false;

  @override
  void initState() {
    super.initState();
    final compatible = AppConstants.compatibleTireTypes(widget.rimType);
    _tireType = compatible.contains('standard') ? 'standard' : compatible.first;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 20, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Nueva refacción',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),

            TextField(controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Nombre de la pieza')),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Categoría'),
              dropdownColor: AppTheme.surface,
              style: const TextStyle(color: AppTheme.textPrimary),
              items: const [
                DropdownMenuItem(value: 'general', child: Text('General')),
                DropdownMenuItem(value: 'oil_filter', child: Text('Filtro de aceite')),
                DropdownMenuItem(value: 'fuel_filter', child: Text('Filtro de gasolina')),
                DropdownMenuItem(value: 'chain', child: Text('Cadena')),
                DropdownMenuItem(value: 'sprocket', child: Text('Piñón / Corona')),
                DropdownMenuItem(value: 'brake_front', child: Text('Freno delantero')),
                DropdownMenuItem(value: 'brake_rear', child: Text('Freno trasero')),
                DropdownMenuItem(value: 'tire', child: Text('Llanta')),
                DropdownMenuItem(value: 'sealant', child: Text('Antipinchazo / Slime')),
                DropdownMenuItem(value: 'coolant', child: Text('Líquido refrigerante')),
              ],
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 12),

            // Filtro metálico
            if (_category == 'oil_filter') ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  const Icon(Icons.filter_alt_outlined, color: AppTheme.textSecondary, size: 18),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text('Es filtro metálico permanente',
                        style: TextStyle(color: AppTheme.textPrimary, fontSize: 14)),
                  ),
                  Switch(
                    value: _isPermanentFilter,
                    onChanged: (v) => setState(() {
                      _isPermanentFilter = v;
                      _filterType = v ? 'permanent' : 'replaceable';
                    }),
                    activeColor: AppTheme.primary,
                  ),
                ]),
              ),
              const SizedBox(height: 12),
            ],

            // Tipo de cadena
            if (_category == 'chain') ...[
              const Text('Tipo de cadena',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
              const SizedBox(height: 8),
              ...AppConstants.chainTypes.map((ct) {
                final isSelected = _chainType == ct['value'];
                final lubKm = ct['lubKm'] as int;
                return GestureDetector(
                  onTap: () => setState(() {
                    _chainType = ct['value'] as String;
                    // Ajustar intervalo de reemplazo según tipo (no el de lubricación)
                    if (_intervalCtrl.text.isEmpty) {
                      _intervalCtrl.text = ct['value'] == 'standard' ? '15000' : '25000';
                    }
                  }),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.parts.withOpacity(0.12) : AppTheme.card,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: isSelected ? AppTheme.parts : Colors.transparent,
                          width: 1.5),
                    ),
                    child: Row(children: [
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(ct['label'] as String,
                              style: TextStyle(
                                color: isSelected ? AppTheme.parts : AppTheme.textPrimary,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                                fontSize: 13,
                              )),
                          Text(ct['desc'] as String,
                              style: const TextStyle(
                                  color: AppTheme.textSecondary, fontSize: 10)),
                          Text('Lubricar cada $lubKm km',
                              style: TextStyle(
                                  color: isSelected ? AppTheme.parts : AppTheme.textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600)),
                        ]),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: AppTheme.parts, size: 16),
                    ]),
                  ),
                );
              }),
              const SizedBox(height: 12),
            ],

            // Tipo de freno
            if (_category == 'brake_front' || _category == 'brake_rear') ...[
              const Text('Tipo de freno', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: _BrakeTypeBtn(
                  label: 'Pastillas (disco)',
                  selected: _brakeType == 'pads',
                  onTap: () => setState(() {
                    _brakeType = 'pads';
                    if (_intervalCtrl.text.isEmpty) _intervalCtrl.text = '15000';
                  }),
                )),
                const SizedBox(width: 10),
                Expanded(child: _BrakeTypeBtn(
                  label: 'Bandas (tambor)',
                  selected: _brakeType == 'bands',
                  onTap: () => setState(() {
                    _brakeType = 'bands';
                    if (_intervalCtrl.text.isEmpty) _intervalCtrl.text = '8000';
                  }),
                )),
              ]),
              const SizedBox(height: 12),
            ],

            // Tipo de llanta
            if (_category == 'tire') ...[
              const Text('Configuración de la llanta',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
              const SizedBox(height: 8),
              if (widget.rimType == 'spoke')
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.withOpacity(0.3)),
                  ),
                  child: const Text(
                    '🔩 Rin de rayos estándar: los nipples de los rayos impiden el sello tubeless. Solo se puede usar cámara / tripa.',
                    style: TextStyle(color: Colors.amber, fontSize: 11),
                  ),
                ),
              ...AppConstants.tireTypes
                  .where((t) => AppConstants.compatibleTireTypes(widget.rimType).contains(t['value']))
                  .map((t) {
                final isSelected = _tireType == t['value'];
                return GestureDetector(
                  onTap: () => setState(() {
                    _tireType = t['value']!;
                    if (t['value'] == 'sealant' && _intervalCtrl.text.isEmpty) {
                      _intervalCtrl.text = '15000';
                    }
                  }),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.parts.withOpacity(0.12) : AppTheme.card,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: isSelected ? AppTheme.parts : Colors.transparent,
                          width: 1.5),
                    ),
                    child: Row(children: [
                      Expanded(child: Text(t['label']!,
                          style: TextStyle(
                            color: isSelected ? AppTheme.parts : AppTheme.textPrimary,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                            fontSize: 13,
                          ))),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: AppTheme.parts, size: 16),
                    ]),
                  ),
                );
              }),
              if (_tireType == 'sealant')
                Container(
                  margin: const EdgeInsets.only(top: 4, bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '💧 El antipinchazo / Slime tiene una vida útil de ~15,000 km o 2 años. Se recomienda reemplazarlo aunque no haya pinchazos.',
                    style: TextStyle(color: Colors.lightBlue, fontSize: 11),
                  ),
                ),
              if (_tireType == 'tube')
                Container(
                  margin: const EdgeInsets.only(top: 4, bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '🔵 La cámara/tripa se cambia junto con la llanta o cuando sufra daños. Su vida útil coincide con la llanta.',
                    style: TextStyle(color: Colors.lightBlue, fontSize: 11),
                  ),
                ),
              const SizedBox(height: 12),
            ],

            if (!_isPermanentFilter)
              Row(children: [
                Expanded(child: TextField(
                  controller: _intervalCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Cambiar cada (km)'),
                )),
                const SizedBox(width: 12),
                Expanded(child: TextField(
                  controller: _lastKmCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Último cambio (km)'),
                )),
              ]),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                if (_nameCtrl.text.isEmpty) return;
                await widget.db.insertPart(PartRecordsCompanion.insert(
                  motoId: drift.Value(widget.motoId),
                  name: _nameCtrl.text,
                  intervalKm: int.tryParse(_intervalCtrl.text) ?? 5000,
                  lastChangedKm: int.tryParse(_lastKmCtrl.text) ?? 0,
                  lastChangedDate: DateTime.now(),
                  partCategory: drift.Value(_category),
                  filterType: drift.Value(_category == 'oil_filter' ? _filterType : null),
                  brakeType: drift.Value(
                      (_category == 'brake_front' || _category == 'brake_rear') ? _brakeType : null),
                  tireType: drift.Value(_category == 'tire' ? _tireType : null),
                  chainType: drift.Value(_category == 'chain' ? _chainType : null),
                  requiresComboChange: drift.Value(_category == 'chain'),
                ));
                if (mounted) Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrakeTypeBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _BrakeTypeBtn({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppTheme.parts.withOpacity(0.15) : AppTheme.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? AppTheme.parts : Colors.transparent, width: 1.5),
        ),
        child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: selected ? AppTheme.parts : AppTheme.textSecondary,
                fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
                fontSize: 12)),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAddDefaults;
  const _EmptyState({required this.onAddDefaults});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(children: [
          Icon(Icons.settings_outlined, size: 64, color: AppTheme.textSecondary.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text('Sin refacciones configuradas',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onAddDefaults,
            icon: const Icon(Icons.playlist_add),
            label: const Text('Cargar refacciones comunes'),
          ),
        ]),
      ),
    );
  }
}

// ─── Historial de cambios ─────────────────────────────────────────────────────

class _ChangelogSection extends StatelessWidget {
  final AppDatabase db;
  final int? motoId;
  final String currency;
  const _ChangelogSection(
      {required this.db, required this.motoId, required this.currency});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PartHistoryData>>(
      stream: db.watchPartHistory(motoId),
      builder: (context, snap) {
        final history = snap.data ?? [];
        if (history.isEmpty) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 1,
              color: Colors.white10,
              margin: const EdgeInsets.only(bottom: 16),
            ),
            Row(children: [
              const Icon(Icons.history, color: AppTheme.parts, size: 18),
              const SizedBox(width: 8),
              const Text(
                'Historial de cambios',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary),
              ),
              const Spacer(),
              Text(
                '${history.length} registro${history.length == 1 ? '' : 's'}',
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 12),
              ),
            ]),
            const SizedBox(height: 12),
            ...history
                .take(50)
                .map((h) => _HistoryEntry(entry: h, db: db, currency: currency)),
          ],
        );
      },
    );
  }
}

class _HistoryEntry extends StatelessWidget {
  final PartHistoryData entry;
  final AppDatabase db;
  final String currency;
  const _HistoryEntry(
      {required this.entry, required this.db, required this.currency});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.cardBorder)),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: AppTheme.parts.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.check_circle_outline,
              color: AppTheme.parts, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(entry.partName,
                style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
            const SizedBox(height: 2),
            Text(
              '${DateFormat('dd/MM/yyyy').format(entry.changedAt)}  ·  ${entry.km} km',
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 12),
            ),
          ]),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          if (entry.cost != null)
            Text(
              '${currencySymbol(currency)} ${entry.cost!.toStringAsFixed(0)}',
              style: const TextStyle(
                  color: AppTheme.parts,
                  fontWeight: FontWeight.w700,
                  fontSize: 13),
            ),
          const SizedBox(height: 2),
          GestureDetector(
            onTap: () => db.deletePartHistory(entry.id),
            child: const Icon(Icons.close,
                color: AppTheme.textSecondary, size: 14),
          ),
        ]),
      ]),
    );
  }
}
