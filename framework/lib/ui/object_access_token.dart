import 'package:flutter/material.dart';

import '../model/account.dart';

class ObjectAccessTokenProvider extends StatefulWidget {
  const ObjectAccessTokenProvider({super.key, required this.child});

  final Widget child;

  @override
  State<ObjectAccessTokenProvider> createState() =>
      ObjectAccessTokenProviderState();
}

class ObjectAccessTokenProviderState extends State<ObjectAccessTokenProvider> {
  Map<String, Account> objectTokens = {};

  static ObjectAccessTokenProviderState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<ObjectAccessTokenProviderState>();
  }

  static ObjectAccessTokenProviderState of(BuildContext context) {
    final result = maybeOf(context);

    assert(result != null,
        'ObjectAccessTokenProviderState does not exists in the tree');

    return result!;
  }

  Account? getAccount(String nounUrl) {
    return objectTokens[nounUrl];
  }

  setAccount(String nounUrl, Account account) {
    setState(() {
      objectTokens = {...objectTokens, nounUrl: account};
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
