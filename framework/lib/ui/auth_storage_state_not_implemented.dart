import 'dart:async';
import 'package:flutter/material.dart';

import '../model/account.dart';
import 'auth_storage_state.dart';

class AuthStorageStateImpl extends AuthStorageState {
  AuthStorageStateImpl() : super.newInstance();

  @override
  Future<void> updateState() {
    throw UnimplementedError();
  }

  @override
  void setActiveAccount(Account? account) {
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
