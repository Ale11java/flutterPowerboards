import 'dart:io';

import 'package:flutter/material.dart';
import '../timu_api/timu_api.dart';
import '../timu_api/websocket.dart';

class WebsocketProvider extends StatefulWidget {
  const WebsocketProvider({
    super.key,
    required this.child,
    required this.nounUrl,
    required this.channel,
    this.metadata,
  });

  final Widget child;
  final String nounUrl;
  final String channel;
  final Map<String, dynamic>? metadata;

  @override
  State<WebsocketProvider> createState() => WebsocketState();
}

class WebsocketState extends State<WebsocketProvider> {
  TimuWebsocket? websocket;

  static WebsocketState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<WebsocketState>();
  }

  static WebsocketState of(BuildContext context) {
    final WebsocketState? result = maybeOf(context);

    assert(result != null, 'No WebsocketState found in context');

    return result!;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final api = TimuApiProvider.of(super.context).api;
    final ws = api.createWebsocket(widget.nounUrl, widget.channel,
        metadata: widget.metadata);

    websocket?.close();

    ws.connect();

    setState(() {
      websocket = ws;
    });
  }

  @override
  void dispose() {
    websocket?.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
