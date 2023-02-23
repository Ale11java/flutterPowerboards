import 'package:flutter/material.dart';
import 'ui/auth_model.dart';
import 'ui/home_page.dart';
import 'ui/storage_login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StorageProvider(
      child: StorageLogin(
        childLoggedIn: MaterialApp(
          // title: 'TIMU Powerboards',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: {
            '/': (BuildContext context) =>
                const MyHomePage(title: 'Before you go in, are you the host?'),
            '/settings': (BuildContext context) =>
                const MyHomePage(title: 'Settings'),
          },
        ),
      ),
    );
  }
}
