
base class Result<T,M> {}

final class Success<T,M> extends Result {
  Success({required T data, String? message, String? status,M? meta});
}

final class Failure<T,M> extends Result  {
  Failure(String? message, {String? status});
}

