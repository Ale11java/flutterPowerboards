import 'dart:async';

import 'package:flutter/material.dart';
import '../model/account.dart';
import 'auth_storage_cache.dart';
import 'text.dart';
import 'websocket_provider.dart';

class LobbyWaitPage extends StatefulWidget {
  const LobbyWaitPage(
      {super.key, required this.onApproved, required this.onDenied});

  final Function() onApproved;
  final Function() onDenied;

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
      if (event.data.containsKey('token')) {
        final storage =
            context.findAncestorStateOfType<AuthStorageCacheState>();
        final token = event.data['token'];

        storage?.addAccount(Account(
            key: 'approved-guest',
            email: 'guest',
            firstName: storage.activeAccount?.firstName ?? 'Guest',
            lastName: storage.activeAccount?.lastName ?? 'User',
            accessToken: token,
            method: 'register',
            provider: 'guest'));

        widget.onApproved();
      } else if (event.data.containsKey('deny')) {
        widget.onDenied();
      }
    });
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
        color: Color(0XFF2F2D57),
        child: Center(
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
        ));
  }
}
