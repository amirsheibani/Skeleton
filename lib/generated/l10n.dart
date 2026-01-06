// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Persian`
  String get persian {
    return Intl.message('Persian', name: 'persian', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Dark`
  String get dark {
    return Intl.message('Dark', name: 'dark', desc: '', args: []);
  }

  /// `Light`
  String get light {
    return Intl.message('Light', name: 'light', desc: '', args: []);
  }

  /// `System`
  String get system {
    return Intl.message('System', name: 'system', desc: '', args: []);
  }

  /// `Percentage`
  String get percentage {
    return Intl.message('Percentage', name: 'percentage', desc: '', args: []);
  }

  /// `Not Implemented`
  String get not_implemented {
    return Intl.message(
      'Not Implemented',
      name: 'not_implemented',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled Request`
  String get request_cancelled {
    return Intl.message(
      'Cancelled Request',
      name: 'request_cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Server Internal Error`
  String get internal_server_error {
    return Intl.message(
      'Server Internal Error',
      name: 'internal_server_error',
      desc: '',
      args: [],
    );
  }

  /// `Not Found`
  String get not_found {
    return Intl.message('Not Found', name: 'not_found', desc: '', args: []);
  }

  /// `Service is Unavailable`
  String get service_unavailable {
    return Intl.message(
      'Service is Unavailable',
      name: 'service_unavailable',
      desc: '',
      args: [],
    );
  }

  /// `Method not allowed`
  String get method_not_allowed {
    return Intl.message(
      'Method not allowed',
      name: 'method_not_allowed',
      desc: '',
      args: [],
    );
  }

  /// `Bad Request`
  String get bad_request {
    return Intl.message('Bad Request', name: 'bad_request', desc: '', args: []);
  }

  /// `This request demand Authorization`
  String get unauthorised_request {
    return Intl.message(
      'This request demand Authorization',
      name: 'unauthorised_request',
      desc: '',
      args: [],
    );
  }

  /// `Unexpected Error occurred`
  String get unexpected_error_occurred {
    return Intl.message(
      'Unexpected Error occurred',
      name: 'unexpected_error_occurred',
      desc: '',
      args: [],
    );
  }

  /// `Server Timeout`
  String get send_timeout_in_connection_with_api_server {
    return Intl.message(
      'Server Timeout',
      name: 'send_timeout_in_connection_with_api_server',
      desc: '',
      args: [],
    );
  }

  /// `No Internet Connection`
  String get no_internet_connection {
    return Intl.message(
      'No Internet Connection',
      name: 'no_internet_connection',
      desc: '',
      args: [],
    );
  }

  /// `Error due to a conflict with {message}`
  String error_due_to_a_conflict(Object message) {
    return Intl.message(
      'Error due to a conflict with $message',
      name: 'error_due_to_a_conflict',
      desc: '',
      args: [message],
    );
  }

  /// `Server Timeout`
  String get connection_request_timeout {
    return Intl.message(
      'Server Timeout',
      name: 'connection_request_timeout',
      desc: '',
      args: [],
    );
  }

  /// `Unable to process, {message}`
  String unable_to_process_the_data(Object message) {
    return Intl.message(
      'Unable to process, $message',
      name: 'unable_to_process_the_data',
      desc: '',
      args: [message],
    );
  }

  /// `Not Acceptable`
  String get not_acceptable {
    return Intl.message(
      'Not Acceptable',
      name: 'not_acceptable',
      desc: '',
      args: [],
    );
  }

  /// `App must be updated`
  String get need_force_app_update {
    return Intl.message(
      'App must be updated',
      name: 'need_force_app_update',
      desc: '',
      args: [],
    );
  }

  /// `Certificate is not Valid`
  String get bad_certificate {
    return Intl.message(
      'Certificate is not Valid',
      name: 'bad_certificate',
      desc: '',
      args: [],
    );
  }

  /// `Connection Failed!`
  String get your_connection_is_failed {
    return Intl.message(
      'Connection Failed!',
      name: 'your_connection_is_failed',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get sign_in {
    return Intl.message('Sign in', name: 'sign_in', desc: '', args: []);
  }

  /// `Sign up`
  String get sign_up {
    return Intl.message('Sign up', name: 'sign_up', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `abc@email.com`
  String get email_placeholder {
    return Intl.message(
      'abc@email.com',
      name: 'email_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Your password`
  String get your_password {
    return Intl.message(
      'Your password',
      name: 'your_password',
      desc: '',
      args: [],
    );
  }

  /// `Full name`
  String get full_name {
    return Intl.message('Full name', name: 'full_name', desc: '', args: []);
  }

  /// `Confirm password`
  String get confirm_password {
    return Intl.message(
      'Confirm password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Remember Me`
  String get remember_me {
    return Intl.message('Remember Me', name: 'remember_me', desc: '', args: []);
  }

  /// `Forgot Password?`
  String get forgot_password {
    return Intl.message(
      'Forgot Password?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `SIGN IN`
  String get sign_in_button {
    return Intl.message('SIGN IN', name: 'sign_in_button', desc: '', args: []);
  }

  /// `SIGN UP`
  String get sign_up_button {
    return Intl.message('SIGN UP', name: 'sign_up_button', desc: '', args: []);
  }

  /// `OR`
  String get or {
    return Intl.message('OR', name: 'or', desc: '', args: []);
  }

  /// `Login with Google`
  String get login_with_google {
    return Intl.message(
      'Login with Google',
      name: 'login_with_google',
      desc: '',
      args: [],
    );
  }

  /// `Login with Facebook`
  String get login_with_facebook {
    return Intl.message(
      'Login with Facebook',
      name: 'login_with_facebook',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? `
  String get dont_have_account {
    return Intl.message(
      'Don\'t have an account? ',
      name: 'dont_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? `
  String get already_have_account {
    return Intl.message(
      'Already have an account? ',
      name: 'already_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get validation_email_required {
    return Intl.message(
      'Please enter your email',
      name: 'validation_email_required',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email`
  String get validation_email_invalid {
    return Intl.message(
      'Invalid email',
      name: 'validation_email_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get validation_password_required {
    return Intl.message(
      'Please enter your password',
      name: 'validation_password_required',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get validation_password_min_length {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'validation_password_min_length',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your full name`
  String get validation_full_name_required {
    return Intl.message(
      'Please enter your full name',
      name: 'validation_full_name_required',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your first and last name`
  String get validation_full_name_invalid {
    return Intl.message(
      'Please enter your first and last name',
      name: 'validation_full_name_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your password`
  String get validation_confirm_password_required {
    return Intl.message(
      'Please confirm your password',
      name: 'validation_confirm_password_required',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get validation_passwords_not_match {
    return Intl.message(
      'Passwords do not match',
      name: 'validation_passwords_not_match',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get END_OF_FILE {
    return Intl.message('', name: 'END_OF_FILE', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fa'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
