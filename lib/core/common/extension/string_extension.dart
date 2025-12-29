import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:skeleton/generated/l10n.dart';

extension StringExtension on String? {
  String? convertPersianDateWithSeparator(String separate){
    if(this == null) return null;
    final int? value = int.tryParse(this!);
    if(value == null) return this;

    if(this!.length == 8){
      final year = this!.substring(0,4);
      final month = this!.substring(4,6);
      final day = this!.substring(6,8);
      return '$year$separate$month$separate$day';
    }else if(this!.length == 6){
      final year = this!.substring(0,1);
      final month = this!.substring(2,3);
      final day = this!.substring(4,5);
      return '$year$separate$month$separate$day';
    }
    return this;
  }


  bool get toBool {
    if (this == null) {
      return false;
    }
    switch (this!.toLowerCase()) {
      case 'true':
        return true;
      case 'false':
        return false;
      default:
        return false;
    }
  }

  String? get currencyFormatterWithRial {
    final formatted = currencyFormatter;
    return formatted != null ? '$formatted ریال' : null;
  }

  String? get formatJalaliDate {
    final input = this;
    if (input == null ||
        input.length != 8 ||
        !RegExp(r'^\d{8}$').hasMatch(input)) {
      return '';
    }

    try {
      final year = input.substring(0, 4);
      final month = input.substring(4, 6);
      final day = input.substring(6, 8);

      final intMonth = int.parse(month);
      final intDay = int.parse(day);

      if (intMonth < 1 || intMonth > 12 || intDay < 1 || intDay > 31) {
        return '-';
      }

      return '$year/$month/$day';
    } catch (e) {
      return '-';
    }
  }

  Jalali? get toJalali {
    final temp = this;
    if (temp == null) return null;
    final date = DateTime.tryParse(temp)?.toLocal();
    if (date == null) return null;
    if (date.year < 1980) return null;
    final result = Jalali.fromDateTime(date);
    return result.copy(
      hour: date.hour,
      minute: date.minute,
      second: date.second,
    );
  }

  String? convertDateTime({bool? showYear = false}) {
    if (this == null) {
      return null;
    }
    final DateTime dateTime = DateTime.parse(this!);

    return '${DateFormat.d().format(dateTime)}th ${showYear! ? DateFormat.yMMM().format(dateTime) : DateFormat.MMM().format(dateTime)}';
  }

  String? hidden({String? character = '*'}) {
    if (this == null) {
      return null;
    }
    return this?.characters.map((e) => character).join();
  }

  String? get convertDateTimeWithYear {
    if (this == null) {
      return null;
    }
    final DateTime dateTime = DateTime.parse(this!);
    return DateFormat.yMMMEd().format(dateTime).replaceAll(',', '');
  }

  DateTime? get getDateTime {
    if (this == null) {
      return null;
    }
    return DateTime.parse(this!);
  }

  String? get titleCase {
    if (this == null) {
      return null;
    }
    return this?.replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.isNotEmpty ? '${str[0].toUpperCase()}${str.substring(1).toLowerCase()}' : '').join(' ');
  }

  String? convertDateTimeWithFormat({String? format}) {
    if (this == null) {
      return null;
    }
    if (this!.length < 4) return this;
    final String lastFour = this!.substring(this!.length - 4);
    final regex = RegExp(r'^[a-zA-Z]{4}$');
    String? value;
    if (regex.hasMatch(lastFour)) {
      value =  this!.substring(0, this!.length - 4);
    }else{
      value = this;
    }
    final DateFormat formatter = DateFormat(format ?? 'yyyy-MM-dd');
    final DateTime dateTime = DateTime.parse(value!);
    return formatter.format(dateTime.toLocal());
  }

  DateTime convertToDateTime() {
    if (this == null) {
      return DateTime.now();
    }
    if (this!.length < 4) return DateTime.now();
    final String lastFour = this!.substring(this!.length - 4);
    final regex = RegExp(r'^[a-zA-Z]{4}$');
    String value;
    if (regex.hasMatch(lastFour)) {
      value = this!.substring(0, this!.length - 4);
    } else {
      value = this!;
    }
    return DateTime.parse(value);
  }

  String? convertDateTimeToJalali({String? format}) {
    if (this == null) {
      return null;
    }

    try{
      if (this!.length < 4) return this;
      final String lastFour = this!.substring(this!.length - 4);
      final regex = RegExp(r'^[a-zA-Z]{4}$');
      String? value;
      if (regex.hasMatch(lastFour)) {
        value =  this!.substring(0, this!.length - 4);
      }else{
        value = this;
      }
      final jalali = Jalali.fromDateTime(DateTime.parse((value!)));
      final jalaliFormatter = jalali.formatter;
      switch (format) {
        case 'yyMM':
          return '${jalaliFormatter.yy}${jalaliFormatter.mm}';
        case 'yyyyMM':
          return '${jalaliFormatter.yyyy}${jalaliFormatter.mm}';
        case 'yy-MM':
          return '${jalaliFormatter.yy}-${jalaliFormatter.mm}';
        case 'DD':
          return jalaliFormatter.wN;
        case 'yyyymmdd':
          return '${jalaliFormatter.yyyy}${jalaliFormatter.mm}${jalaliFormatter.dd}';
        case 'yy/MM':
          return '${jalaliFormatter.yy}/${jalaliFormatter.mm}';
        case 'yyyy/MM/dd':
          return '${jalaliFormatter.yyyy}/${jalaliFormatter.mN}/${jalaliFormatter.dd}';
        case 'yyyy/mm/dd':
          return '${jalaliFormatter.yyyy}/${jalaliFormatter.mm}/${jalaliFormatter.dd}';
        case 'hh:mm:ss':
          return convertDateTimeWithFormat(format: 'HH:mm:ss');
        case 'hh:mm':
          return convertDateTimeWithFormat(format: 'HH:mm');
        case 'yyyy/mm/dd - hh:mm:ss':
          return '${jalaliFormatter.yyyy}/${jalaliFormatter.mm}/${jalaliFormatter.dd} - ${convertDateTimeWithFormat(format: 'HH:mm:ss')}';
        case 'yyyy/mm/dd - hh:mm':
          return '${convertDateTimeWithFormat(format: 'HH:mm')} - ${jalaliFormatter.yyyy}/${jalaliFormatter.mm}/${jalaliFormatter.dd}';
        case 'yyyy/MM/dd - hh:mm:ss':
          return '${convertDateTimeWithFormat(format: 'HH:mm:ss')}  ${jalaliFormatter.yyyy}/${jalaliFormatter.mN}/${jalaliFormatter.dd}';
        case 'yyyy/MM/dd hh:mm':
          return '${jalaliFormatter.yyyy}/${jalaliFormatter.mN}/${jalaliFormatter.dd} ${convertDateTimeWithFormat(format: 'HH:mm')}';
        default:
          return jalali.toString();
      }
    }catch(e){
      return this;
    }

  }

  String? get currencyFormatter {
    if (this == null) {
      return null;
    }
    final temp = this!.replaceAll(',', '');
    final int? amount = int.tryParse(temp.split('.').first);
    if (amount != null) {
      final formatter = NumberFormat.decimalPatternDigits(
        locale: 'en_us',
        decimalDigits: 0,
      );
      return formatter.format(amount);
    }
    return this;
  }

  String? get convertNumberToPersian {
    if (this == null) {
      return null;
    }
    String input = this!;

    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const farsi = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

    for (int i = 0; i < english.length; i++) {
      final temp = input.replaceAll(english[i], farsi[i]);
      input = temp;
    }

    return input;
  }

  String? get convertDateTimeToZeroTime{
    return '${this}T00:00:00'.convertNumberToEnglish;
  }
  String? get convertDateTimeToLastTime{
    return '${this}T23:59:59'.convertNumberToEnglish;
  }

  String? get convertNumberToEnglish {
    if (this == null) {
      return null;
    }
    String value = this!;
    value = value.replaceAll('۰', '0');
    value = value.replaceAll('۱', '1');
    value = value.replaceAll('۲', '2');
    value = value.replaceAll('۳', '3');
    value = value.replaceAll('۴', '4');
    value = value.replaceAll('۵', '5');
    value = value.replaceAll('۶', '6');
    value = value.replaceAll('۷', '7');
    value = value.replaceAll('۸', '8');
    value = value.replaceAll('۹', '9');
    return value;
  }

  String? get chequeSerialFormatter {
    if (this == null) {
      return null;
    }
    final String value = this!;
    return '${value[0]}${value[1]}/${value.substring(2)}';
  }

  String? get percentage {
    if (this == null) {
      return null;
    }
    return '${this!.split('.').first} ${S.current.percentage}';
  }

  String? get removeExtraZeroFromDecimal {
    if (this == null) {
      return null;
    }
    final RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    return this!.replaceAll(regex, '');
  }

  String? get removeThousandSeperator {
    if (this == null) {
      return null;
    }
    return this!.replaceAll(',', '').replaceAll('.', '');
  }

  String normalizePersian() {
    if (this == null) {
      return '';
    }
    return this!.replaceAll('ي', 'ی').replaceAll('ك', 'ک').trim();
  }


  String get convertSpaceToHalfSpace {
    return this!.replaceAll('_', '\u200c');
  }
}
