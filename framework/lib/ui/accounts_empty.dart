import 'package:flutter/material.dart';

import '../../ui.dart';
import 'primary_button.dart';

class AccountsEmpty extends StatelessWidget {
  const AccountsEmpty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: const <Widget>[
      SizedBox(height: 100),
      ScreenTitle(text: 'Sign into the TIMU app'),
      SizedBox(height: 5),
      ScreenText(text: 'To continue use the TIMU app to add an account'),
      SizedBox(height: 40),
      PrimaryButton(text: 'Open TIMU app')
    ]);
  }
}
