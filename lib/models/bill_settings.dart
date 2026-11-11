class BillingSettings {
  final double vatPercentage;
  final double demandCharge;
  final double meterRent;
  final String currency;
  final String customerType;

  const BillingSettings({
    required this.vatPercentage,
    required this.demandCharge,
    required this.meterRent,
    required this.currency,
    required this.customerType,
  });

  factory BillingSettings.fromJson(Map<String, dynamic> json) {
    return BillingSettings(
      vatPercentage: (json['vatPercentage'] as num).toDouble(),
      demandCharge: (json['demandCharge'] as num).toDouble(),
      meterRent: (json['meterRent'] as num).toDouble(),
      currency: json['currency'] == 'BDT' ? '৳' : json['currency'] as String,
      customerType: json['customerType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vatPercentage': vatPercentage,
      'demandCharge': demandCharge,
      'meterRent': meterRent,
      'currency': currency,
      'customerType': customerType,
    };
  }

  BillingSettings copyWith({
    double? vatPercentage,
    double? demandCharge,
    double? meterRent,
    String? currency,
    String? customerType,
  }) {
    return BillingSettings(
      vatPercentage: vatPercentage ?? this.vatPercentage,
      demandCharge: demandCharge ?? this.demandCharge,
      meterRent: meterRent ?? this.meterRent,
      currency: currency ?? this.currency,
      customerType: customerType ?? this.customerType,
    );
  }
}