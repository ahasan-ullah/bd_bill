import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat('#,##0.00', 'en_US');

  /// Formats amount into standard Bangladeshi Taka notation, e.g. ৳1,717.81
  static String format(double amount, {String symbol = '৳'}) {
    return '$symbol${_formatter.format(amount)}';
  }

  /// Formats double with commas without symbol, e.g. 1,717.81
  static String formatNumber(double number) {
    return _formatter.format(number);
  }
}
