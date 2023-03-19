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
import 'storage_login_page.dart';
import 'websocket_provider.dart';

enum Progress {
  processing,
  needsAccess,
  registerGuest,
  accountPrompt,
  selectAccount,

  hasAccess,
  waitingForApproval,
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

class RequireAccess extends StatefulWidget {
  const RequireAccess({super.key, required this.nounUrl, required this.child});

  final String nounUrl;
  final Widget child;

  @override
  State<RequireAccess> createState() => _RequireAccessState();
}

class _RequireAccessState extends State<RequireAccess> {
  Progress progress = Progress.processing;

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

        setState(() {
          progress = Progress.waitingForApproval;
        });
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
          progress = Progress.hasAccess;
        });
      } on AccessDeniedError {
        // TODO: need a screen here that lets me choose to continue as existing user, as guest, or switch accounts
        setState(() {
          progress = Progress.waitingForApproval;
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

  onApprove() {}

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

  onDeined() {
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

    progress = Progress.processing;
    print('initializing require access');

    if (curAccount != null &&
        (activeAccount == null || curAccount.key != activeAccount.key)) {
      storage.setActiveAccount(curAccount);
    } else {
      checkAccess(activeAccount);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('jkkk build process $progress');
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

      case Progress.waitingForApproval:
        return WebsocketProvider(
            nounUrl: widget.nounUrl,
            channel: 'lobby',
            child: LobbyWaitPage(
              onApproved: onApprove,
              onDenied: onDeined,
            ),
            metadata: <String, dynamic>{"waiting": true});

      case Progress.meetingNotFound: // Fallthrough
      case Progress.processing:
        return const Center(
            child: SizedBox(
                width: 50, height: 50, child: CircularProgressIndicator()));

      case Progress.hasAccess:
        return WebsocketProvider(
            nounUrl: widget.nounUrl,
            channel: 'lobby',
            child: _NotificationPopup(child: widget.child));

      case Progress.denied:
        return const Center();
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
  StreamSubscription? sub;
  List<Client> waitingGuests = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final ws = WebsocketState.of(context).websocket;
    final Account? activeAccount = AuthModel.of(context).activeAccount;
    final me = MyProfileProvider.of(context);

    sub?.cancel();
    sub = ws?.listenClients((clients) {
      setState(() {
        waitingGuests = clients
            .where((client) => client.metadata["waiting"] == true)
            .toList(growable: false);
      });
    });
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      widget.child,
      Overlay(initialEntries: <OverlayEntry>[
        OverlayEntry(builder: (BuildContext context) {
          return Positioned(
              top: 50,
              right: 50,
              child: Column(
                  children: waitingGuests
                      .map<Widget>((client) => _ClientWidget(client))
                      .superJoin(const SizedBox(height: 10))
                      .toList(growable: false)));
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
      initials: firstName[0].toUpperCase() + lastName[0].toUpperCase(),
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
