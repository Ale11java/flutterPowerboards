import 'package:flutter/material.dart';
import '../model/account.dart';
import 'account_list.dart';
import 'accounts_empty.dart';
import 'auth_model.dart';

class StorageLogin extends StatelessWidget {
  const StorageLogin({
    super.key,
    required this.childActive,
  });

  final Widget childActive;

  @override
  Widget build(BuildContext context) {
    final AuthModel props = AuthModel.of(context);
    final List<Account> accounts = props.accounts;
    final Account? activeAccount = props.activeAccount;

    if (activeAccount != null) {
      // return const AccountList();
      // return const AccountsEmpty();
      return childActive;
    } else {
      if (accounts.isNotEmpty) {
        return const AccountList();
      } else {
        return const AccountsEmpty();
        // return Wrap(children: const <Widget>[
        //   PrimaryButton(
        //     text: 'Add account',
        //   ),
        // ]);
      }
    }
  }
}
