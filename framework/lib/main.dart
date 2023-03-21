import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'examples/floating_panel.dart';
import 'examples/header_tab_bar.dart';
import 'examples/login_prompt_page.dart';
import 'examples/meeting_header.dart';
import 'model/auth_storage.dart';
import 'test_icons.dart';
import 'timu_icons/timu_icons.dart';
import 'ui/auth_storage_cache.dart';
import 'ui/dialog_buttons.dart';
import 'ui/home_page.dart';
import 'ui/in_app_page.dart';
import 'ui/join_page.dart';
import 'ui/list_route_page.dart';
import 'ui/lobby_page.dart';
import 'ui/lobby_wait_page.dart';
import 'ui/notification.dart';
import 'ui/participant_overlay.dart';
import 'ui/primary_button.dart';
import 'ui/require_access.dart';
import 'ui/sidebar_group.dart';
import 'ui/storage_login.dart';
import 'ui/summary_button.dart';
import 'ui/text.dart';
import 'ui/toolbar.dart';
import 'ui/websocket_provider.dart';

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
      name: 'Header Tab Bar',
      path: '/header-tab-bar',
      builder: (BuildContext context, GoRouterState state) =>
          const HeaderTabBarExample(),
    ),

    GoRoute(
      name: 'Lobby Page',
      path: '/lobby-page',
      builder: (BuildContext context, GoRouterState state) => const LobbyPage(),
    ),

    GoRoute(
      name: 'Login Prompt Page',
      path: '/login-prompt-page',
      builder: (BuildContext context, GoRouterState state) =>
          const LoginPromptPageExample(),
    ),

    GoRoute(
        name: 'Lobby Wait Page',
        path: '/lobby-wait-page',
        builder: (BuildContext context, GoRouterState state) {
          final String? url = state.queryParams['nounUrl'];

          if (url != null) {
            return WebsocketProvider(
                nounUrl: url,
                channel: 'lobby',
                child: LobbyWaitPage(
                  onApproved: () {
                    print('approved');
                  },
                  onDenied: () {
                    print('denined');
                  },
                ));
          }

          return const SizedBox.shrink();
        }),

    GoRoute(
        name: 'In App Page',
        path: '/in-app-page',
        builder: (BuildContext context, GoRouterState state) {
          final String nounUrl = state.queryParams['nounUrl'] ?? '';

          return RequireAccess(nounUrl: nounUrl, child: const InAppPage());
        }),

    GoRoute(
        name: 'In App Page Prev',
        path: '/in-app-page-prev',
        builder: (BuildContext context, GoRouterState state) {
          final String? url = state.queryParams['nounUrl'];

          if (url != null) {
            return WebsocketProvider(
                nounUrl: url, channel: 'lobby', child: const InAppPage());
          }

          return const SizedBox.shrink();
        }),

    GoRoute(
      name: 'Join Text Field',
      path: '/join-text-field',
      builder: (BuildContext context, GoRouterState state) => JoinPage(),
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
      name: 'Meeting Header',
      path: '/meeting-header',
      builder: (BuildContext context, GoRouterState state) => const Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: MeetingHeaderExample(),
        ),
      ),
    ),
    GoRoute(
      name: 'Floating Panel',
      path: '/floating-panel',
      builder: (BuildContext context, GoRouterState state) => const Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: FloatingPanelExample(),
        ),
      ),
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
    GoRoute(
      name: 'Toolbar',
      path: '/toolbar',
      builder: (BuildContext context, GoRouterState state) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Toolbar(
              direction: ToolbarDirection.horizontal,
              children: [
                ToolbarButton(
                  onPressed: () => print('here'),
                  child: const Icon(TimuIcons.add_apps, color: Colors.white),
                ),
                ToolbarButton(
                  onPressed: () => print('here'),
                  child: const Icon(TimuIcons.cancel, color: Colors.white),
                ),
                EmphasizedToolbarButton(
                  onPressed: () => print('here'),
                  child: const Icon(TimuIcons.email, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    GoRoute(
      name: 'Notification',
      path: '/notification',
      builder: (BuildContext context, GoRouterState state) => Center(
        child: NotificationWidget(
          initials: 'JK',
          title: 'Participant Name',
          text: 'is waiting in lobby...',
          primaryAction: NotificationAction(
            label: 'Admit',
            onPressed: () {
              // handle the action when the user taps the primary button
            },
          ),
          secondaryAction: NotificationAction(
            label: 'Remove',
            onPressed: () {
              // handle the action when the user taps the secondary button
            },
          ),
        ),
      ),
    ),

    GoRoute(
      name: 'Dialog Buttons',
      path: '/dialog-buttons',
      builder: (BuildContext context, GoRouterState state) => Scaffold(
        body: Center(
          child: ButtonSize(
            size: const Size(96, 34),
            child: SizedBox(
              width: 400,
              height: 200,
              child: Center(
                  child: Row(children: <Widget>[
                EmphasizedDialogButton(
                  bgColor: const Color(0xFFED6464),
                  onPressed: () {},
                  textColor: Colors.white,
                  child: const DialogButtonText(text: 'JOIN NOW'),
                ),
                CancelDialogButton(
                    bgColor: const Color(0xff2f2d57),
                    onPressed: () {},
                    child: const DialogButtonText(text: 'NO'),
                    textColor: Colors.white),
                OkDialogButton(
                  bgColor: const Color(0xFF7752FF),
                  onPressed: () {},
                  child: const DialogButtonText(text: 'YES'),
                  textColor: Colors.white,
                ),

/*
              MaxTextWidthButtonSize(minWidth: 200.0, [
                Text('Button with really long text that needs to be wrapped'),
                Text('Another button with long text'),
              ], children: [
                CancelDialogButton(
                  bgColor: const Color(0xff2f2d57),
                  onPressed: () {},
                  child: const DialogButtonText(text: 'NO'),
                ),
                OkDialogButton(
                  bgColor: const Color(0xFF7752FF),
                  onPressed: () {},
                  child: const DialogButtonText(
                    text: 'YES',
                  ),
                ),
              ])
*/
              ])),
            ),
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
              icon: AssetImage('assets/app-timu.png'),
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

    return BaseUrl(
        child: Material(
            child: MaterialApp.router(
      builder: (BuildContext context, Widget? child) => AuthStorageCache(
          child: DefaultTextStyle(
              style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.normal,
                letterSpacing: 0.4,
              )),
              child: child ?? const SizedBox.shrink())),
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: routerConfig,
    )));
  }
}
