// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(message) => "Error due to a conflict with ${message}";

  static String m1(message) => "Unable to process, ${message}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "END_OF_FILE": MessageLookupByLibrary.simpleMessage(""),
    "bad_certificate": MessageLookupByLibrary.simpleMessage(
      "Certificate is not Valid",
    ),
    "bad_request": MessageLookupByLibrary.simpleMessage("Bad Request"),
    "connection_request_timeout": MessageLookupByLibrary.simpleMessage(
      "Server Timeout",
    ),
    "dark": MessageLookupByLibrary.simpleMessage("Dark"),
    "english": MessageLookupByLibrary.simpleMessage("English"),
    "error_due_to_a_conflict": m0,
    "internal_server_error": MessageLookupByLibrary.simpleMessage(
      "Server Internal Error",
    ),
    "light": MessageLookupByLibrary.simpleMessage("Light"),
    "method_not_allowed": MessageLookupByLibrary.simpleMessage(
      "Method not allowed",
    ),
    "need_force_app_update": MessageLookupByLibrary.simpleMessage(
      "App must be updated",
    ),
    "no_internet_connection": MessageLookupByLibrary.simpleMessage(
      "No Internet Connection",
    ),
    "not_acceptable": MessageLookupByLibrary.simpleMessage("Not Acceptable"),
    "not_found": MessageLookupByLibrary.simpleMessage("Not Found"),
    "not_implemented": MessageLookupByLibrary.simpleMessage("Not Implemented"),
    "percentage": MessageLookupByLibrary.simpleMessage("Percentage"),
    "persian": MessageLookupByLibrary.simpleMessage("Persian"),
    "request_cancelled": MessageLookupByLibrary.simpleMessage(
      "Cancelled Request",
    ),
    "send_timeout_in_connection_with_api_server":
        MessageLookupByLibrary.simpleMessage("Server Timeout"),
    "service_unavailable": MessageLookupByLibrary.simpleMessage(
      "Service is Unavailable",
    ),
    "unable_to_process_the_data": m1,
    "unauthorised_request": MessageLookupByLibrary.simpleMessage(
      "This request demand Authorization",
    ),
    "unexpected_error_occurred": MessageLookupByLibrary.simpleMessage(
      "Unexpected Error occurred",
    ),
    "your_connection_is_failed": MessageLookupByLibrary.simpleMessage(
      "Connection Failed!",
    ),
  };
}
