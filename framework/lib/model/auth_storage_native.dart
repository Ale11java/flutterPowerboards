import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'account.dart';
import 'auth_storage.dart';

class AuthStorageImpl extends AuthStorage {
  AuthStorageImpl() : super.newInstance();

  static const String appStorageKey = 'powerboards';
  static const String activeAccountStorageKey = 'activeAccount_$appStorageKey';
  static const String accountsStorageKey = 'accounts';
  static const String serviceName = 'com.timu3';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<List<Account>> getAccounts() async {
    final String? accountsJson = await _storage.read(
      key: accountsStorageKey,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );

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
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );

    if (accounts.isNotEmpty && activeAccountKey != null) {
      final Account activeAccount = accounts
          .firstWhere((Account element) => element.key == activeAccountKey);

      return activeAccount;
    }

    return null;
  }

  @override
  Future<void> setActiveAccount(Account? account) async {
    await _storage.write(
      key: activeAccountStorageKey,
      value: account?.key,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  IOSOptions _getIOSOptions() => const IOSOptions(
        accountName: serviceName,
      );

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
        sharedPreferencesName: serviceName,
        // preferencesKeyPrefix: 'Test'
      );
}
