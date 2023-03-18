import 'package:flutter/material.dart';
import '../model/account.dart';
import 'account_list.dart';
import 'accounts_empty.dart';
import 'auth_model.dart';
import 'auth_storage_cache.dart';

class StorageLoginPage extends StatelessWidget {
  const StorageLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthModel props = AuthModel.of(context);
    final List<Account> accounts = props.accounts;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(47, 45, 87, 1),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
          child: Center(
              child: accounts.isNotEmpty
                  ? AccountList(
                      onAccountPressed: (Account account) {
                        context
                            .findAncestorStateOfType<AuthStorageCacheState>()
                            ?.setActiveAccount(account);
                      },
                    )
                  : const AccountsEmpty())),
    );
  }
}
