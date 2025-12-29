
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:skeleton/core/common/extension/int_extension.dart';

extension JalaliExt on Jalali {
  String get expDate {
    final finalYear = '$year'.substring(2);
    return '$finalYear/${month.toTwoDigit}';
  }

  String get toPersianString {
    return '${hour.toTwoDigit}:${minute.toTwoDigit} $year/${month.toTwoDigit}/${day.toTwoDigit}';
  }

  String get toHourPersianString {
    return '${hour.toTwoDigit}:${minute.toTwoDigit}';
  }

  String get toHourPersianStringWithSecond {
    return '${hour.toTwoDigit}:${minute.toTwoDigit}:${second.toTwoDigit}';
  }

  String get toDatePersianString {
    return '$year/${month.toTwoDigit}/${day.toTwoDigit}';
  }

  String get toDateAndHourPersianString {
    return '${hour.toTwoDigit}:${minute.toTwoDigit}:${second.toTwoDigit} - $year/${month.toTwoDigit}/${day.toTwoDigit}';
  }

  String get toDatePersianStringWithDay {
    final formatter = JalaliFormatter(this);
    return '${day.toTwoDigit} ${formatter.mN} $year';
  }

  String get toWeekName => JalaliFormatter(this).wN;

  String get toTimePersianString {
    return '${hour.toTwoDigit}:${minute.toTwoDigit}:${second.toTwoDigit}';
  }

  String get toPersianStringWithDetails {
    return '${hour.toTwoDigit}:${minute.toTwoDigit}:${second.toTwoDigit} $year/${month.toTwoDigit}/${day.toTwoDigit}';
  }

  String get toPersianStringWithDashSeparator {
    return '${hour.toTwoDigit}:${minute.toTwoDigit}:${second.toTwoDigit} - $year/${month.toTwoDigit}/${day.toTwoDigit}';
  }

  String get toPersianTimeString {
    return '${hour.toTwoDigit}:${minute.toTwoDigit}';
  }

  String get toPersianTimeStringWithSecond {
    return '${hour.toTwoDigit}:${minute.toTwoDigit}:${second.toTwoDigit}';
  }



  List<int> get montDays{
    final firstDay = Jalali(year,month,1);
    final daysInMonth = firstDay.monthLength;
    return List.generate(daysInMonth, (index) => index + 1);
  }

  Map<int,String> get months{
    final firstDay = Jalali(year,1,1);
    final months = <int,String>{};
    for(int index = 1; index <= 12; index++){
      final date = Jalali(year, index, 1);
      months[index] = date.formatter.mN;
    }
    return months;
  }

}