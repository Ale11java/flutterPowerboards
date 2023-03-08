import 'package:flutter/material.dart';
import 'auth_storage_state.dart';

class AuthStorage extends StatefulWidget {
  const AuthStorage({super.key, required this.child});

  final Widget child;

  @override
  State<StatefulWidget> createState() => AuthStorageState();
}
