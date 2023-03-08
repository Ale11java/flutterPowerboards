import 'package:flutter/material.dart';

import '../model/account.dart';
import 'auth_storage.dart';

import 'auth_storage_state_not_implemented.dart'
    if (dart.library.io) 'auth_storage_state_native.dart'
    if (dart.library.html) 'auth_storage_state_web.dart';

abstract class AuthStorageState extends State<AuthStorage> {
  factory AuthStorageState() {
    return AuthStorageStateImpl();
  }
  AuthStorageState.newInstance();

  List<Account> accounts = <Account>[];
  Account? activeAccount;

  @override
  void initState() {
    super.initState();

    updateState();
  }

  Future<void> updateState();

  void setActiveAccount(Account? account);
}
