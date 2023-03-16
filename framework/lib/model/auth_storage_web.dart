import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:ui' as ui;

// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'account.dart';
import 'auth_storage.dart';

const String domain = 'https://www.timu.life';
const String url = '$domain/js/bundle/message-frame.html';
const String viewType = 'timu-iframe:$url';

class Token {
  factory Token.fromJSON(Map<String, dynamic> json) {
    return Token._(json);
  }
  const Token._(this.rawData);

  final Map<String, dynamic> rawData;

  String get login {
    return rawData['login'];
  }

  String get method {
    // ignore: avoid_dynamic_calls
    final method = (rawData['method'] ?? '').split(':');

    // ignore: avoid_dynamic_calls
    return method[0];
  }

  String get provider {
    // ignore: avoid_dynamic_calls
    final method = (rawData['method'] ?? '').split(':');

    // ignore: avoid_dynamic_calls
    return method.length > 1 ? method[1] : '';
  }
}

class IframeResponseMsg {
  factory IframeResponseMsg.fromJSON(Map<String, dynamic> json) {
    return IframeResponseMsg._(json);
  }

  const IframeResponseMsg._(this.rawData);

  final Map<String, dynamic> rawData;

  String get requestId {
    return rawData['requestId'];
  }

  Iterable<Token> get tokens {
    if (rawData.containsKey('tokens')) {
      final List<dynamic> tkns = rawData['tokens'];

      return tkns.map<Token>((dynamic t) => Token.fromJSON(t));
    }

    return [];
  }

  List<Account> toAccountList() {
    return tokens.map((Token token) {
      return Account(
        key: token.login,
        email: token.login,
        firstName: '',
        lastName: '',
        accessToken: '',
        method: token.method,
        provider: token.provider,
      );
    }).toList();
  }

  Account? toActiveAccount() {
    final String currentLogin = rawData['currentLogin'] ?? '';
    final String accessToken = rawData['accessToken'] ?? '';

    final Account? act = toAccountList().firstWhereOrNull((act) {
      return act.email == currentLogin;
    });

    if (act == null) {
      return null;
    }

    return Account(
        key: act.key,
        email: act.email,
        firstName: rawData['firstName'],
        lastName: rawData['lastName'],
        accessToken: accessToken,
        method: act.method,
        provider: act.provider);
  }
}

class AuthStorageImpl extends AuthStorage {
  AuthStorageImpl()
      : ready = Completer(),
        super.newInstance();

  @override
  Future<Account?> getActiveAccount() async {
    await ready.future;

    // TODO: what if active account is a guest?
    final IframeResponseMsg msg = await _sendMsg({'type': 'getAccessToken'});
    return msg.toActiveAccount();
  }

  @override
  Future<List<Account>> getAccounts() async {
    // TODO: merge in guest accounts from secure storage

    await ready.future;

    final IframeResponseMsg msg = await _sendMsg({'type': 'getAccessToken'});
    return msg.toAccountList();
  }

  @override
  Future<void> setActiveAccount(Account? account) async {
    await ready.future;

    // TODO: what if active account is a guest?

    if (frame != null && account != null) {
      _sendMsg({
        'type': 'setCurrentUser',
        'login': account.email,
      });
    } else {
      // TODO: wait for ready and then send
      throw Exception("Not ready");
    }
  }

  @override
  Future<void> addAccount(Account account) async {
    await ready.future;

    if (account.provider != ProviderTimuGuest) {
      throw Exception("Can only add guest providers");
    }
    // TODO: Send to secureStorage
  }

  IFrameElement? frame;
  StreamSubscription? subscription;
  Completer<void> ready;

  final uuid = const Uuid();
  final messageReq = <String, Completer<IframeResponseMsg>>{};

  Future<IframeResponseMsg> _sendMsg(Map<String, dynamic> msg) {
    final res = Completer<IframeResponseMsg>();
    final id = uuid.v4();

    msg['requestId'] = id;
    messageReq[id] = res;

    frame?.contentWindow!.postMessage(json.encode(msg), domain);

    return res.future;
  }

  @override
  void initState() {
    super.initState();

    final IFrameElement element = IFrameElement()
      ..id = 'message-frame'
      ..width = '0'
      ..height = '0'
      // ignore: unsafe_html
      ..src = url
      ..style.border = 'none';

    // ignore: UNDEFINED_PREFIXED_NAME, avoid_dynamic_calls
    ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      element.onLoad.first.then((evt) {
        print('jkkk evt $evt; $viewId; $viewType');

        if (!ready.isCompleted) {
          ready.complete();
        }
      });

      return element;
    });

    subscription = window.onMessage.listen((event) {
      final res = IframeResponseMsg.fromJSON(json.decode(event.data));

      if (messageReq.containsKey(res.requestId)) {
        messageReq[res.requestId]?.complete(res);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      SizedBox.shrink(
          child: HtmlElementView(
              viewType: viewType,
              onPlatformViewCreated: (id) {
                // ignore: cast_nullable_to_non_nullable
                frame = window.document.getElementById('message-frame')
                    as IFrameElement;
              })),
      widget.child
    ]);
  }
}
