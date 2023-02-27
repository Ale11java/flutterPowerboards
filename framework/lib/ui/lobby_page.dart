import 'package:flutter/material.dart';
import 'accounts_empty.dart';

class LobbyPage extends StatelessWidget {
  const LobbyPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromRGBO(47, 45, 87, 1),
      body: Padding(
        padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
        child: Center(
          child: AccountsEmpty(),
        ),
      ),
    );
  }
}
