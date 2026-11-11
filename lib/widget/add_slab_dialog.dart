import 'package:flutter/material.dart';
import '../models/tariff_slab.dart';
import '../utils/app_colors.dart';

class AddSlabDialog extends StatefulWidget {
  final ValueChanged<TariffSlab> onAdd;

  const AddSlabDialog({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddSlabDialog> createState() => _AddSlabDialogState();
}

class _AddSlabDialogState extends State<AddSlabDialog> {
  final _titleController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _rateController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  void _submit() {
    final from = int.tryParse(_fromController.text.trim()) ?? 0;
    final to = int.tryParse(_toController.text.trim());
    final rate = double.tryParse(_rateController.text.trim()) ?? 0.0;
    final title = _titleController.text.trim().isEmpty
        ? (to != null ? '$from-$to' : 'Above $from')
        : _titleController.text.trim();
    final maxUnit = to != null ? (to - from + 1) : null;

    final newSlab = TariffSlab(
      id: 'slab-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      fromUnit: from,
      toUnit: to,
      maxUnit: maxUnit,
      rate: rate,
    );

    widget.onAdd(newSlab);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text(
        'Add Tariff Slab',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title (e.g. 601-800)',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _fromController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'From unit (kWh)',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _toController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'To unit (kWh, leave blank if open)',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _rateController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Rate (৳ / kWh)',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
