import 'dart:async';
import 'package:rxdart/rxdart.dart';

/// Creates a [Stream] that will produce counter repeats indefinitely.
///
/// ### Example
///     IntervalStream(Duration(miliseconds: 250))
///         .take(20)
///         .listen((i) => print(i)); // Prints '0, 1, 2, ...19'
class IntervalStream extends Stream<int> {
  IntervalStream(this.duration);

  final Duration duration;

  int _count = 0;

  StreamController<int>? _controller;
  StreamSubscription<int>? _subscription;

  @override
  StreamSubscription<int> listen(void Function(int event)? onData, {
      Function? onError,
      void Function()? onDone,
      bool? cancelOnError}) {

    _controller ??= StreamController<int>(
      sync: true,
      onListen: _repeatNext,
      onPause: () => _subscription?.pause(),
      onResume: () => _subscription?.resume(),
      onCancel: () => _subscription?.cancel());

    return _controller!.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  void _repeatNext() {
    void onDone() {
      _subscription?.cancel();

      _repeatNext();
    }

    final StreamController<int> controller = _controller!;

    try {
      _subscription = TimerStream<int>(_count++, duration).listen(
        controller.add,
        onError: controller.addError,
        onDone: onDone,
        cancelOnError: false,
      );
    } catch (e, s) {
      controller.addError(e, s);
    }
  }
}
