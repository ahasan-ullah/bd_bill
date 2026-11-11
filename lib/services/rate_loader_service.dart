import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/bill_settings.dart';
import '../models/tariff_slab.dart';

class InitialRatesData {
  final BillingSettings settings;
  final List<TariffSlab> slabs;
  final int defaultLoad;

  const InitialRatesData({
    required this.settings,
    required this.slabs,
    required this.defaultLoad,
  });
}

class RateLoaderService {
  static Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/electricity-rates.json');
  }

  static Future<InitialRatesData> loadFromAsset() async {
    // 1. Check if user-saved rates exist in local app storage
    try {
      final localFile = await _getLocalFile();
      if (await localFile.exists()) {
        final content = await localFile.readAsString();
        return _parseJson(content);
      }
    } catch (_) {}

    // 2. Check if local workspace dev file exists
    try {
      final devFile = File('assets/json/electricity-rates.json');
      if (devFile.existsSync()) {
        final content = devFile.readAsStringSync();
        return _parseJson(content);
      }
    } catch (_) {}

    // 3. Fallback to bundled asset
    final String jsonString = await rootBundle.loadString(
      'assets/json/electricity-rates.json',
    );
    return _parseJson(jsonString);
  }

  static InitialRatesData _parseJson(String jsonString) {
    final Map<String, dynamic> data =
        jsonDecode(jsonString) as Map<String, dynamic>;

    final settings = BillingSettings.fromJson(data);

    final slabList = (data['slabs'] as List<dynamic>)
        .map((item) => TariffSlab.fromJson(item as Map<String, dynamic>))
        .toList();

    final defaultLoad = (data['loadCount'] as num?)?.toInt() ?? 1;

    return InitialRatesData(
      settings: settings,
      slabs: slabList,
      defaultLoad: defaultLoad,
    );
  }

  /// Persists updated rates directly to local storage & dev asset file
  static Future<void> saveRates({
    required BillingSettings settings,
    required List<TariffSlab> slabs,
    required int loadCount,
  }) async {
    final Map<String, dynamic> data = {
      ...settings.toJson(),
      'currency': settings.currency == '৳' ? 'BDT' : settings.currency,
      'loadCount': loadCount,
      'slabs': slabs.map((s) => s.toJson()).toList(),
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(data);

    // Save to device local app documents directory (persists on real phone)
    try {
      final localFile = await _getLocalFile();
      await localFile.writeAsString(jsonString);
    } catch (_) {}

    // Also save directly to dev workspace assets file if accessible
    try {
      final devFile = File('assets/json/electricity-rates.json');
      if (devFile.existsSync()) {
        devFile.writeAsStringSync(jsonString);
      }
    } catch (_) {}
  }
}
