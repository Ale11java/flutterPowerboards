import 'dart:async';
import 'package:flutter/material.dart';

import 'account.dart';
import 'auth_storage_not_implemented.dart'
    if (dart.library.io) 'auth_storage_native.dart'
    if (dart.library.html) 'auth_storage_web.dart';

abstract class AuthStorage extends State<AuthStorageProvider> {
  factory AuthStorage() {
    return AuthStorageImpl();
  }

  AuthStorage.newInstance();

  Future<List<Account>> getAccounts();

  Future<Account?> getActiveAccount();

  Future<void> setActiveAccount(Account? account);
  Future<void> addAccount(Account account);

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class AuthStorageProvider extends StatefulWidget {
  const AuthStorageProvider({required this.child, super.key});

  final Widget child;
  @override
  State<StatefulWidget> createState() => AuthStorage();
}
