
base class SplashState {
  const SplashState();
}

final class SplashInit extends SplashState{
  const SplashInit();
}
final class SplashLoading extends SplashState{

  const SplashLoading();
}
final class SplashSuccess extends SplashState{

  const SplashSuccess();
}
final class SplashFailed extends SplashState{

  const SplashFailed();
}