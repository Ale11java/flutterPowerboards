import 'package:flutter/material.dart';
import 'join_page.dart';

class LobbyPage extends StatelessWidget {
  const LobbyPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0XFF2F2D57),
      child: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                JoinPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
