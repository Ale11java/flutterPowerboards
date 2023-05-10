import 'dart:async';
import 'package:flutter/material.dart';

import '../timu_api/login_api.dart';
import 'watch.dart';

class LoginNetworkWatch extends StatelessWidget {
  LoginNetworkWatch({super.key, required this.jwt, required this.passed});

  final String jwt;
  final void Function() passed;
  final LoginApi _loginApi = LoginApi();

  Future<bool> _check() async {
    try {
      final result = await _loginApi.isEmailVerified(jwt);
      return result != null && result;
    } catch (e) {
      print('Error: $e');
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Watch(
      check: _check,
      passed: passed,
    );
  }
}
