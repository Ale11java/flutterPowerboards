import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../model/account.dart';
import 'auth_model.dart';
import 'auth_storage_state.dart';

const String domain = 'https://www.timu.life';
const String url = '$domain/js/bundle/message-frame.html';
const String viewType = 'timu-iframe:$url';

class IframeResponseMsg {
  factory IframeResponseMsg.fromJSON(Map<String, String> json) {
    return IframeResponseMsg._(json);
  }

  const IframeResponseMsg._(this.rawData);

  final Map<String, dynamic> rawData;

  String get requestId {
    return rawData['requestId'];
  }

  List<Account> toAccountList() {
    if (rawData.containsKey('tokens')) {
      final tokens = rawData['tokens'] as List<dynamic>;

      return tokens.map((dynamic val) {
        final method = val['method'].split(':');

        return Account(
          key: val['login'] as String,
          email: val['login'] as String,
          firstName: '',
          lastName: '',
          accessToken: '',
          method: method[0] ?? '',
          provider: method.length > 1 ? method[1] : '',
        );
      }).toList(growable: false);
    }

    return [];
  }

  Account? toActiveAccount() {
    final String currentLogin = rawData['currentLogin'];
    final String accessToken = rawData['accessToken'];

    final act = toAccountList().firstWhere((act) {
      return act.email == currentLogin;
    });

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

class AuthStorageStateImpl extends AuthStorageState {
  AuthStorageStateImpl() : super.newInstance();

  IFrameElement? frame;
  StreamSubscription? subscription;

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
        updateState();
      });

      return element;
    });

    subscription = window.onMessage.listen((event) {
      final res = json.decode(event.data) as IframeResponseMsg;

      if (messageReq.containsKey(res.requestId)) {
        messageReq[res.requestId]?.complete(res);
      }
    });
  }

  @override
  Future<void> updateState() async {
    if (frame != null) {
      final IframeResponseMsg msg = await _sendMsg({'type': 'getAccessToken'});

      setState(() {
        accounts = msg.toAccountList();
        activeAccount = msg.toActiveAccount();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    subscription?.cancel();
  }

  @override
  void setActiveAccount(Account? account) {
    activeAccount = account;

    if (frame != null && account != null) {
      _sendMsg({
        'type': 'setCurrentUser',
        'login': account.email,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_shrink_expand
    return Stack(children: <Widget>[
      SizedBox.shrink(
          child: HtmlElementView(
              viewType: viewType,
              onPlatformViewCreated: (id) {
                // ignore: cast_nullable_to_non_nullable
                frame = window.document.getElementById('message-frame')
                    as IFrameElement;
              })),
      AuthModel(
          accounts: accounts,
          activeAccount: activeAccount,
          child: widget.child),
    ]);
  }
}
