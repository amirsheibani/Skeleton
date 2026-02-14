


import 'pagination.dart';

abstract class BaseUseCaseWithPagination<R, P> {
  Future<R> call(P arg, Pagination pagination);
}

abstract class BaseUseCaseNoArgsWithPagination<R> {
  Future<R> call(Pagination pagination);
}

abstract class BaseUseCase<R, P> {
  Future<R> call(P arg);
}

abstract class BaseUseCaseNoArgs<R> {
  Future<R> call();
}

abstract class BaseStreamUseCase<R, P> {
  Stream<R> call(P arg);
}

abstract class BaseStreamUseCaseNoArgs<R> {
  Stream<R> call();
}
