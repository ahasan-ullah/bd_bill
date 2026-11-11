import 'package:flutter/material.dart';
import '../models/tariff_slab.dart';
import '../utils/app_colors.dart';

class TariffSlabRow extends StatelessWidget {
  final TariffSlab slab;
  final ValueChanged<String> onRangeChanged;
  final ValueChanged<double> onRateChanged;
  final VoidCallback? onRemove;

  const TariffSlabRow({
    super.key,
    required this.slab,
    required this.onRangeChanged,
    required this.onRateChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // 1. Editable Range Box (Slightly bigger: flex 5)
          Expanded(
            flex: 5,
            child: TextFormField(
              key: ValueKey('range_${slab.id}_${slab.title}'),
              initialValue: slab.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.borderLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
              onChanged: onRangeChanged,
            ),
          ),
          const SizedBox(width: 8),

          // 2. Editable Rate Box (Slightly bigger: flex 4)
          Expanded(
            flex: 4,
            child: TextFormField(
              key: ValueKey('rate_${slab.id}_${slab.rate}'),
              initialValue: slab.rate.toStringAsFixed(2),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
              decoration: InputDecoration(
                prefixText: '৳  ',
                prefixStyle: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.borderLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
              onChanged: (val) {
                final newRate = double.tryParse(val);
                if (newRate != null) {
                  onRateChanged(newRate);
                }
              },
            ),
          ),
          const SizedBox(width: 4),

          // 3. Remove Button (Red ✕)
          IconButton(
            icon: const Icon(
              Icons.close,
              color: AppColors.danger,
              size: 20,
            ),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
