import 'dart:async';

import 'package:flutter/material.dart';

import '../timu_api/websocket.dart';
import 'websocket_provider.dart';

class WebsocketClients extends StatefulWidget {
  const WebsocketClients({super.key, required this.builder});

  final Widget Function(BuildContext, List<Client> clients) builder;

  @override
  State<StatefulWidget> createState() => _WebsocketClientsState();
}

class _WebsocketClientsState extends State<WebsocketClients> {
  StreamSubscription? sub;
  List<Client> clients = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final ws = WebsocketState.of(context).websocket;

    sub?.cancel();
    sub = ws?.listenClients((all) {
      setState(() {
        clients = all;
      });
    });
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, clients);
  }
}
