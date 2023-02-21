import 'package:flutter/material.dart';
import 'package:timu_dart/ui/login_page.dart';
import '../model/account.dart';
import 'account_list.dart';
import 'accounts_empty.dart';
import 'auth_model.dart';

class StorageLogin extends StatelessWidget {
  const StorageLogin({
    super.key,
    required this.childLoggedIn,
  });

  final Widget childLoggedIn;

  @override
  Widget build(BuildContext context) {
    final AuthModel props = AuthModel.of(context);
    final List<Account> accounts = props.accounts;
    final Account? activeAccount = props.activeAccount;

    if (activeAccount != null) {
      return childLoggedIn;
    } else {
      return MaterialApp(
        key: const Key('login'),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: accounts.isNotEmpty ? const AccountList() : const AccountsEmpty(),
      );
      // if (accounts.isNotEmpty) {
      //   return const AccountList();
      // } else {
      //   return const AccountsEmpty();
      //   // return Wrap(children: const <Widget>[
      //   //   PrimaryButton(
      //   //     text: 'Add account',
      //   //   ),
      //   // ]);
      // }
    }
  }
}
