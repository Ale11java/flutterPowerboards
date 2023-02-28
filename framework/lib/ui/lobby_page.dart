import 'package:flutter/material.dart';
import 'join_text_field.dart';
import 'text.dart';

class LobbyPage extends StatelessWidget {
  const LobbyPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF2F2D57),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              ScreenTitle(text: 'Join an invite or sign in'),
              SizedBox(height: 16),
              ScreenSubtitle(
                text: 'Enter your invite link',
              ),
              SizedBox(height: 44),
              JoinTextField(),
            ],
          ),
        ),
      ),
    );
  }
}
