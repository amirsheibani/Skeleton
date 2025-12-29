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
