import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

extension StringExtension on int {
  bool toBool() {
    return this > 0;
  }

  String numberFormat() {
    final formatter = NumberFormat('#,##0', 'en_US');
    return formatter.format(this);
  }

  String get toTwoDigit => this < 10 ? '0$this' : '$this';

  String get toCurrencyString {
    if (this == 0) return '';
    return '$this';
  }

}


extension PersianOrdinalExtension on int {
  String toPersianOrdinal() {
    const ordinals = [
      '',
      'یکم',
      'دوم',
      'سوم',
      'چهارم',
      'پنجم',
      'ششم',
      'هفتم',
      'هشتم',
      'نهم',
      'دهم',
      'یازدهم',
      'دوازدهم',
      'سیزدهم',
      'چهاردهم',
      'پانزدهم',
      'شانزدهم',
      'هفدهم',
      'هجدهم',
      'نوزدهم',
      'بیستم',
      'بیست و یکم',
      'بیست و دوم',
      'بیست و سوم',
      'بیست و چهارم',
      'بیست و پنجم',
      'بیست و ششم',
      'بیست و هفتم',
      'بیست و هشتم',
      'بیست و نهم',
      'سی ام',
      'سی و یکم',
    ];

    if (this >= 1 && this <= 31) {
      return ordinals[this];
    } else {
      if (kDebugMode) {
        print('Supported range is 1 to 31.');
      }
      return toString();
    }
  }

  String toPersianRank() {
    const ordinals = [
      '',
      'اول',
      'دوم',
      'سوم',
      'چهارم',
      'پنجم',
      'ششم',
      'هفتم',
      'هشتم',
      'نهم',
      'دهم',
    ];

    if (this >= 1 && this <= 10) {
      return ordinals[this];
    } else {
      if (kDebugMode) {
        print('Supported range is 1 to 10.');
      }
      return toString();
    }
  }
}

