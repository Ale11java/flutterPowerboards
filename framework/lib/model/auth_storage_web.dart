import 'dart:async';

import 'account.dart';
import 'auth_storage.dart';

class AuthStorageImpl extends AuthStorage {
  AuthStorageImpl() : super.newInstance();

  @override
  Future<List<Account>> getAccounts() async {
    return [];
  }

  @override
  Future<Account?> getActiveAccount() async {
    return null;
  }

  @override
  Future<void> setActiveAccount(Account? account) async {}
}
