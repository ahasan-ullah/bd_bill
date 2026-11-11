class TariffSlab {
  final String id;
  final String title;
  final int fromUnit;
  final int? toUnit;
  final int? maxUnit;
  final double rate;

  const TariffSlab({
    required this.id,
    required this.title,
    required this.fromUnit,
    this.toUnit,
    this.maxUnit,
    required this.rate,
  });

  double? get maxCharge => maxUnit != null ? (maxUnit! * rate) : null;

  factory TariffSlab.fromJson(Map<String,dynamic> json){
    return TariffSlab(
      id: json['id'] as String,
      title: json['title'] as String,
      fromUnit: json['fromUnit'] as int,
      toUnit: json['toUnit'] as int?,
      maxUnit: json['maxUnit'] as int?,
      rate: (json['rate'] as num).toDouble(),
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'id': id,
      'title': title,
      'fromUnit': fromUnit,
      'toUnit': toUnit,
      'maxUnit': maxUnit,
      'rate': rate,
    };
  }

    TariffSlab copyWith({
    String? id,
    String? title,
    int? fromUnit,
    int? toUnit,
    int? maxUnit,
    double? rate,
  }) {
    return TariffSlab(
      id: id ?? this.id,
      title: title ?? this.title,
      fromUnit: fromUnit ?? this.fromUnit,
      toUnit: toUnit ?? this.toUnit,
      maxUnit: maxUnit ?? this.maxUnit,
      rate: rate ?? this.rate,
    );
  }
}
