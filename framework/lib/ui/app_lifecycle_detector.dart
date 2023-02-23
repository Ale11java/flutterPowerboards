import 'package:flutter/material.dart';

class AppLifecycleDetector extends StatefulWidget {
  const AppLifecycleDetector({
    super.key,
    required this.onResumed,
    required this.child,
  });

  final void Function()? onResumed;
  final Widget child;

  @override
  AppLifecycleDetectorState createState() => AppLifecycleDetectorState();
}

class AppLifecycleDetectorState extends State<AppLifecycleDetector>
    with WidgetsBindingObserver {
  // AppLifecycleState? _appLifecycleState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      // _appLifecycleState = state;
      if (state == AppLifecycleState.resumed) {
        // The app has come back to the foreground
        //print('App resumed from background');
        if (widget.onResumed != null) {
          widget.onResumed!();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
