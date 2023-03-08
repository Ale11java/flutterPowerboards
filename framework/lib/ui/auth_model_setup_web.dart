import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const String domain = 'https://www.timu.life';
const String url = '$domain/js/bundle/message-frame.html';
const String viewType = 'timu-iframe:$url';

class IframeResponseMsg {
  factory IframeResponseMsg.fromJSON(Map<String, String> json) {
    return IframeResponseMsg._(json);
  }

  const IframeResponseMsg._(this.rawData);

  final Map<String, dynamic> rawData;

  String get type {
    return rawData['type'];
  }

  String get message {
    return rawData['message'];
  }
}

class AuthModelSetup extends StatefulWidget {
  const AuthModelSetup({super.key, required this.child});

  final Widget child;

  @override
  State<StatefulWidget> createState() => _SetupModel();
}

class _SetupModel extends State<AuthModelSetup> {
  IFrameElement? frame;
  StreamSubscription? subscription;

  final uuid = const Uuid();
  final messageReq = <String, Completer<IframeResponseMsg>>{};

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
      element.onLoad.every((evt) {
        //Timer(const Duration(seconds: 1), () =>
        //        element.contentWindow!.postMessage('{"type":"sync"}', domain));
        final msg = <String, String>{
          'type': 'sync',
          'requestId': uuid.v4(),
        };

        element.contentWindow!.postMessage(json.encode(msg), domain);

        return false;
      });

      return element;
    });

    subscription = window.onMessage.listen((event) {
      //final data = json.decode(event.data);
      window.console.log('jkkk event');
      window.console.log(event);
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
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

                // frame?.contentWindow?.console.log('jkk');
                // frame?.contentWindow?.console.log('frame');
              })),
      widget.child,
    ]);
  }
}
