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
    "already_have_account": MessageLookupByLibrary.simpleMessage(
      "Already have an account? ",
    ),
    "bad_certificate": MessageLookupByLibrary.simpleMessage(
      "Certificate is not Valid",
    ),
    "bad_request": MessageLookupByLibrary.simpleMessage("Bad Request"),
    "confirm_password": MessageLookupByLibrary.simpleMessage(
      "Confirm password",
    ),
    "connection_request_timeout": MessageLookupByLibrary.simpleMessage(
      "Server Timeout",
    ),
    "dark": MessageLookupByLibrary.simpleMessage("Dark"),
    "dont_have_account": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account? ",
    ),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "email_placeholder": MessageLookupByLibrary.simpleMessage("abc@email.com"),
    "english": MessageLookupByLibrary.simpleMessage("English"),
    "error_due_to_a_conflict": m0,
    "forgot_password": MessageLookupByLibrary.simpleMessage("Forgot Password?"),
    "full_name": MessageLookupByLibrary.simpleMessage("Full name"),
    "internal_server_error": MessageLookupByLibrary.simpleMessage(
      "Server Internal Error",
    ),
    "light": MessageLookupByLibrary.simpleMessage("Light"),
    "login_with_facebook": MessageLookupByLibrary.simpleMessage(
      "Login with Facebook",
    ),
    "login_with_google": MessageLookupByLibrary.simpleMessage(
      "Login with Google",
    ),
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
    "or": MessageLookupByLibrary.simpleMessage("OR"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "percentage": MessageLookupByLibrary.simpleMessage("Percentage"),
    "persian": MessageLookupByLibrary.simpleMessage("Persian"),
    "remember_me": MessageLookupByLibrary.simpleMessage("Remember Me"),
    "request_cancelled": MessageLookupByLibrary.simpleMessage(
      "Cancelled Request",
    ),
    "send_timeout_in_connection_with_api_server":
        MessageLookupByLibrary.simpleMessage("Server Timeout"),
    "service_unavailable": MessageLookupByLibrary.simpleMessage(
      "Service is Unavailable",
    ),
    "sign_in": MessageLookupByLibrary.simpleMessage("Sign in"),
    "sign_in_button": MessageLookupByLibrary.simpleMessage("SIGN IN"),
    "sign_up": MessageLookupByLibrary.simpleMessage("Sign up"),
    "sign_up_button": MessageLookupByLibrary.simpleMessage("SIGN UP"),
    "system": MessageLookupByLibrary.simpleMessage("System"),
    "unable_to_process_the_data": m1,
    "unauthorised_request": MessageLookupByLibrary.simpleMessage(
      "This request demand Authorization",
    ),
    "unexpected_error_occurred": MessageLookupByLibrary.simpleMessage(
      "Unexpected Error occurred",
    ),
    "validation_confirm_password_required":
        MessageLookupByLibrary.simpleMessage("Please confirm your password"),
    "validation_email_invalid": MessageLookupByLibrary.simpleMessage(
      "Invalid email",
    ),
    "validation_email_required": MessageLookupByLibrary.simpleMessage(
      "Please enter your email",
    ),
    "validation_full_name_invalid": MessageLookupByLibrary.simpleMessage(
      "Please enter your first and last name",
    ),
    "validation_full_name_required": MessageLookupByLibrary.simpleMessage(
      "Please enter your full name",
    ),
    "validation_password_min_length": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 6 characters",
    ),
    "validation_password_required": MessageLookupByLibrary.simpleMessage(
      "Please enter your password",
    ),
    "validation_passwords_not_match": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match",
    ),
    "your_connection_is_failed": MessageLookupByLibrary.simpleMessage(
      "Connection Failed!",
    ),
    "your_password": MessageLookupByLibrary.simpleMessage("Your password"),
  };
}
