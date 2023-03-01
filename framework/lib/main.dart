import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'ui/auth_model.dart';
import 'ui/guest_entry_page.dart';
import 'ui/home_page.dart';
import 'ui/join_text_field.dart';
import 'ui/list_route_page.dart';
import 'ui/lobby_page.dart';
import 'ui/primary_button.dart';
import 'ui/storage_login.dart';
import 'ui/summary_button.dart';
import 'ui/text.dart';

void main() {
  runApp(const MyApp());
}

List<GoRoute> genRoutes() {
  const String sampleText0 = 'brown fox jumps over the lazy dog';

  return <GoRoute>[
    GoRoute(
      name: 'Root',
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          ListRoutesPage(routes: genRoutes()),
    ),
    GoRoute(
      name: 'Lobby Page',
      path: '/lobby-page',
      builder: (BuildContext context, GoRouterState state) => const LobbyPage(),
    ),
    GoRoute(
      name: 'Guest Entry Page',
      path: '/guest-entry-page',
      builder: (BuildContext context, GoRouterState state) =>
          const GuestEntryPage(),
    ),
    GoRoute(
      name: 'Join Text Field',
      path: '/join-text-field',
      builder: (BuildContext context, GoRouterState state) => const Scaffold(
        backgroundColor: Color(0XFF2F2D57),
        body: Center(
          child: SizedBox(
            width: 400,
            height: 46,
            child: Column(
              children: <Widget>[JoinTextField()],
            ),
          ),
        ),
      ),
    ),
//    GoRoute(
//      name: 'Test',
//      path: '/test',
//      builder: (BuildContext context, GoRouterState state) => Scaffold(
//        backgroundColor: const Color(0XFF2F2D57),
//        body: Center(
//          child: SizedBox(
//            width: 400,
//            height: 46,
//            child: Column(
//              children: const <Widget>[TestWidget()],
//            ),
//          ),
//        ),
//      ),
//    ),
    GoRoute(
      name: 'Home Page',
      path: '/my-home-page',
      builder: (BuildContext context, GoRouterState state) => StorageProvider(
          child: const StorageLogin(
        childLoggedIn: MyHomePage(title: 'Before you go in, are you the host?'),
      )),
    ),
    GoRoute(
      name: 'Screen title',
      path: '/screen-title',
      builder: (BuildContext context, GoRouterState state) => const Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: ScreenTitle(text: sampleText0),
        ),
      ),
    ),
    GoRoute(
      name: 'Screen subtitle',
      path: '/screen-subtitle',
      builder: (BuildContext context, GoRouterState state) => const Scaffold(
        body: Center(
          child: ScreenSubtitle(text: sampleText0),
        ),
      ),
    ),
    GoRoute(
      name: 'Screen text',
      path: '/screen-text',
      builder: (BuildContext context, GoRouterState state) => const Scaffold(
        body: Center(
          child: ScreenText(text: sampleText0),
        ),
      ),
    ),
    GoRoute(
      name: 'Primary button',
      path: '/primary-button',
      builder: (BuildContext context, GoRouterState state) => Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: PrimaryButton(
            text: sampleText0,
            onPressed: () {
              context.pop();
            },
          ),
        ),
      ),
    ),
    GoRoute(
      name: 'Summary button',
      path: '/summary-button',
      builder: (BuildContext context, GoRouterState state) => const Scaffold(
        backgroundColor: Color(
          0xff383658,
        ),
        body: Center(
          child: BasicSummaryButton(
            title: sampleText0,
            body: sampleText0,
            imageName: 'lib/assets/app-timu.png',
          ),
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
