import 'package:flutter/material.dart';

import '../model/account.dart';
import 'auth_model.dart';
import 'storage_login_page.dart';

/*
   name: temporary access to
   url self
   role: core contributor
*/

class StorageLogin extends StatelessWidget {
  const StorageLogin({
    super.key,
    required this.childLoggedIn,
  });

  final Widget childLoggedIn;

  @override
  Widget build(BuildContext context) {
    final Account? activeAccount = AuthModel.of(context).activeAccount;

    print('jkkk active account $activeAccount');

    if (activeAccount != null) {
      return childLoggedIn;
    } else {
      return const StorageLoginPage();
    }
  }
}
