import 'dart:async';

import 'package:flutter/material.dart';
import 'text.dart';
import 'websocket_provider.dart';

class LobbyWaitPage extends StatefulWidget {
  const LobbyWaitPage({super.key});

  @override
  State<LobbyWaitPage> createState() => LobbyWaitState();
}

class LobbyWaitState extends State<LobbyWaitPage> {
  StreamSubscription? sub;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final ws = WebsocketState.of(super.context).websocket;

    sub?.cancel();
    sub = ws?.listen((event) {
      print('jkkk got a message $event');
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
                ScreenTitle(text: 'Please wait for the host to let you in.'),
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
