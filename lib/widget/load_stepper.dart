import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class LoadStepper extends StatelessWidget {
  final int load;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  const LoadStepper({
    super.key,
    required this.load,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Load count',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Maximum 8 kW',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 18),
                color: load > 1
                    ? AppColors.textMuted
                    : AppColors.borderSubtle,
                onPressed: onDecrement,
              ),
              Text(
                '$load kW',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 18),
                color: load < 8
                    ? AppColors.primary
                    : AppColors.borderSubtle,
                onPressed: onIncrement,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
