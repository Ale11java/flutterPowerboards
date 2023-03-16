import 'package:flutter/material.dart';

class ObjectAccessTokenProvider extends StatefulWidget {
  const ObjectAccessTokenProvider({super.key, required this.child});

  final Widget child;

  @override
  State<ObjectAccessTokenProvider> createState() =>
      ObjectAccessTokenProviderState();
}

class ObjectAccessTokenProviderState extends State<ObjectAccessTokenProvider> {
  final objectTokens = <String, String>{};

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
