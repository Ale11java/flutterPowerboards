import 'dart:async';

import 'package:flutter/material.dart';

import '../model/account.dart';
import '../model/auth_storage.dart';

import 'app_lifecycle_detector.dart';
import 'auth_model.dart';
import 'auth_storage_state.dart';

class AuthStorageStateImpl extends AuthStorageState {
  AuthStorageStateImpl() : super.newInstance();

  final AuthStorage storage = AuthStorage();

  @override
  Future<void> updateState() async {
    final acts = await storage.getAccounts();
    final active = await storage.getActiveAccount();

    setState(() {
      accounts = acts;
      activeAccount = active;
    });
  }

  @override
  void setActiveAccount(Account? account) {
    activeAccount = account;
    storage.setActiveAccount(account);
  }

  @override
  Widget build(BuildContext context) {
    return AuthModel(
      accounts: accounts,
      activeAccount: activeAccount,
      child: AppLifecycleDetector(
        child: widget.child,
        onResumed: () {
          updateState();
        }),
    );
  }
}
