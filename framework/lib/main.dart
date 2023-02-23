import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'ui/auth_model.dart';
import 'ui/home_page.dart';
import 'ui/list_route_page.dart';
import 'ui/screen_text.dart';
import 'ui/screen_title.dart';
import 'ui/storage_login.dart';

void main() {
  runApp(const MyApp());
}

final List<GoRoute> routes = <GoRoute>[
  GoRoute(
    name: 'Root',
    path: '/',
    builder: (BuildContext context, GoRouterState state) => ListRoutesPage(routes: routes),
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
      backgroundColor: Colors.blue,
      body: Center(
        child: ScreenText(text: 'brown fox jumps over the lazy dog'),
      ),
    ),
  ),

];

final GoRouter _router = GoRouter(
  routes: routes
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StorageProvider(
      child: MaterialApp.router(
        theme: ThemeData(primarySwatch: Colors.blue),
        routerConfig: _router,
      ),

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
    );
  }
}
