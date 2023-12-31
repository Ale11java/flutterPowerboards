import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'examples/floating_panel.dart';
import 'examples/lobby.dart';
import 'examples/login_prompt_page.dart';
import 'model/auth_storage.dart';
import 'timu_icons/timu_icons.dart';
import 'ui/auth_storage_cache.dart';
import 'ui/camera_box.dart';
import 'ui/dialog_buttons.dart';
import 'ui/home_page.dart';
import 'ui/in_app_page.dart';
import 'ui/join_page.dart';
import 'ui/list_route_page.dart';
import 'ui/lobby_wait_page.dart';
import 'ui/login_email.dart';
import 'ui/login_start_email.dart';
import 'ui/login_start_jwt.dart';
import 'ui/login_theme.dart';
import 'ui/notification.dart';
import 'ui/participant_overlay.dart';
import 'ui/primary_button.dart';
import 'ui/prompt_dialog.dart';
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
        name: 'Login Email',
        path: '/login-email',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginThemeWidget(child: LoginEmailPage())),
    GoRoute(
        name: 'Start email',
        path: '/login-start-email/:email',
        builder: (BuildContext context, GoRouterState state) {
          final email = state.params['email'];
          return LoginThemeWidget(child: LoginStartEmailPage(email: email!));
        }),
    GoRoute(
        name: 'Start jwt',
        path: '/login-start-jwt/:jwt/:email',
        builder: (BuildContext context, GoRouterState state) {
          final jwt = state.params['jwt'];
          final email = state.params['email'];
          return LoginThemeWidget(
              child: LoginStartJwtPage(jwt: jwt!, email: email!));
        }),
    GoRoute(
      name: 'Lobby Example',
      path: '/lobby',
      builder: (BuildContext context, GoRouterState state) =>
          const LobbyExample(),
    ),

    GoRoute(
      name: 'Lobby Example 2',
      path: '/lobby2',
      builder: (BuildContext context, GoRouterState state) =>
          const LobbyExample(),
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
                  child: const InAppPage(),
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

          return RequireAccess(
              nounUrl: nounUrl,
              joining:
                  (BuildContext context, bool hasAccess, void Function() join) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const ScreenTitle(text: 'Join meeting'),
                    const SizedBox(height: 16),
                    const ScreenSubtitle(text: 'Daily design meetup'),
                    const SizedBox(height: 16),
                    PrimaryButton(text: 'JOIN', onPressed: join)
                  ],
                );
              },
              waiting: (BuildContext context) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ScreenTitle(
                        text: 'Please wait for the host to let you in.'),
                    SizedBox(height: 16),
                    ScreenSubtitle(text: 'Daily design meetup'),
                  ],
                );
              },
              granted: (BuildContext context) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ScreenTitle(text: 'In App'),
                    SizedBox(height: 16),
                    ScreenSubtitle(text: 'Daily design meetup'),
                  ],
                );
              });
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
      builder: (BuildContext context, GoRouterState state) => const JoinPage(),
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
                  child: const Icon(TimuIcons.comments, color: Colors.white),
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
            child: SidebarGroup(title: 'Daily Design Meeting', createChildren: [
          SidebarGroupButton(
            icon: TimuIcons.layer_layout_grid,
            text: 'New layout',
          ),
        ], viewChildren: [
          SidebarGroupButton(
            icon: TimuIcons.browse,
            text: 'Browse Contents',
          ),
          SidebarGroupButton(
            icon: TimuIcons.hide,
            text: 'Hide meeting controls',
          ),
          SidebarGroupButton(
            icon: TimuIcons.people,
            text: 'Show people here',
          ),
          SidebarGroupButton(
            icon: TimuIcons.layers,
            text: 'Show layers',
          ),
          SidebarGroupButton(
            icon: TimuIcons.tools,
            text: 'Show editing tools',
          ),
        ], presentChildren: [
          SidebarGroupButton(
            icon: TimuIcons.present_start,
            text: 'Start presentation',
          ),
          SidebarGroupButton(
            icon: TimuIcons.present_play,
            text: 'Record presentation',
          ),
        ], shareChildren: [
          SidebarGroupButton(
            icon: TimuIcons.add_people,
            text: 'Invite people',
          ),
        ], children: []
                // ...
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
    GoRoute(
      name: 'Camera Box',
      path: '/camera-box',
      builder: (BuildContext context, GoRouterState state) => Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: CameraBox(
                      camera: Image.asset('lib/assets/cam1.png'),
                      participantName: 'Jane Doe',
                      muted: false,
                    ),
                  ),
                  Expanded(
                    child: CameraBox(
                      camera: Image.asset('lib//assets/cam2.png'),
                      participantName: 'James Carter',
                      muted: true,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: CameraBox(
                      camera: Image.asset('lib//assets/cam3.png'),
                      participantName: 'Jenny Taylor',
                      muted: false,
                    ),
                  ),
                  Expanded(
                    child: CameraBox(
                      camera: Image.asset('lib//assets/cam4.png'),
                      participantName: 'Bob Denim',
                      muted: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    GoRoute(
      name: 'Prompt Dialog',
      path: '/prompt-dialog',
      builder: (context, state) => TimuDialogTheme(
        child: PromptDialog(
          input: 'Title',
          placeholder: 'Input',
          initialValue: '',
          onOkPressed: (String value) {
            print('User entered: $value');
          },
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
