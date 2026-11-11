import 'package:bd_bill/models/bill_result.dart';
import 'package:bd_bill/models/bill_settings.dart';
import 'package:bd_bill/models/tariff_slab.dart';

class BillCalculator {
  static BillResult calculate({
    required double units,
    required int loadCount,
    required List<TariffSlab> slabs,
    required BillingSettings settings,
  }) {
    double remainingUnits = units > 0 ? units : 0.0;
    double totalEnergyCharge = 0.0;
    final List<SlabBreakdown> breakdowns = [];

    for (final slab in slabs) {
      if (remainingUnits <= 0) break;

      double unitInThisSlab = 0.0;

      if (slab.maxUnit != null) {
        unitInThisSlab = remainingUnits > slab.maxUnit!
            ? slab.maxUnit!.toDouble()
            : remainingUnits;
      } else {
        unitInThisSlab = remainingUnits;
      }

      final double slabCost = unitInThisSlab * slab.rate;
      totalEnergyCharge += slabCost;
      remainingUnits -= unitInThisSlab;

      breakdowns.add(
        SlabBreakdown(
          slabTitle: '${slab.title} kWh',
          units: unitInThisSlab,
          rate: slab.rate,
          charge: double.parse(slabCost.toStringAsFixed(2)),
        ),
      );
    }
    final double demandCharge = loadCount * settings.demandCharge;
    final double meterRent = settings.meterRent;
    final double subtotal = totalEnergyCharge + demandCharge + meterRent;
    final double vatAmount = subtotal * (settings.vatPercentage / 100);
    final double totalPayable = subtotal + vatAmount;

    double round(double value) => double.parse(value.toStringAsFixed(2));

    return BillResult(
      consumedUnits: units,
      loadCount: loadCount,
      energyCharge: round(totalEnergyCharge),
      demandCharge: round(demandCharge),
      meterRent: round(meterRent),
      subtotal: round(subtotal),
      vatPercentage: settings.vatPercentage,
      vatAmount: round(vatAmount),
      totalPayable: round(totalPayable),
      slabBreakdowns: breakdowns,
    );
  }
}
