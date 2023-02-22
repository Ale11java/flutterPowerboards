import 'package:flutter/material.dart';

import '../model/account.dart';
import 'auth_model.dart';
import 'login_page.dart';

class StorageLogin extends StatelessWidget {
  const StorageLogin({
    super.key,
    required this.childLoggedIn,
  });

  final Widget childLoggedIn;

  @override
  Widget build(BuildContext context) {
    final AuthModel props = AuthModel.of(context);
    // final List<Account> accounts = props.accounts;
    final Account? activeAccount = props.activeAccount;

    if (activeAccount != null) {
      return childLoggedIn;
    } else {
      return MaterialApp(
        key: const Key('login'),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: accounts.isNotEmpty ? const AccountList() : const AccountsEmpty(),
        home: const LoginPage(),
      );
    }
  }
}
