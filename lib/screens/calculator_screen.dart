import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/bill_provider.dart';
import '../utils/app_colors.dart';
import '../widget/app_header.dart';
import '../widget/billing_parameters_section.dart';
import '../widget/consumed_units_input.dart';
import '../widget/load_stepper.dart';
import 'bill_breakdown_screen.dart';

class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({super.key});

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen> {
  late final TextEditingController _unitsController;
  late final FocusNode _unitsFocusNode;

  @override
  void initState() {
    super.initState();
    final currentUnits = ref.read(consumedUnitsProvider);
    _unitsController = TextEditingController(
      text: currentUnits > 0 ? currentUnits.toString() : '',
    );
    _unitsFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _unitsFocusNode.dispose();
    _unitsController.dispose();
    super.dispose();
  }

  Future<void> _onCalculateBill() async {
    _unitsFocusNode.unfocus();
    FocusScope.of(context).unfocus();

    final unitsText = _unitsController.text.trim();
    final units = double.tryParse(unitsText) ?? 0.0;

    if (units <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter total consumed units (kWh)'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    ref.read(consumedUnitsProvider.notifier).setUnits(units);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const BillBreakdownScreen(),
      ),
    );

    // Keep keyboard dismissed when returning to this screen
    if (mounted) {
      _unitsFocusNode.unfocus();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final load = ref.watch(loadCountProvider);
    final settings = ref.watch(billingSettingsProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: const AppHeader(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Page Title & Subtitle
                const Text(
                  'Calculator',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Estimate your residential electricity bill.',
                  style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                ),
                const SizedBox(height: 24),

                // 2. Consumed Units Input Widget
                ConsumedUnitsInput(
                  controller: _unitsController,
                  focusNode: _unitsFocusNode,
                  onChanged: (val) {
                    final units = double.tryParse(val) ?? 0.0;
                    ref.read(consumedUnitsProvider.notifier).setUnits(units);
                  },
                ),
                const SizedBox(height: 24),

                // 3. Load Stepper Widget
                LoadStepper(
                  load: load,
                  onDecrement: load > 1
                      ? () => ref.read(loadCountProvider.notifier).decrement()
                      : null,
                  onIncrement: load < 8
                      ? () => ref.read(loadCountProvider.notifier).increment()
                      : null,
                ),
                const SizedBox(height: 28),

                // 4. Billing Parameters Section Widget
                BillingParametersSection(
                  settings: settings,
                  onDemandChargeChanged: (val) => ref
                      .read(billingSettingsProvider.notifier)
                      .updateDemandCharge(val),
                  onMeterRentChanged: (val) => ref
                      .read(billingSettingsProvider.notifier)
                      .updateMeterRent(val),
                  onVatChanged: (val) =>
                      ref.read(billingSettingsProvider.notifier).updateVat(val),
                ),
                const SizedBox(height: 32),

                // 5. Calculate Bill Primary Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _onCalculateBill,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Calculate bill',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
