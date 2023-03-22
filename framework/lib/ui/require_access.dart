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
import 'user_meeting_access_denied.dart';
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
  denied,
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

typedef JoiningBuilder = Widget Function(BuildContext, void Function());
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
  Completer<bool> accessComp = Completer<bool>();
  bool joined = false;

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
    if (activeAccount != null) {
      final api = TimuApiProvider.of(super.context).api;
      final oat = ObjectAccessTokenProviderState.of(super.context);

      try {
        await api.invoke(
            name: 'demand-role',
            nounPath: widget.nounUrl,
            public: true,
            body: {'role': 'core:contributor'});

        oat.setAccount(widget.nounUrl, activeAccount);

        setState(() {
          if (!accessComp.isCompleted) {
            accessComp.complete(true);
          }

          progress = joined ? Progress.granted : Progress.joining;
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
    accessComp.complete(true);
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
    setState(() {
      progress = Progress.denied;
    });
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();

    final Account? activeAccount = AuthModel.of(super.context).activeAccount;
    final storage = AuthStorageCacheState.of(super.context);
    final oat = ObjectAccessTokenProviderState.of(super.context);
    final curAccount = oat.getAccount(widget.nounUrl);

    if (curAccount != null &&
        (activeAccount == null || curAccount.key != activeAccount.key)) {
      storage.setActiveAccount(curAccount);
    } else {
      checkAccess(activeAccount);
    }
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
        return WebsocketProvider(
            nounUrl: widget.nounUrl,
            channel: 'lobby',
            metadata: accessComp.isCompleted
                ? const <String, dynamic>{}
                : const <String, dynamic>{'waiting': true},
            child: LobbyWaitPage(
              onApproved: onApprove,
              onDenied: onDenied,
              child: widget.joining(context, () {
                setState(() {
                  joined = true;
                  progress = Progress.waiting;
                });

                accessComp.future.then((allowed) {
                  setState(() {
                    progress = allowed ? Progress.granted : Progress.denied;
                  });
                });
              }),
            ));

      case Progress.waiting:
        return WebsocketProvider(
            nounUrl: widget.nounUrl,
            channel: 'lobby',
            metadata: const <String, dynamic>{'waiting': true},
            child: LobbyWaitPage(
              onApproved: onApprove,
              onDenied: onDenied,
              child: widget.waiting(context),
            ));

      case Progress.granted:
        return WebsocketProvider(
            nounUrl: widget.nounUrl,
            channel: 'lobby',
            child: _NotificationPopup(child: widget.granted(context)));

      case Progress.denied:
        return const UserMeetingAccessDenied();
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
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      widget.child,
      Overlay(initialEntries: <OverlayEntry>[
        OverlayEntry(builder: (BuildContext context) {
          return WebsocketClients(builder: (context, clients) {
            final waitingGuests = clients
                .where((client) => client.metadata['waiting'] == true)
                .toList(growable: false);
            return Positioned(
                top: 50,
                right: 50,
                child: Column(
                    children: waitingGuests
                        .map<Widget>((client) => _ClientWidget(client))
                        .superJoin(const SizedBox(height: 10))
                        .toList(growable: false)));
          });
        })
      ]),
    ]);
  }
}

class _ClientWidget extends StatelessWidget {
  const _ClientWidget(this.client);

  final Client client;

  @override
  Widget build(BuildContext context) {
    Future<void> grantAccess(Client client) async {
      final parent = context.findAncestorWidgetOfExactType<RequireAccess>();
      final ws = WebsocketState.of(context).websocket;

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

    deny(Client client) {
      final ws = WebsocketState.of(context).websocket;
      final userId = client.profile['id'];

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
        onPressed: () => grantAccess(client),
      ),
      secondaryAction: NotificationAction(
        label: 'Deny',
        onPressed: () => deny(client),
      ),
    );
  }
}
