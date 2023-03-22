import 'dart:async';

import 'package:flutter/material.dart';

import '../model/account.dart';
import '../model/auth_storage.dart';
import '../timu_api/timu_api.dart';
import '../timu_api/websocket.dart';

import 'account_prompt_page.dart';
import 'auth_model.dart';
import 'auth_storage_cache.dart';
import 'guest_entry_page.dart';
import 'lobby_wait_page.dart';
import 'login_prompt_page.dart';
import 'notification.dart';
import 'object_access_token.dart';
import 'profile_avatar.dart';
import 'storage_login_page.dart';
import 'websocket_clients.dart';
import 'websocket_provider.dart';

enum Progress {
  processing,
  needsAccess,
  registerGuest,
  accountPrompt,
  selectAccount,

  joining,
  waiting,
  granted,
  meetingNotFound,
}

extension IterableExt<T> on Iterable<T> {
  Iterable<T> superJoin(T separator) {
    final iterator = this.iterator;
    if (!iterator.moveNext()) {
      return [];
    }

    final l = [iterator.current];
    while (iterator.moveNext()) {
      l
        ..add(separator)
        ..add(iterator.current);
    }

    return l;
  }
}

typedef JoiningBuilder = Widget Function(BuildContext, bool, void Function());
typedef WaitingBuilder = Widget Function(BuildContext);
typedef GrantedBuilder = Widget Function(BuildContext);

class RequireAccess extends StatefulWidget {
  const RequireAccess(
      {super.key,
      required this.nounUrl,
      required this.joining,
      required this.waiting,
      required this.granted});

  final String nounUrl;

  final JoiningBuilder joining;
  final WaitingBuilder waiting;
  final GrantedBuilder granted;

  @override
  State<RequireAccess> createState() => _RequireAccessState();
}

class _RequireAccessState extends State<RequireAccess> {
  Progress progress = Progress.processing;
  bool hasAccess = false;
  Completer<bool> accessComp = Completer<bool>();

  onRegisterUser(String firstName, String lastName) {
    final api = TimuApiProvider.of(super.context).api;

    setState(() {
      progress = Progress.processing;
    });

    api.invoke(
      name: 'register-as-guest',
      nounPath: widget.nounUrl,
      public: true,
      body: {
        'firstName': firstName,
        'lastName': lastName,
      },
    ).then((res) {
      final String? token = res['token'];

      if (token != null) {
        final storage =
            context.findAncestorStateOfType<AuthStorageCacheState>();

        storage?.addAccount(Account(
            key: 'register-as-user',
            email: 'guest',
            firstName: firstName,
            lastName: lastName,
            accessToken: token,
            method: 'register',
            provider: 'guest'));
      }
    });
  }

  Future<void> checkAccess(Account? activeAccount) async {
    final oat = ObjectAccessTokenProviderState.of(context);
    final token = oat.getToken(widget.nounUrl);

    if (token != null) {
      progress = Progress.granted;
      return;
    }

    if (activeAccount != null) {
      final api = TimuApiProvider.of(super.context).api;

      try {
        await api.invoke(
            name: 'demand-role',
            nounPath: widget.nounUrl,
            public: true,
            body: {'role': 'core:contributor'});

        setState(() {
          hasAccess = true;

          progress = Progress.joining;
        });
      } on AccessDeniedError {
        setState(() {
          progress = Progress.joining;
        });
      } on RequiresAuthenticationError {
        setState(() {
          progress = Progress.needsAccess;
        });
      } on NotFoundError {
        setState(() {
          progress = Progress.meetingNotFound;
        });
      }
    } else {
      setState(() {
        progress = Progress.needsAccess;
      });
    }
  }

  onApprove() {
    setState(() {
      progress = Progress.granted;
    });
  }

  onLogin() {
    final storage = AuthStorageCacheState.of(super.context);

    if (storage.hasAccounts) {
      setState(() {
        progress = Progress.accountPrompt;
      });
    } else {
      redirectToLogin(super.context);
    }
  }

  onSelectAccount() {
    setState(() {
      progress = Progress.selectAccount;
    });
  }

  onContinueAsGuest() {
    setState(() {
      progress = Progress.registerGuest;
    });
  }

  onContinueToLobby() {
    setState(() {
      progress = Progress.waiting;
    });
  }

  onDenied() {
    // Don't do anything
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();

    final Account? activeAccount = AuthModel.of(super.context).activeAccount;

    setState(() {
      progress = Progress.processing;
      hasAccess = false;
    });

    checkAccess(activeAccount);
  }

  @override
  Widget build(BuildContext context) {
    switch (progress) {
      case Progress.needsAccess:
        return LoginPromptPage(
            onLogin: onLogin, onContinueAsGuest: onContinueAsGuest);

      case Progress.accountPrompt:
        return AccountPromptPage(
            onSelectAccount: onSelectAccount, onLogin: onLogin);

      case Progress.selectAccount:
        return const StorageLoginPage();

      case Progress.registerGuest:
        return GuestEntryPage(onRegisterUser);

      case Progress.meetingNotFound: // Fallthrough
      case Progress.processing:
        return const Center(
            child: SizedBox(
                width: 50, height: 50, child: CircularProgressIndicator()));

      case Progress.joining:
        return wrap(widget.joining(context, hasAccess, () {
          setState(() {
            progress = hasAccess ? Progress.granted : Progress.waiting;
          });
        }));

      case Progress.waiting:
        return WebsocketProvider(
            nounUrl: widget.nounUrl,
            channel: 'lobby',
            metadata: const <String, dynamic>{'waiting': true},
            child: LobbyWaitPage(
              onApproved: onApprove,
              onDenied: onDenied,
              child: wrap(widget.waiting(context)),
            ));

      case Progress.granted:
        final token =
            ObjectAccessTokenProviderState.of(context).getToken(widget.nounUrl);
        final Account activeAccount =
            AuthModel.of(super.context).activeAccount!;
        final api = TimuApiProvider.of(context)
            .api
            .withToken(token ?? activeAccount.accessToken!);

        return TimuApiProvider(
            api: api,
            child: WebsocketProvider(
                nounUrl: widget.nounUrl,
                channel: 'lobby',
                child:
                    _NotificationPopup(child: wrap(widget.granted(context)))));
    }
  }
}

class _NotificationPopup extends StatefulWidget {
  const _NotificationPopup({required this.child});

  final Widget child;

  @override
  State<_NotificationPopup> createState() => _NotificationPopupState();
}

class _NotificationPopupState extends State<_NotificationPopup> {
  Set<String> dismissed = {};

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      widget.child,
      Overlay(initialEntries: <OverlayEntry>[
        OverlayEntry(builder: (BuildContext context) {
          return WebsocketClients(
              builder: (context, clients) => Positioned(
                  top: 50,
                  right: 50,
                  child: Column(
                      children: clients
                          .where((client) =>
                              client.metadata['waiting'] == true &&
                              !dismissed.contains(client.id))
                          .map<Widget>((client) => _ClientWidget(client, () {
                                setState(() {
                                  dismissed.add(client.id);
                                });
                              }))
                          .superJoin(const SizedBox(height: 10))
                          .toList(growable: false))));
        })
      ]),
    ]);
  }
}

class _ClientWidget extends StatelessWidget {
  const _ClientWidget(this.client, this.onDismiss);

  final Client client;
  final void Function() onDismiss;

  @override
  Widget build(BuildContext context) {
    Future<void> grantAccess() async {
      final parent = context.findAncestorWidgetOfExactType<RequireAccess>();
      final ws = WebsocketState.of(context).websocket;

      onDismiss();

      if (parent != null) {
        final api = TimuApiProvider.of(context).api;
        final userId = client.profile['id'];

        final response = await api.invoke(
          name: 'grant-access',
          nounPath: parent.nounUrl,
          body: {'id': client.profile['id']},
        );

        final String jwt = response['token'] as String;

        ws?.publish({
          'token': jwt
        }, {
          'claims': [
            {
              'name': 'id',
              'value': userId,
            }
          ]
        });
      }
    }

    deny() {
      final ws = WebsocketState.of(context).websocket;
      final userId = client.profile['id'];

      onDismiss();

      ws?.publish({
        'denied': true,
      }, {
        'claims': [
          {
            'name': 'id',
            'value': userId,
          }
        ]
      });
    }

    final String firstName = client.profile['firstName'];
    final String lastName = client.profile['lastName'];

    return NotificationWidget(
      avatar: ProfileAvatar(profile: TimuObject(client.profile), size: 50),
      title: '$firstName $lastName',
      text: 'is waiting in the lobby',
      primaryAction: NotificationAction(
        label: 'Approve',
        onPressed: grantAccess,
      ),
      secondaryAction: NotificationAction(
        label: 'Ignore',
        onPressed: deny,
      ),
    );
  }
}

Widget wrap(Widget child) {
  return ColoredBox(
      color: const Color(0XFF2F2D57),
      child: Center(
          child: SingleChildScrollView(
              child: SizedBox(width: 400, child: child))));
}
