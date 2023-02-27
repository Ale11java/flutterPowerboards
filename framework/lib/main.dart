import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'ui/auth_model.dart';
import 'ui/join_text_field.dart';
import 'ui/home_page.dart';
import 'ui/list_route_page.dart';
import 'ui/storage_login.dart';
import 'ui/test.dart';
import 'ui/text.dart';

void main() {
  runApp(const MyApp());
}

List<GoRoute> genRoutes() {
  return <GoRoute>[
    GoRoute(
      name: 'Root',
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          ListRoutesPage(routes: genRoutes()),
    ),
    GoRoute(
      name: 'Join Text Field',
      path: '/join-text-field',
      builder: (BuildContext context, GoRouterState state) => Scaffold(
        backgroundColor: const Color(0XFF2F2D57),
        body: Center(
          child: SizedBox(
            width: 400,
            height: 46,
            child: Column(
              children: const <Widget>[JoinTextField()],
            ),
          ),
        ),
      ),
    ),
    GoRoute(
      name: 'Test',
      path: '/test',
      builder: (BuildContext context, GoRouterState state) => Scaffold(
        backgroundColor: const Color(0XFF2F2D57),
        body: Center(
          child: SizedBox(
            width: 400,
            height: 46,
            child: Column(
              children: const <Widget>[TestWidget()],
            ),
          ),
        ),
      ),
    ),
    GoRoute(
      name: 'Home Page',
      path: '/my-home-page',
      builder: (BuildContext context, GoRouterState state) =>
          const StorageLogin(
        childLoggedIn: MyHomePage(title: 'Before you go in, are you the host?'),
      ),
    ),
    GoRoute(
      name: 'Screen Title',
      path: '/screen-title',
      builder: (BuildContext context, GoRouterState state) => const Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: ScreenTitle(text: 'brown fox jumps over the lazy dog'),
        ),
      ),
    ),
    GoRoute(
      name: 'Screen Text',
      path: '/screen-text',
      builder: (BuildContext context, GoRouterState state) => const Scaffold(
        body: Center(
          child: ScreenText(text: 'brown fox jumps over the lazy dog'),
        ),
      ),
    ),
  ];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter routerConfig = GoRouter(routes: genRoutes());

    return MaterialApp.router(
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: routerConfig,
    );

    // child: StorageLogin(
    //   childLoggedIn: MaterialApp(
    //     // title: 'TIMU Powerboards',
    //     theme: ThemeData(
    //       primarySwatch: Colors.blue,
    //     ),
    //     routes: {
    //       '/': (BuildContext context) =>
    //           const MyHomePage(title: 'Before you go in, are you the host?'),
    //       '/settings': (BuildContext context) =>
    //           const MyHomePage(title: 'Settings'),
    //     },
    //   ),
    // ),
  }
}
