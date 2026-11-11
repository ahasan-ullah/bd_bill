import 'package:flutter/material.dart';
import '../models/bill_settings.dart';
import '../utils/app_colors.dart';

class BillingParametersSection extends StatelessWidget {
  final BillingSettings settings;
  final ValueChanged<double> onDemandChargeChanged;
  final ValueChanged<double> onMeterRentChanged;
  final ValueChanged<double> onVatChanged;

  const BillingParametersSection({
    super.key,
    required this.settings,
    required this.onDemandChargeChanged,
    required this.onMeterRentChanged,
    required this.onVatChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Billing parameters',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 16),

        // Demand Charge Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Demand charge',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Per kW of load',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
            _buildParamInput(
              key: ValueKey('demand_${settings.demandCharge}'),
              initialValue: settings.demandCharge.toStringAsFixed(0),
              suffix: '৳ / kW',
              onChanged: (val) =>
                  onDemandChargeChanged(double.tryParse(val) ?? 0.0),
            ),
          ],
        ),
        const Divider(height: 24, thickness: 1, color: Color(0xFFF1F5F9)),

        // Meter Rent Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Meter rent',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
            _buildParamInput(
              key: ValueKey('rent_${settings.meterRent}'),
              initialValue: settings.meterRent.toStringAsFixed(0),
              suffix: '৳',
              onChanged: (val) =>
                  onMeterRentChanged(double.tryParse(val) ?? 0.0),
            ),
          ],
        ),
        const Divider(height: 24, thickness: 1, color: Color(0xFFF1F5F9)),

        // VAT Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'VAT',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
            _buildParamInput(
              key: ValueKey('vat_${settings.vatPercentage}'),
              initialValue: settings.vatPercentage.toStringAsFixed(0),
              suffix: '%',
              onChanged: (val) => onVatChanged(double.tryParse(val) ?? 0.0),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildParamInput({
    required Key key,
    required String initialValue,
    required String suffix,
    required ValueChanged<String> onChanged,
  }) {
    return SizedBox(
      width: 120,
      height: 44,
      child: TextFormField(
        key: key,
        initialValue: initialValue,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.start,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        decoration: InputDecoration(
          suffixText: suffix,
          suffixStyle: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
