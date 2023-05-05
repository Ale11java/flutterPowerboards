import 'package:flutter/material.dart';
import '../livekit/lobby.dart';
import '../livekit/room.dart';

class LobbyExample extends StatelessWidget {
  const LobbyExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0XFF2F2D57),
      child: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 640,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                VideoRoomProvider(child: Lobby(join: () {})),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
