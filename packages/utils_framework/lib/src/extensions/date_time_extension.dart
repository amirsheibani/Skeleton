import 'dart:math';
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'jalali_extension.dart';
import 'string_extension.dart';

extension DateTimeExtension on DateTime {

  String convertDateTimeWithFormat({String? format}) {
    final DateFormat formatter = DateFormat(format ?? 'yyyy-MM-dd');
    return formatter.format(this);
  }

  String convertDateTimeToJalali({String? format}) {
    final String value = toString();
    return value.convertDateTimeToJalali(format: format) ?? '-';
  }

  DateTime get endOfDay {
    return copyWith(hour: 23, minute: 59, second: 59);
  }
  DateTime get startOfTheDay {
    return copyWith(hour: 00, minute: 00, second: 00);
  }

  DateTime oneMonthBefore() {
    int year = this.year;
    int month = this.month - 1;
    if (month < 1) {
      month = 12;
      year -= 1;
    }
    int day = this.day;
    final int lastDayOfPrevMonth = DateTime(year, month + 1, 0).day;
    day += 1;
    if (day > lastDayOfPrevMonth) {
      day = lastDayOfPrevMonth;
    }
    return DateTime(year, month, day, hour, minute, second, millisecond, microsecond);
  }

  DateTime subtractJalaliMonths(int monthsToSubtract) {
    final j = Jalali.fromDateTime(this);

    final totalMonths = j.year * 12 + (j.month - 1) - monthsToSubtract;
    final newYear = totalMonths ~/ 12;
    final newMonth = (totalMonths % 12) + 1;

    final newDay = min(j.day, Jalali(newYear, newMonth, 1).monthLength);

    return Jalali(newYear, newMonth, newDay).toDateTime();
  }
  String subtractJalaliMonthsAndConvertToJalali(int monthsToSubtract, {String? format = 'yyyy/MM/dd'}) {
    final newDate = subtractJalaliMonths(monthsToSubtract);
    final j = Jalali.fromDateTime(newDate);
    final f = j.formatter;
    switch (format) {
      case 'yyyy/MM/dd':
      case 'yyyy/mm/dd':
        return '${f.yyyy}/${f.mm}/${f.dd}';
      default:
        return '${f.yyyy}/${f.mm}/${f.dd}';
    }
  }

}
