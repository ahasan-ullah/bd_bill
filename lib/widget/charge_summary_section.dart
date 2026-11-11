import 'package:bd_bill/utils/app_colors.dart';
import 'package:flutter/material.dart';
import '../models/bill_result.dart';
import '../models/bill_settings.dart';
import '../utils/formatters.dart';

class ChargeSummarySection extends StatelessWidget {
  final BillResult result;
  final BillingSettings settings;

  const ChargeSummarySection({
    super.key,
    required this.result,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Charge summary',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 14),
        _buildRow(
          'Energy charge',
          CurrencyFormatter.format(result.energyCharge),
        ),
        _buildRow(
          'Demand · ${result.loadCount} kW × ৳${settings.demandCharge.toStringAsFixed(0)}',
          CurrencyFormatter.format(result.demandCharge),
        ),
        _buildRow(
          'Meter rent',
          CurrencyFormatter.format(result.meterRent),
        ),
        const Divider(color: AppColors.primary, thickness: 1.5),
        _buildRow(
          'Subtotal',
          CurrencyFormatter.format(result.subtotal),
          isBold: true,
        ),
        _buildRow(
          'VAT · ${settings.vatPercentage.toStringAsFixed(0)}% of subtotal',
          CurrencyFormatter.format(result.vatAmount),
        ),
      ],
    );
  }

  Widget _buildRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? const Color(0xFF0F172A) : const Color(0xFF475569),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
