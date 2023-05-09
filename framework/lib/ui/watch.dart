import 'dart:async';
import 'package:flutter/material.dart';

const int DEFAULT_POLL_SECONDS = 3;

class Watch extends StatefulWidget {
  const Watch(
      {super.key,
      required this.check,
      required this.passed,
      this.pollSeconds = DEFAULT_POLL_SECONDS});

  final Future<bool> Function() check;
  final void Function() passed;
  final int pollSeconds;

  @override
  WatchState createState() => WatchState();
}

class WatchState extends State<Watch> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _timer =
        Timer.periodic(Duration(seconds: widget.pollSeconds), (timer) async {
      final pass = await widget.check();
      if (pass) {
        timer.cancel();
        widget.passed();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
