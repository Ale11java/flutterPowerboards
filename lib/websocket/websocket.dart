import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

// wss://
//  usa.timu.life
//  /api/realtime/watch?
//  url=/api/graph/core:user/f0a6e008-2e6e-494c-b1bc-fed9df61ef30&
//  channel=default&
//  metadata={}&
//  token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9&
//  options=1197';

String _formatUrl(String apiRoot, String url, String accessToken,
        String network, String channel, String metadata) =>
    'wss://$apiRoot/api/realtime/watch?url=$url&channel=$channel&metadata=$metadata&token=$accessToken&options=$network';

class Client {
  Client(
    this.id,
    this.profile,
    this.metadata,
  );

  final String id;
  final Map<String, dynamic> profile;
  final Map<String, dynamic> metadata;

  Timer? typing;

  void sendTyping() {
    typing?.cancel();
    typing = Timer(const Duration(seconds: 3), () => typing = null);
  }
}

class UniqueClient extends Client {
  UniqueClient(
    super.id,
    super.profile,
    super.metadata,
    this.connections,
  );

  final List<Client> connections;
}

enum State {
  open,
  disconnected,
}

class Websocket {
  Websocket(
    this.apiRoot,
    this.url,
    this.accessToken,
    this.network, {
    this.channel = 'default',
    Map<String, dynamic>? metadata,
  })  : metadata = metadata ?? <String, dynamic>{},
        clients = <Client>[],
        uniqueClients = <Client>[];

  final String apiRoot;
  final String url;
  final String accessToken;
  final String network;
  final String channel;
  final Map<String, dynamic> metadata;

  List<Client> clients;
  List<Client> uniqueClients;

  WebSocketChannel? websocket;
  bool closed = false;
  State state = State.disconnected;
  bool synced = false;

  void connect() {
    websocket?.sink.close();

    websocket = WebSocketChannel.connect(Uri.parse(_formatUrl(
        apiRoot, url, accessToken, network, channel, jsonEncode(metadata))));
  }

  void _reconnect() {}

  void _startPingPong() {}

  void _ping() {}

  void sendTyping() {}

  void close() {
    closed = true;

    websocket?.sink.close();
    websocket = null;

    state = State.disconnected;
  }

  void publish() {}

  void _syncClients() {}
}
