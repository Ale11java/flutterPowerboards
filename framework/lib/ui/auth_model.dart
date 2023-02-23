import 'dart:async';

import 'package:flutter/material.dart';

import '../model/account.dart';
import '../model/storage.dart';
import 'app_lifecycle_detector.dart';

class StorageProvider extends StatefulWidget {
  StorageProvider({super.key, required this.child}) : storage = Storage();

  final Storage storage;
  final Widget child;

  @override
  State<StatefulWidget> createState() => _StorageState();
}

class _StorageState extends State<StorageProvider> {
  List<Account> accounts = <Account>[];
  Account? activeAccount;

  @override
  void initState() {
    super.initState();

    updateState();

    //listen for enum that says what props changed - if accounts or activeAccount changed then accounts = storage.getAccounts() inside listener
    widget.storage.changeStream.listen((AuthModelProp prop) {
      if (prop == AuthModelProp.activeAccount ||
          prop == AuthModelProp.accounts) {
        updateState();
      }
    });
  }

  Future<void> updateState() async {
    accounts = await widget.storage.getAccounts();
    activeAccount = await widget.storage.getActiveAccount();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AuthModel(
        accounts: accounts,
        activeAccount: activeAccount,
        child: AppLifecycleDetector(
            onResumed: () {
              updateState();
            },
            child: widget.child));
  }
}

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

  static Storage storageOf(BuildContext context) {
    return context.findAncestorWidgetOfExactType<StorageProvider>()!.storage;
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
