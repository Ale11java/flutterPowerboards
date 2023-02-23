import 'package:flutter/material.dart';

import '../model/account.dart';
import 'auth_model.dart';
import 'storage_login_page.dart';

class StorageLogin extends StatelessWidget {
  const StorageLogin({
    super.key,
    required this.childLoggedIn,
  });

  final Widget childLoggedIn;

  @override
  Widget build(BuildContext context) {
    final AuthModel props = AuthModel.of(context);
    final Account? activeAccount = props.activeAccount;

    if (activeAccount != null) {
      return childLoggedIn;
    } else {
      return const MaterialApp(
        key: Key('login'),
        home: StorageLoginPage(),
      );
    }
  }
}
