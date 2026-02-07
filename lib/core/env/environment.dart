base class Environment {
  String? baseUrl;
  String? apiVersion;
  String? mapToken;
  String? appId;
  bool? showRuntimeLog;
  String? url;
  bool? showChucker;
  bool? showPrettyLog;
  String? supabaseUrl;
  String? supabaseAnonKey;

  Environment(
      {required this.baseUrl,
      required this.apiVersion,
      required this.mapToken,
      required this.appId,
        required this.showRuntimeLog,
        required this.showChucker,
        required this.showPrettyLog,
        required this.supabaseUrl,
        required this.supabaseAnonKey,
      });
}

final class DevEnvironment extends Environment {

  @override
  String get url {
    if(super.apiVersion?.isEmpty ?? true){
      return super.baseUrl!;
    }
    return '${super.baseUrl!}/gateway/${super.apiVersion}/';
  }

  @override
  bool get showRuntimeLog {
    return super.showRuntimeLog ?? false;
  }

  @override
  String get baseUrl {
    return super.baseUrl ?? '';
  }

  @override
  String get apiVersion {
    return super.apiVersion ?? '';
  }

  @override
  String get mapToken {
    return super.mapToken ?? '';
  }

  @override
  String get appId {
    return super.appId ?? '';
  }

  @override
  bool get showChucker {
    return super.showChucker ?? false;
  }

  @override
  bool get showPrettyLog {
    return super.showPrettyLog ?? false;
  }

  @override
  String get supabaseUrl {
    return super.supabaseUrl ?? '';
  }

  @override
  String get supabaseAnonKey {
    return super.supabaseAnonKey ?? '';
  }

  DevEnvironment(
      {required super.baseUrl,
      required super.apiVersion,
      required super.mapToken,
      required super.appId,
        required super.showRuntimeLog,
        required super.showChucker,
        required super.showPrettyLog,
        required super.supabaseUrl,
        required super.supabaseAnonKey,
      });
}

final class StageEnvironment extends Environment {
  @override
  String get supabaseUrl {
    return super.supabaseUrl ?? '';
  }

  @override
  String get supabaseAnonKey {
    return super.supabaseAnonKey ?? '';
  }

  StageEnvironment(
      {required super.baseUrl,
      required super.apiVersion,
      required super.mapToken,
        required super.appId,
        required super.showRuntimeLog,
        required super.showChucker,
        required super.showPrettyLog,
        required super.supabaseUrl,
        required super.supabaseAnonKey,
      });

  @override
  String get url {
    if(super.apiVersion?.isEmpty ?? true){
      return super.baseUrl!;
    }
    return '${super.baseUrl!}/gateway/${super.apiVersion}/';
  }

  @override
  bool get showRuntimeLog {
    return super.showRuntimeLog ?? false;
  }

  @override
  String get baseUrl {
    return super.baseUrl ?? '';
  }

  @override
  String get apiVersion {
    return super.apiVersion ?? '';
  }

  @override
  String get mapToken {
    return super.mapToken ?? '';
  }

  @override
  String get appId {
    return super.appId ?? '';
  }

  @override
  bool get showChucker {
    return super.showChucker ?? false;
  }

  @override
  bool get showPrettyLog {
    return super.showPrettyLog ?? false;
  }
}


final class ProdEnvironment extends Environment {
  @override
  String get supabaseUrl {
    return super.supabaseUrl ?? '';
  }

  @override
  String get supabaseAnonKey {
    return super.supabaseAnonKey ?? '';
  }

  ProdEnvironment(
      {required super.baseUrl,
      required super.apiVersion,
      required super.mapToken,
      required super.appId,
        required super.showRuntimeLog,
        required super.showChucker,
        required super.showPrettyLog,
        required super.supabaseUrl,
        required super.supabaseAnonKey,
      });

  @override
  String get url {
    if(super.apiVersion?.isEmpty ?? true){
      return super.baseUrl!;
    }
    return '${super.baseUrl!}/gateway/${super.apiVersion}/';
  }

  @override
  bool get showRuntimeLog {
    return super.showRuntimeLog ?? false;
  }

  @override
  String get baseUrl {
    return super.baseUrl ?? '';
  }

  @override
  String get apiVersion {
    return super.apiVersion ?? '';
  }

  @override
  String get mapToken {
    return super.mapToken ?? '';
  }

  @override
  String get appId {
    return super.appId ?? '';
  }

  @override
  bool get showChucker {
    return super.showChucker ?? false;
  }

  @override
  bool get showPrettyLog {
    return super.showPrettyLog ?? false;
  }
}