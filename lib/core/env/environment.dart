base class Environment {
  String? baseUrl;
  String? apiVersion;
  String? mapToken;
  String? appId;
  bool? showRuntimeLog;
  String? url;
  bool? showChucker;
  bool? showPrettyLog;

  Environment(
      {required this.baseUrl,
      required this.apiVersion,
      required this.mapToken,
      required this.appId,
        required this.showRuntimeLog,
        required this.showChucker,
        required this.showPrettyLog,
      });
}

final class DevEnvironment extends Environment {

  @override
  String get url {
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

  DevEnvironment(
      {required super.baseUrl,
      required super.apiVersion,
      required super.mapToken,
      required super.appId,
        required super.showRuntimeLog,
        required super.showChucker,
        required super.showPrettyLog,
      });
}

final class StageEnvironment extends Environment {
  StageEnvironment(
      {required super.baseUrl,
      required super.apiVersion,
      required super.mapToken,
        required super.appId,
        required super.showRuntimeLog,
        required super.showChucker,
        required super.showPrettyLog,
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
  ProdEnvironment(
      {required super.baseUrl,
      required super.apiVersion,
      required super.mapToken,
      required super.appId,
        required super.showRuntimeLog,
        required super.showChucker,
        required super.showPrettyLog,
      });

  @override
  String get url {
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