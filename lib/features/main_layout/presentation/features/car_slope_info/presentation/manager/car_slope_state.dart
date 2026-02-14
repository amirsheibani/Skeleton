import 'package:framework_base/packages/framework_handler/lib/handler_framework.dart';

base class CarSlopeState {
  const CarSlopeState();
}

final class CarSlopeInit extends CarSlopeState {
  const CarSlopeInit();
}

final class CarSlopeLoading extends CarSlopeState {
  const CarSlopeLoading();
}

final class CarSlopeSuccess extends CarSlopeState {
  final CarSlopeData? slopeData;
  final bool isListening;
  const CarSlopeSuccess({
    this.slopeData,
    this.isListening = false,
  });
}

final class CarSlopeFailed extends CarSlopeState {
  final String message;
  const CarSlopeFailed(this.message);
}