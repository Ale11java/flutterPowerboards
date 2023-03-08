import 'package:flutter/material.dart';

import '../model/account.dart';

enum AuthModelProp { accounts, activeAccount }

class AuthModel extends InheritedModel<AuthModelProp> {
  const AuthModel(
      {required this.accounts,
      this.activeAccount,
      super.key,
      required super.child});

  final List<Account> accounts;
  final Account? activeAccount;

  static AuthModel? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthModel>()!;
  }

  static AuthModel of(BuildContext context) {
    return maybeOf(context)!;
  }

  @override
  bool updateShouldNotify(covariant AuthModel oldWidget) {
    return oldWidget.activeAccount != activeAccount ||
        oldWidget.accounts != accounts;
  }

  @override
  bool updateShouldNotifyDependent(
      covariant AuthModel oldWidget, Set<AuthModelProp> dependencies) {
    if (dependencies.contains(AuthModelProp.activeAccount) &&
        oldWidget.activeAccount != activeAccount) {
      return true;
    }

    if (dependencies.contains(AuthModelProp.accounts) &&
        oldWidget.accounts != accounts) {
      return true;
    }
    return false;
  }
}
