import 'package:flutter/material.dart';
import '../ui/login_prompt_page.dart';

class LoginPromptPageExample extends StatelessWidget {
  const LoginPromptPageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginPromptPage(onLogin: () => print('login'), onContinueAsGuest: () => print('continue as guest'));
  }
}
