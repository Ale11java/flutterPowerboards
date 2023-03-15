import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'account.dart';
import 'auth_storage.dart';
import 'shared_preferences.dart';

class AuthStorageImpl extends AuthStorage {
  AuthStorageImpl() : super.newInstance();

  static const String appStorageKey = 'powerboards';
  static const String activeAccountStorageKey = 'activeAccount_$appStorageKey';
  static const String accountsStorageKey = 'accounts';
  static const String serviceName = 'com.timu3';

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    iOptions: IOSOptions(
      accountName: serviceName,
    ),
    aOptions: AndroidOptions(
      // encryptedSharedPreferences: true,
      sharedPreferencesName: serviceName,
    ),
  );

  @override
  Future<List<Account>> getAccounts() async {
    String? accountsJson;
    if (Platform.isAndroid) {
      accountsJson = await SharedPreferences().read(
        key: accountsStorageKey,
      );
    } else if (Platform.isIOS) {
      accountsJson = await _storage.read(
        key: accountsStorageKey,
      );
    }

    if (accountsJson != null) {
      final Map<String, dynamic> data =
          jsonDecode(accountsJson) as Map<String, dynamic>;
      final List<Account> accounts = data.entries
          .map((MapEntry<String, dynamic> entry) => Account.fromMapEntry(entry))
          .toList(growable: false);
      return accounts;
    }

    return <Account>[];
  }

  @override
  Future<Account?> getActiveAccount() async {
    final List<Account> accounts = await getAccounts();

    final String? activeAccountKey = await _storage.read(
      key: activeAccountStorageKey,
    );

    if (accounts.isNotEmpty && activeAccountKey != null) {
      final Account? activeAccount = accounts.cast<Account?>().firstWhere(
            (Account? element) => element!.key == activeAccountKey,
            orElse: () => null,
          );

      if (activeAccount != null) {
        return activeAccount;
      }
    }

    return null;
  }

  @override
  Future<void> setActiveAccount(Account? account) async {
    await _storage.write(
      key: activeAccountStorageKey,
      value: account?.key,
    );
  }

  @override
  Future<void> addAccount(Account account) async {
    await _storage.write(key: activeAccountStorageKey, value: account.key);

    final accounts = await getAccounts();
    await _storage.write(
      key: accountsStorageKey,
      value: jsonEncode([...accounts, account]),
    );
  }
}
