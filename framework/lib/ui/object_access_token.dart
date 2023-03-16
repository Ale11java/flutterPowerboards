import 'package:flutter/material.dart';

import '../timu_api/timu_api.dart';

class ObjectAccessTokenProvider extends StatefulWidget {
  const ObjectAccessTokenProvider({super.key, required this.child});

  final Widget child;

  @override
  State<ObjectAccessTokenProvider> createState() => ObjectAccessTokenProviderState();
}

class ObjectAccessTokenProviderState extends State<ObjectAccessTokenProvider> {
  Map<String, String> objectTokens = <String, String>{};

  static ObjectAccessTokenProviderState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<ObjectAccessTokenProviderState>();
  }

  static ObjectAccessTokenProviderState of(BuildContext context) {
    final result = maybeOf(context);

    assert(result != null, 'ObjectAccessTokenProviderState does not exists in the tree');
    
    return result!;
  }

  setToken(String nounUrl, String token) {
    setState(() {
      objectTokens = {...objectTokens, nounUrl: token};
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;

    //return TimuApiProvider(
    //  api: TimuApi(
    //    accessToken: objectTokens['jwt'] ?? '',
    //    host: 'usa.timu.life',
    //    headers: <String, String>{
    //      'Content-Type': 'application/json',
    //    }),
    //  child: widget.child,
    //);
  }
}
