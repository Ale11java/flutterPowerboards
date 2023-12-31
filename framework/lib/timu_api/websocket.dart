import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// wss://
//  usa.timu.life
//  /api/realtime/watch?
//  url=/api/graph/core:user/f0a6e008-2e6e-494c-b1bc-fed9df61ef30&
//  channel=default&
//  metadata={}&
//  token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9&
//  options=1197';

String _formatUrl(String apiRoot, String url, String accessToken, int? network,
    String channel, String metadata) {
  final params = <String, String>{
    'url': url,
    'channel': channel,
    'metadata': metadata,
  };

  if (network != null) {
    params['network'] = network.toString();
  }

  if (accessToken != '') {
    params['token'] = accessToken;
  }

  return Uri(
    scheme: 'wss',
    host: apiRoot,
    path: '/api/realtime/watch',
    queryParameters: params,
  ).toString();
}

class Client {
  Client({
    required this.id,
    required this.metadata,
    required this.profile,
  });

  final String id;
  final Map<String, dynamic> profile;
  final Map<String, dynamic> metadata;

  Timer? typing;

  void sendTyping() {
    typing?.cancel();
    typing = Timer(const Duration(seconds: 3), () => typing = null);
  }
}

final Client emptyClient = Client(id: '_empty_', metadata: {}, profile: {});

class UniqueClient extends Client {
  UniqueClient({
    required super.id,
    required super.profile,
    required super.metadata,
    required this.connections,
  });

  final List<Client> connections;
}

class PongStream extends Stream<int> implements StreamSink<int> {
  final StreamController<int> _controller = StreamController<int>.broadcast();

  @override
  StreamSubscription<int> listen(void Function(int event)? onData,
          {Function? onError, void Function()? onDone, bool? cancelOnError}) =>
      _controller.stream.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );

  @override
  void add(int event) => _controller.sink.add(event);

  @override
  Future<dynamic> close() => _controller.sink.close();

  @override
  Future<dynamic> addStream(Stream<int> source) =>
      _controller.addStream(source);

  @override
  void addError(Object error, [StackTrace? stackTrace]) =>
      _controller.addError(error, stackTrace);

  @override
  Future<dynamic> get done => _controller.done;
}

class TimuWebsocketEvent {
  TimuWebsocketEvent({required this.sender, required this.data});

  final String sender;
  final Map<String, dynamic> data;
}

class TimuWebsocket extends Stream<TimuWebsocketEvent> {
  TimuWebsocket({
    required this.apiRoot,
    required this.url,
    required this.accessToken,
    this.network,
    this.channel = 'default',
    Map<String, dynamic>? metadata,
  })  : metadata = metadata ?? <String, dynamic>{},
        clients = <Client>[],
        uniqueClients = <Client>[],
        _pongStream = PongStream(),
        _messages = StreamController<TimuWebsocketEvent>.broadcast(),
        _clientsController = StreamController<List<Client>>.broadcast();

  final String apiRoot;
  final String url;
  final String accessToken;
  final int? network;

  final String channel;
  final Map<String, dynamic> metadata;

  final PongStream _pongStream;

  List<Client> clients;
  List<Client> uniqueClients;

  WebSocketChannel? _websocket;
  final StreamController<TimuWebsocketEvent> _messages;
  final StreamController<List<Client>> _clientsController;

  bool synced = false;
  int pongCount = 0;

  StreamSubscription? _pingPongSub;

  @override
  StreamSubscription<TimuWebsocketEvent> listen(
          void Function(TimuWebsocketEvent event)? onData,
          {Function? onError,
          void Function()? onDone,
          bool? cancelOnError}) =>
      _messages.stream.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );

  StreamSubscription listenClients(void Function(List<Client>) onClientsChange,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return _clientsController.stream.startWith(clients).listen(
          onClientsChange,
          onError: onError,
          onDone: onDone,
          cancelOnError: cancelOnError,
        );
  }

  void connect() {
    _websocket?.sink.close();

    _websocket = WebSocketChannel.connect(Uri.parse(_formatUrl(
        apiRoot, url, accessToken, network, channel, jsonEncode(metadata))));

    _websocket?.stream.listen((dynamic res) {
      final msg = jsonDecode(res.toString()) as Map<String, dynamic>;

      if (msg.containsKey('ListClients') && msg['ListClients'] != null) {
        final Map<String, dynamic> data =
            msg['ListClients'] as Map<String, dynamic>;

        clients.clear();
        for (final dynamic client in data['Clients'] as List<dynamic>) {
          final Map<String, dynamic> item = client as Map<String, dynamic>;

          clients.add(Client(
            id: item['id'].toString(),
            metadata: item['metadata'] as Map<String, dynamic>,
            profile: item['profile'] as Map<String, dynamic>,
          ));
        }
        _clientsController.sink.add(clients);
      } else if (msg.containsKey('Pong') && msg['Pong'] != null) {
        _pongStream.add(pongCount++);
      } else if (msg.containsKey('Published') && msg['Published'] != null) {
        final Map<String, dynamic> published =
            msg['Published'] as Map<String, dynamic>;

        final String dt = published['Data'] as String;
        final Map<String, dynamic> data =
            json.decode(dt) as Map<String, dynamic>;

        if (data.containsKey('Added')) {
          clients.add(Client(
            id: published['Sender'].toString(),
            metadata: data['Metadata'] as Map<String, dynamic>,
            profile: data['Added'] as Map<String, dynamic>,
          ));
          _clientsController.sink.add(clients);
        } else if (data.containsKey('Removed')) {
          final String id = published['Sender'].toString();
          clients.removeWhere((Client c) => c.id == id);
          _clientsController.sink.add(clients);
        } else if (data.containsKey('Typing')) {
          final String id = published['Sender'].toString();
          final Client client = clients.firstWhere((Client c) => c.id == id,
              orElse: () => emptyClient);
          client.sendTyping();
        } else {
          _messages.sink.add(TimuWebsocketEvent(
            sender: published['Sender'].toString(),
            data: data,
          ));
        }
      }
    });

    _websocket?.sink.add('{"ListClients":{}}');

    _startPingPong();
  }

  void _startPingPong() {
    _pingPongSub?.cancel();

    _pingPongSub = Stream.periodic(const Duration(seconds: 15), (int i) => i)
        .switchMap((int i) {
      _ping();

      return Stream<bool>.fromFuture(Future.any<bool>(<Future<bool>>[
        _pongStream.first.then((int i) => false),
        Future<dynamic>.delayed(const Duration(seconds: 5))
            .then((dynamic v) => true),
      ]));
    }).listen((reconnect) async {
      if (reconnect) {
        connect();
      }
    });
  }

  void publish(Map<String, dynamic> data, Map<String, dynamic> acl) {
    _websocket?.sink.add(json.encode({
      'Publish': {
        'Url': '/v2/$url/+channel/$channel',
        'Data': json.encode(data),
        'Acl': acl,
      }
    }));
  }

  void _ping() {
    _websocket?.sink.add('{"Ping":{}}');
  }

  void close() {
    _websocket?.sink.close();
    _websocket = null;

    _pingPongSub?.cancel();
  }
}
