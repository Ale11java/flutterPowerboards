import 'package:flutter/material.dart';

class AppLifecycleDetector extends StatefulWidget {
  const AppLifecycleDetector({super.key});

  @override
  AppLifecycleDetectorState createState() => AppLifecycleDetectorState();
}

class AppLifecycleDetectorState extends State<AppLifecycleDetector>
    with WidgetsBindingObserver {
  AppLifecycleState? _appLifecycleState;

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
      _appLifecycleState = state;
      if (state == AppLifecycleState.resumed) {
        // The app has come back to the foreground
        print('App resumed from background');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(_appLifecycleState?.toString() ?? '');
  }
}
