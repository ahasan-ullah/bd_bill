import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tariff_slab.dart';
import '../services/rate_loader_service.dart';
import '../state/bill_provider.dart';
import '../utils/app_colors.dart';
import '../widget/add_slab_dialog.dart';
import '../widget/app_header.dart';
import '../widget/tariff_slab_row.dart';

class RatesScreen extends ConsumerStatefulWidget {
  const RatesScreen({super.key});

  @override
  ConsumerState<RatesScreen> createState() => _RatesScreenState();
}

class _RatesScreenState extends ConsumerState<RatesScreen> {
  late final TextEditingController _vatController;
  late final TextEditingController _demandController;
  late final TextEditingController _meterController;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(billingSettingsProvider);
    _vatController =
        TextEditingController(text: settings.vatPercentage.toStringAsFixed(0));
    _demandController =
        TextEditingController(text: settings.demandCharge.toStringAsFixed(0));
    _meterController =
        TextEditingController(text: settings.meterRent.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _vatController.dispose();
    _demandController.dispose();
    _meterController.dispose();
    super.dispose();
  }

  Future<void> _confirmAndApplyChanges() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Apply Changes?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.textDark,
          ),
        ),
        content: const Text(
          'Are you sure you want to save these rate changes?',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // 1. Update In-Memory Settings Notifier
    final vat = double.tryParse(_vatController.text.trim());
    final demand = double.tryParse(_demandController.text.trim());
    final meter = double.tryParse(_meterController.text.trim());

    if (vat != null) {
      ref.read(billingSettingsProvider.notifier).updateVat(vat);
    }
    if (demand != null) {
      ref.read(billingSettingsProvider.notifier).updateDemandCharge(demand);
    }
    if (meter != null) {
      ref.read(billingSettingsProvider.notifier).updateMeterRent(meter);
    }

    // 2. Directly Save to JSON File
    final currentSettings = ref.read(billingSettingsProvider);
    final currentSlabs = ref.read(tariffSlabsProvider);
    final currentLoad = ref.read(loadCountProvider);

    await RateLoaderService.saveRates(
      settings: currentSettings,
      slabs: currentSlabs,
      loadCount: currentLoad,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rates applied and saved successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<TariffSlab> slabs = ref.watch(tariffSlabsProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: const AppHeader(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Row: "Rate settings" on left, "Apply" button on right
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rate settings',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _confirmAndApplyChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 2. Global Parameters Section (Now at top above Tariff slabs)
              const Text(
                'Global parameters',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildGlobalParamInput(
                    label: 'VAT',
                    controller: _vatController,
                    suffix: '%',
                  ),
                  const SizedBox(width: 8),
                  _buildGlobalParamInput(
                    label: 'Demand charge',
                    controller: _demandController,
                    suffix: '৳ / kW',
                    suffixFontSize: 10,
                  ),
                  const SizedBox(width: 8),
                  _buildGlobalParamInput(
                    label: 'Meter rent',
                    controller: _meterController,
                    suffix: '৳',
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // 3. Tariff Slabs Header
              const Text(
                'Tariff slabs',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),

              // Table Column Titles (No max charge, first two columns wider)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: const [
                    Expanded(
                      flex: 5,
                      child: Text(
                        'Range (kWh)',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      flex: 4,
                      child: Text(
                        'Rate / kWh',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                    SizedBox(
                      width: 56,
                      child: Text(
                        'Remove',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(color: AppColors.borderLight, thickness: 1),
              const SizedBox(height: 8),

              // 4. Editable Slab Rows (Editable Range & Rate, No Max Charge)
              ...slabs.asMap().entries.map((entry) {
                final int index = entry.key;
                final TariffSlab slab = entry.value;

                return TariffSlabRow(
                  slab: slab,
                  onRangeChanged: (newRange) => ref
                      .read(tariffSlabsProvider.notifier)
                      .updateRange(index, newRange),
                  onRateChanged: (newRate) => ref
                      .read(tariffSlabsProvider.notifier)
                      .updateRate(index, newRate),
                  onRemove: slabs.length > 1
                      ? () => ref
                          .read(tariffSlabsProvider.notifier)
                          .removeSlab(index)
                      : null,
                );
              }),
              const SizedBox(height: 8),

              // 5. + Add Slab Button
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AddSlabDialog(
                        onAdd: (newSlab) => ref
                            .read(tariffSlabsProvider.notifier)
                            .addSlab(newSlab),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text(
                    'Add slab',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.borderSubtle),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlobalParamInput({
    required String label,
    required TextEditingController controller,
    required String suffix,
    double suffixFontSize = 13,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              suffixText: suffix,
              suffixStyle: TextStyle(fontSize: suffixFontSize),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
