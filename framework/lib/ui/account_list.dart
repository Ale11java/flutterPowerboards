import 'package:flutter/material.dart';

import '../model/account.dart';
import 'account_item.dart';
import 'auth_model.dart';

class AccountList extends StatelessWidget {
  const AccountList({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthModel props = AuthModel.of(context);
    final List<Account> accounts = props.accounts;

    return ListView.builder(
      itemCount: accounts.length,
      itemBuilder: (BuildContext context, int index) {
        final Account account = accounts[index];
        return AccountItem(
          account: account,
          // onTap: () {
          //   storage?.setActiveAccount(account);
          // },
          // leading: activeAccount == account ? const Icon(Icons.check) : null,
        );
      },
    );
  }
}
