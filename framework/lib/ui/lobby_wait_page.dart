import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../model/account.dart';
import 'auth_storage_cache.dart';
import 'object_access_token.dart';
import 'websocket_provider.dart';

class LobbyWaitPage extends StatefulWidget {
  const LobbyWaitPage(
      {super.key,
      required this.child,
      required this.onApproved,
      required this.onDenied});

  final Widget child;
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

    final ws = WebsocketState.of(context).websocket;
    final oat = ObjectAccessTokenProviderState.of(context);

    sub?.cancel();
    sub = ws?.listen((event) {
      if (event.data.containsKey('token')) {
        final token = event.data['token'];

        widget.onApproved();

        oat.setToken(ws.url, token);
      } else if (event.data.containsKey('denied')) {
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
    return widget.child;
  }
}
