import 'package:flutter/material.dart';
import '../ui/account_prompt_page.dart';

class AccountPromptPageExample extends StatelessWidget {
  const AccountPromptPageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return AccountPromptPage(
        onLogin: () => print('login'),
        onSelectAccount: () => print('on select account'));
  }
}
