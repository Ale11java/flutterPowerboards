import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

class BaseUrl extends StatelessWidget {
  BaseUrl({super.key, required this.child});

  final Uri baseUri = Uri.parse('https://meet.timu.life/');
  final Uri loginUri = Uri.parse('https://www.timu.life/login');
  static const apiHost = 'usa.timu.life';

  final Widget child;

  static BaseUrl? maybeOf(BuildContext context) {
    return context.findAncestorWidgetOfExactType<BaseUrl>();
  }

  static BaseUrl of(BuildContext context) {
    final result = maybeOf(context);

    assert(result != null, 'BaseUrl not found in the tree');

    return result!;
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

Future<void> redirectToLogin(BuildContext context) async {
  final base = context.findAncestorWidgetOfExactType<BaseUrl>();

  if (base != null) {
    final Uri redirectUri = base.baseUri;
    final Uri url = base.loginUri
        .replace(queryParameters: {'redirect_uri': redirectUri.toString()});

    if (!await launchUrl(url, webOnlyWindowName: '_self')) {
      throw Exception('Could not launch $url');
    }
  }
}
