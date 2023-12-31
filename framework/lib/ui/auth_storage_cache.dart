import 'package:flutter/material.dart';

import '../model/account.dart';
import '../model/auth_storage.dart';

import '../timu_api/timu_api.dart';
import 'app_lifecycle_detector.dart';
import 'auth_model.dart';
import 'object_access_token.dart';

class AuthStorageCache extends StatelessWidget {
  const AuthStorageCache({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AuthStorageProvider(child: _AuthStorageCacheInner(child: child));
  }
}

class _AuthStorageCacheInner extends StatefulWidget {
  const _AuthStorageCacheInner({required this.child});

  final Widget child;

  @override
  State<StatefulWidget> createState() => AuthStorageCacheState();
}

class AuthStorageCacheState extends State<_AuthStorageCacheInner> {
  List<Account>? accounts;
  Account? activeAccount;
  bool initialized = false;

  static AuthStorageCacheState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<AuthStorageCacheState>();
  }

  static AuthStorageCacheState of(BuildContext context) {
    final result = maybeOf(context);

    assert(result != null, 'AuthStorageCacheState not found in widget tree');

    return result!;
  }

  bool get isLoggedIn {
    return activeAccount != null;
  }

  bool get hasAccounts {
    return !(accounts?.isEmpty ?? false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    updateState();
  }

  void updateState() {
    final storage = super.context.findAncestorStateOfType<AuthStorage>()!;

    storage.getAccounts().then((acts) {
      return storage.getActiveAccount().then((account) {
        setState(() {
          accounts = acts;
          activeAccount = account;
          initialized = true;
        });
      });
    });
  }

  void setActiveAccount(Account? account) {
    final storage = super.context.findAncestorStateOfType<AuthStorage>()!;

    setState(() {
      activeAccount = account;
    });

    storage.setActiveAccount(account);
  }

  void addAccount(Account account) {
    final storage = super.context.findAncestorStateOfType<AuthStorage>()!;
    storage.addAccount(account);

    setState(() {
      accounts = [...?accounts, account];
      activeAccount = account;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthModel(
      accounts: accounts ?? [],
      activeAccount: activeAccount,
      child: AppLifecycleDetector(
          child: initialized
              ? BaseUrl(
                  child: TimuApiProvider(
                  api: TimuApi(
                      accessToken: activeAccount?.accessToken ?? '',
                      host: BaseUrl.apiHost,
                      headers: <String, String>{
                        'Content-Type': 'application/json',
                      }),
                  child: ObjectAccessTokenProvider(child: widget.child),
                ))
              : const Center(
                  child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator())),
          onResumed: () {
            updateState();
          }),
    );
  }
}
