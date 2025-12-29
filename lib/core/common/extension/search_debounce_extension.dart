import 'dart:async';

extension StreamDebounce on Stream<String> {
  Stream<String> debounce(Duration duration) {
    Timer? timer;
    return StreamTransformer<String, String>.fromHandlers(handleData: (text, sink) async {
      if (timer != null && timer!.isActive) {
        timer!.cancel();
      }
      timer = Timer(duration, () {
        sink.add(text);
      });
    }).bind(this);
  }
}
