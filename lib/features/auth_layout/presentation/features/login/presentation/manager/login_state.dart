/// State classes for login feature
sealed class LoginState {
  const LoginState();
}

final class LoginInit extends LoginState {
  const LoginInit();
}

final class LoginLoading extends LoginState {
  const LoginLoading();
}

final class LoginSuccess extends LoginState {
  const LoginSuccess();
}

final class LoginFailed extends LoginState {
  final String message;
  const LoginFailed(this.message);
}

