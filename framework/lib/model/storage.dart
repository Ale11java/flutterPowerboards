import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'account.dart';

class Storage {
  Storage();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  final StreamController<Account?> _controller =
      StreamController<Account?>.broadcast();
  Stream<Account?> get activeAccountStream => _controller.stream;

  Future<List<Account>> getAccounts() async {
    final String? accountsJson = await _storage.read(
      key: 'accounts',
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

  Future<Account?> getActiveAccount() async {
    final List<Account> accounts = await getAccounts();

    final String? activeJson = await _storage.read(
      key: 'activeAccount',
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );

    if (accounts.isNotEmpty && activeJson != null) {
      final Map<String, dynamic> activeMap =
          jsonDecode(activeJson) as Map<String, dynamic>;

      if (activeMap.isNotEmpty) {
        final String? accountKey = activeMap.entries.first.value as String?;

        if (accountKey != null) {
          final Account activeAccount = accounts
              .firstWhere((Account element) => element.key == accountKey);
          return activeAccount;
        }
      }
    }

    return null;
  }

  Future<void> setActiveAccount(Account account) async {
    await _storage.write(
      key: 'activeAccount',
      value: account.key,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  IOSOptions _getIOSOptions() => const IOSOptions(
        accountName: 'com.timu3',
      );

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
        // sharedPreferencesName: 'com.timu3',
        // preferencesKeyPrefix: 'Test'
      );
}

//   Future<void> addAccount(Account account) async {
//     final String key = account.email;
//     final value = account.toJson();
//     await _storage.write(key: key, value: value);
//     await _readAccounts();
//   }

//   Future<void> removeAccount(Account account) async {
//     final String key = account.email;
//     await _storage.delete(key: key);
//     await _readAccounts();
//   }


//   Future<Account?> getActiveAccount() async {
//     const String key = 'activeAccount';
//     final String? value = await _storage.read(key: key);
//     if (value != null) {
//       return Account.fromJson(value);
//     }
//     return null;
//   }

// Future<void> writeData(String key, String value) async {
//   await _storage.write(key: key, value: value);
// }

// Future<String?> readData(String key) async {
//   return _storage.read(key: key);
// }


  // Future<void> setActiveAccount(Account account) async {
  //   // await _storage.write(key: 'activeAccount', value: account.key);

  //   // _activeAccount = account;
  //   _controller.add(_activeAccount);

  //   // await _readAll();
  // }

  // Future<void> _readAll() async {
  //   final Map<String, String> all = await _storage.readAll(
  //     iOptions: _getIOSOptions(),
  //     aOptions: _getAndroidOptions(),
  //   );
  //   final String? accountsJson = all['accounts'];
  //   final String? activeJson = all['activeAccount'];

  //   if (accountsJson != null) {
  //     final Map<String, dynamic> accountsMap =
  //         jsonDecode(accountsJson) as Map<String, dynamic>;

  //     _accounts = accountsMap.entries
  //         .map((MapEntry<String, dynamic> entry) => Account.fromMapEntry(entry))
  //         .toList(growable: false);
  //   }

  //   if (_accounts.isNotEmpty && activeJson != null) {
  //     final Map<String, dynamic> activeMap =
  //         jsonDecode(activeJson) as Map<String, dynamic>;

  //     if (activeMap.isNotEmpty) {
  //       final String? accountKey = activeMap.entries.first.value as String?;

  //       if (accountKey != null) {
  //         _activeAccount = _accounts
  //             .firstWhere((Account element) => element.key == accountKey);
  //       }
  //     }
  //   }
