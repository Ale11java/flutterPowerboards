import 'package:flutter/material.dart';
import '../timu_api/timu_api.dart';
import '../timu_api/websocket.dart';
import 'text.dart';

class LobbyWaitPage extends StatefulWidget {
  const LobbyWaitPage({
    super.key,
    required this.nounURL,
    required this.accessToken,
  });

  final String nounURL;
  final String accessToken;

  @override
  State<LobbyWaitPage> createState() => LobbyWaitState();
}

class LobbyWaitState extends State<LobbyWaitPage> {
  TimuWebsocket? websocket;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final api = TimuApiProvider.of(super.context);

    final ws = TimuWebsocket(
      network: api.defaultNetwork,
      apiRoot: api.host,
      url: widget.nounURL,
      accessToken: widget.accessToken,
    );

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
