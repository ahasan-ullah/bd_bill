import 'package:bd_bill/models/bill_result.dart';
import 'package:bd_bill/models/bill_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/bill_provider.dart';
import '../services/pdf_invoice_service.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';
import '../widget/charge_summary_section.dart';
import '../widget/revise_calculation_card.dart';
import '../widget/slab_breakdown_section.dart';

class BillBreakdownScreen extends ConsumerStatefulWidget {
  const BillBreakdownScreen({super.key});

  @override
  ConsumerState<BillBreakdownScreen> createState() =>
      _BillBreakdownScreenState();
}

class _BillBreakdownScreenState extends ConsumerState<BillBreakdownScreen> {
  late final TextEditingController _unitsController;
  late final TextEditingController _loadController;

  @override
  void initState() {
    super.initState();
    final currentUnits = ref.read(consumedUnitsProvider);
    final currentLoad = ref.read(loadCountProvider);
    _unitsController = TextEditingController(
      text: currentUnits > 0 ? currentUnits.toString() : '',
    );
    _loadController = TextEditingController(text: currentLoad.toString());
  }

  @override
  void dispose() {
    _unitsController.dispose();
    _loadController.dispose();
    super.dispose();
  }

  void _updateBill() {
    final double? units = double.tryParse(_unitsController.text);
    final int? load = int.tryParse(_loadController.text);

    if (units != null && units >= 0) {
      ref.read(consumedUnitsProvider.notifier).setUnits(units);
    }
    if (load != null && load >= 1 && load <= 8) {
      ref.read(loadCountProvider.notifier).setLoad(load);
    }

    FocusScope.of(context).unfocus();
  }

  Future<void> _confirmAndDownload(
    BuildContext context,
    BillResult result,
    BillingSettings settings,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Download Statement',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.textDark,
          ),
        ),
        content: const Text(
          'Do you want to download the PDF statement?',
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
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await PdfInvoiceService.generateAndDownloadStatement(
        result: result,
        settings: settings,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(calculatedBillProvider);
    final settings = ref.watch(billingSettingsProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Text(
            'Back to Calculator',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Title Row: "Bill breakdown" on left, "Download" button on right
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bill breakdown',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () =>
                        _confirmAndDownload(context, result, settings),
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text(
                      'Download',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 3. Revise Calculation Card Widget
              ReviseCalculationCard(
                unitsController: _unitsController,
                loadController: _loadController,
                onUpdate: _updateBill,
              ),
              const SizedBox(height: 24),

              // 4. Accent Divider above Total payable bill
              const Divider(color: AppColors.primary, thickness: 1.5),
              const SizedBox(height: 8),

              // 5. Total Payable Bill Display
              const Text(
                'Total payable bill',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                CurrencyFormatter.format(result.totalPayable),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              const Divider(color: AppColors.primary, thickness: 1.5),
              const SizedBox(height: 16),

              // 6. Charge Summary Section Widget
              ChargeSummarySection(
                result: result,
                settings: settings,
              ),
              const Divider(color: AppColors.primary, thickness: 1.5),
              const SizedBox(height: 24),

              // 7. Slab Breakdown Section Widget
              SlabBreakdownSection(result: result),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
