/// State classes for register feature
sealed class RegisterState {
  const RegisterState();
}

final class RegisterInit extends RegisterState {
  const RegisterInit();
}

final class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

final class RegisterSuccess extends RegisterState {
  const RegisterSuccess();
}

final class RegisterFailed extends RegisterState {
  final String message;
  const RegisterFailed(this.message);
}

