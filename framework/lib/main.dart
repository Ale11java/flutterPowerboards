import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'ui/auth_model.dart';
import 'ui/guest_entry_page.dart';
import 'ui/home_page.dart';
import 'ui/join_text_field.dart';
import 'ui/list_route_page.dart';
import 'ui/lobby_page.dart';
import 'ui/notification.dart';
import 'ui/storage_login.dart';
import 'ui/text.dart';
import 'ui/dialog_buttons.dart';
import 'ui/sidebar_group.dart';
import 'ui/participant_overlay.dart';

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
    GoRoute(
      name: 'Notification',
      path: '/notification',
      builder: (BuildContext context, GoRouterState state) =>
          NotificationWidget(
        avatar: NetworkImage('https://www.example.com/avatar.jpg'),
        title: 'Participant Name',
        text: 'is waiting in lobby...',
        primaryAction: NotificationAction(
          label: 'View',
          onPressed: () {
            // handle the action when the user taps the primary button
          },
        ),
        secondaryAction: NotificationAction(
          label: 'Dismiss',
          onPressed: () {
            // handle the action when the user taps the secondary button
          },
        ),
      ),
    ),

    GoRoute(
      name: 'Dialog Buttons',
      path: '/dialog-buttons',
      builder: (BuildContext context, GoRouterState state) => Scaffold(
        body: Center(
          child: ButtonSize(
            width: 200.0,
            children: [
              EmphasizedDialogButton(
                bgColor: Color(0xFFED6464),
                onPressed: () {},
                child: const DialogButtonText(text: 'JOIN NOW'),
              ),
              MaxTextWidthButtonSize(
                minWidth: 200.0,
                text: const [
                  Text('Button with really long text that needs to be wrapped'),
                  Text('Another button with long text'),
                ],
                children: [
                  CancelDialogButton(
                    bgColor: Color(0xff2f2d57),
                    onPressed: () {},
                    child: const DialogButtonText(text: 'NO'),
                  ),
                  OkDialogButton(
                    bgColor: Color(0xFF7752FF),
                    onPressed: () {},
                    child: const DialogButtonText(
                      text: 'YES',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    GoRoute(
      name: 'Sidebar Group',
      path: '/sidebar-group',
      builder: (BuildContext context, GoRouterState state) => const Scaffold(
        body: Center(
            child: SidebarGroup(
          title: 'Create/View/Present/Share',
          children: [
            SidebarGroupButton(
              icon: AssetImage('assets/create.png'),
              text: 'Create',
            ),
            SidebarGroupButton(
              icon: AssetImage('assets/view.png'),
              text: 'View',
            ),
            SidebarGroupButton(
              icon: AssetImage('assets/present.png'),
              text: 'Present',
            ),
            SidebarGroupButton(
              icon: AssetImage('assets/share.png'),
              text: 'Share',
            ),
          ],
        )),
      ),
    ),
    GoRoute(
      name: 'Participant Overlay',
      path: '/participant-overlay',
      builder: (BuildContext context, GoRouterState state) => const Scaffold(
        body: Center(
          child: ParticipantOverlay(
            name: 'John Doe',
            muted: false,
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
