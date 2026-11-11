class SlabBreakdown {
  final String slabTitle;
  final double units;
  final double rate;
  final double charge;

  const SlabBreakdown({
    required this.slabTitle,
    required this.units,
    required this.rate,
    required this.charge,
  });
}

class BillResult {
  final double consumedUnits;
  final int loadCount;
  final double energyCharge;
  final double demandCharge;
  final double meterRent;
  final double subtotal;
  final double vatPercentage;
  final double vatAmount;
  final double totalPayable;
  final List<SlabBreakdown> slabBreakdowns;

  const BillResult({
    required this.consumedUnits,
    required this.loadCount,
    required this.energyCharge,
    required this.demandCharge,
    required this.meterRent,
    required this.subtotal,
    required this.vatPercentage,
    required this.vatAmount,
    required this.totalPayable,
    required this.slabBreakdowns,
  });
}