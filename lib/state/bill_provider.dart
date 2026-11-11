import 'package:bd_bill/models/bill_result.dart';
import 'package:bd_bill/models/bill_settings.dart';
import 'package:bd_bill/models/tariff_slab.dart';
import 'package:bd_bill/services/bill_calculator.dart';
import 'package:bd_bill/services/rate_loader_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final initialRatesProvider = FutureProvider<InitialRatesData>((ref) async {
  return await RateLoaderService.loadFromAsset();
});

class TariffSlabsNotifier extends Notifier<List<TariffSlab>> {
  @override
  List<TariffSlab> build() {
    final initial = ref.watch(initialRatesProvider).value;
    return initial?.slabs ?? [];
  }

  void updateRate(int index, double newRate) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) state[i].copyWith(rate: newRate) else state[i],
    ];
  }

  void updateRange(int index, String newRange) {
    final parts = newRange.split(RegExp(r'[-–—]'));
    int? from;
    int? to;
    int? maxUnit;
    if (parts.length == 2) {
      from = int.tryParse(parts[0].trim());
      to = int.tryParse(parts[1].trim());
      if (from != null && to != null) {
        maxUnit = to - from + 1;
      }
    }
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          state[i].copyWith(
            title: newRange,
            fromUnit: from ?? state[i].fromUnit,
            toUnit: to ?? state[i].toUnit,
            maxUnit: maxUnit ?? state[i].maxUnit,
          )
        else
          state[i],
    ];
  }

  void removeSlab(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i],
    ];
  }

  void addSlab(TariffSlab newSlab) {
    state = [...state, newSlab];
  }

  void reset(List<TariffSlab> defaults) {
    state = List.from(defaults);
  }
}

final tariffSlabsProvider =
    NotifierProvider<TariffSlabsNotifier, List<TariffSlab>>(
      TariffSlabsNotifier.new,
    );

class BillingSettingsNotifier extends Notifier<BillingSettings> {
  @override
  BillingSettings build() {
    final initial = ref.watch(initialRatesProvider).value;
    return initial?.settings ??
        const BillingSettings(
          vatPercentage: 5,
          demandCharge: 42,
          meterRent: 40,
          currency: '৳',
          customerType: 'Residential',
        );
  }

  void updateVat(double vat) {
    state = state.copyWith(vatPercentage: vat);
  }

  void updateDemandCharge(double charge) {
    state = state.copyWith(demandCharge: charge);
  }

  void updateMeterRent(double rent) {
    state = state.copyWith(meterRent: rent);
  }

  void reset(BillingSettings defaults) {
    state = defaults;
  }
}

final billingSettingsProvider =
    NotifierProvider<BillingSettingsNotifier, BillingSettings>(
      BillingSettingsNotifier.new,
    );

class ConsumedUnitsNotifier extends Notifier<double> {
  @override
  double build() => 0.0;

  void setUnits(double units) {
    state = units;
  }
}

final consumedUnitsProvider = NotifierProvider<ConsumedUnitsNotifier, double>(
  ConsumedUnitsNotifier.new,
);

class LoadCountNotifier extends Notifier<int> {
  @override
  int build() {
    final initial = ref.watch(initialRatesProvider).value;
    return initial?.defaultLoad ?? 1;
  }

  void increment() {
    if (state < 8) state++;
  }

  void decrement() {
    if (state > 1) state--;
  }

  void setLoad(int load) {
    if (load >= 1 && load <= 8) state = load;
  }
}

final loadCountProvider = NotifierProvider<LoadCountNotifier, int>(
  LoadCountNotifier.new,
);

final calculatedBillProvider = Provider<BillResult>((ref) {
  final units = ref.watch(consumedUnitsProvider);
  final load = ref.watch(loadCountProvider);
  final slabs = ref.watch(tariffSlabsProvider);
  final settings = ref.watch(billingSettingsProvider);

  return BillCalculator.calculate(
    units: units,
    loadCount: load,
    slabs: slabs,
    settings: settings,
  );
});
