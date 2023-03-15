import 'dart:async';

import 'package:flutter/material.dart';
import 'text.dart';
import 'websocket_provider.dart';

class InAppPage extends StatefulWidget {
  const InAppPage({super.key});

  @override
  State<InAppPage> createState() => InAppState();
}

class InAppState extends State<InAppPage> {
  StreamSubscription? sub;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final ws = WebsocketState.of(super.context).websocket;

    sub?.cancel();
    sub = ws?.listenClients((event) {
      print('we get accept event message $event'); // ignore: avoid_print
    });
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0XFF2F2D57),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ScreenTitle(text: 'In App.'),
                SizedBox(height: 16),
                ScreenSubtitle(text: 'Daily design meetup'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
