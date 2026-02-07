sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T? data;
  final String? message;
  final dynamic meta;
  const Success({required this.data, this.message, this.meta,});
}

class Failure<T> extends Result<T> {
  final String message;
  final dynamic meta;
  const Failure({required this.message, this.meta});
}