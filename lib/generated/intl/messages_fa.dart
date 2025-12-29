// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fa locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'fa';

  static String m0(message) => "خطا به دلیل تضاد${message}";

  static String m1(message) => "پردازش داده ها ممکن نیست ${message}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "END_OF_FILE": MessageLookupByLibrary.simpleMessage(""),
    "bad_certificate": MessageLookupByLibrary.simpleMessage(
      "گواهی مورد تایید نیست",
    ),
    "bad_request": MessageLookupByLibrary.simpleMessage("درخواست اشتباه"),
    "connection_request_timeout": MessageLookupByLibrary.simpleMessage(
      "مهلت زمانی در ارتباط با سرور تموم شده",
    ),
    "dark": MessageLookupByLibrary.simpleMessage("تیره"),
    "english": MessageLookupByLibrary.simpleMessage("انگلیسی"),
    "error_due_to_a_conflict": m0,
    "internal_server_error": MessageLookupByLibrary.simpleMessage(
      "خطای داخلی سرور",
    ),
    "light": MessageLookupByLibrary.simpleMessage("روشن"),
    "method_not_allowed": MessageLookupByLibrary.simpleMessage(
      "روش غیر مجاز هست",
    ),
    "need_force_app_update": MessageLookupByLibrary.simpleMessage(
      "نیاز به آپدیت اپلیکیشن",
    ),
    "no_internet_connection": MessageLookupByLibrary.simpleMessage(
      "دسترسی به اینترنت وجود ندارد",
    ),
    "not_acceptable": MessageLookupByLibrary.simpleMessage("قابل قبول نیست"),
    "not_found": MessageLookupByLibrary.simpleMessage("پیدا نشد"),
    "not_implemented": MessageLookupByLibrary.simpleMessage("پیاده سازی نشده"),
    "percentage": MessageLookupByLibrary.simpleMessage("درصد"),
    "persian": MessageLookupByLibrary.simpleMessage("فارسی"),
    "request_cancelled": MessageLookupByLibrary.simpleMessage(
      "درخواست کنسل شده",
    ),
    "send_timeout_in_connection_with_api_server":
        MessageLookupByLibrary.simpleMessage(
          "مهلت زمانی در ارتباط با سرور تموم شده",
        ),
    "service_unavailable": MessageLookupByLibrary.simpleMessage(
      "سرویس در دسترس نمیباشد",
    ),
    "unable_to_process_the_data": m1,
    "unauthorised_request": MessageLookupByLibrary.simpleMessage(
      "این درخواست نیاز به اعتبار سنجی دارد",
    ),
    "unexpected_error_occurred": MessageLookupByLibrary.simpleMessage(
      "خطای غیرمنتظره ای رخ داد",
    ),
    "your_connection_is_failed": MessageLookupByLibrary.simpleMessage(
      "اتصال شما ناموفق است",
    ),
  };
}
