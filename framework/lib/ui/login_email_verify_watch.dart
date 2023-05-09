import 'dart:async';
import 'package:flutter/material.dart';

import '../timu_api/login_api.dart';
import 'watch.dart';

class LoginEmailVerifyWatch extends StatelessWidget {
  LoginEmailVerifyWatch({super.key, required this.jwt, required this.verified});

  final String jwt;
  final void Function() verified;
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
      passed: verified,
    );
  }
}


// import 'dart:async';
// import 'package:flutter/material.dart';
// // import 'dart:convert';
// // import 'package:go_router/go_router.dart';

// import '../timu_api/login_api.dart';

// const int POLL_SECONDS = 3;

// class LoginEmailVerifyWatch extends StatefulWidget {
//   const LoginEmailVerifyWatch(
//       {super.key, required this.jwt, required this.verified});

//   final String jwt;
//   final void Function() verified;

//   @override
//   LoginEmailVerifyWatchState createState() => LoginEmailVerifyWatchState();
// }

// class LoginEmailVerifyWatchState extends State<LoginEmailVerifyWatch> {
//   final LoginApi _loginApi = LoginApi();
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     _startPolling();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   void _startPolling() {
//     _timer =
//         Timer.periodic(const Duration(seconds: POLL_SECONDS), (timer) async {
//       final isVerified = await _check();
//       if (isVerified) {
//         timer.cancel();

//         widget.verified();
//       }
//     });
//   }

//   Future<bool> _check() async {
//     try {
//       final result = await _loginApi.isEmailVerified(widget.jwt);
//       return result != null && result;
//     } catch (e) {
//       print('Error: $e');
//     }

//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const SizedBox.shrink();
//   }
// }
