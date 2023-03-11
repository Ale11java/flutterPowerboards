import 'dart:async';

import 'account.dart';
import 'auth_storage_not_implemented.dart'
    if (dart.library.io) 'auth_storage_native.dart';

abstract class AuthStorage {
  factory AuthStorage() {
    return AuthStorageImpl();
  }
  AuthStorage.newInstance();

  Future<List<Account>> getAccounts();

  Future<Account?> getActiveAccount();

  Future<void> setActiveAccount(Account? account);
}
