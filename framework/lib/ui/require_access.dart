import 'dart:async';

import 'package:flutter/material.dart';

import '../model/account.dart';
import '../timu_api/timu_api.dart';
import '../timu_api/websocket.dart';
import 'auth_model.dart';
import 'auth_storage_cache.dart';
import 'guest_entry_page.dart';
import 'lobby_wait_page.dart';
import 'notification.dart';
import 'websocket_provider.dart';

enum Progress {
  init,
  loggedIn,
  needsAccess,
  hasAccess,
  waitingForApproval,
  processing,
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
  Progress progress = Progress.init;
  bool isRegistering = false;

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
          isRegistering = true;
        });
      }
    });
  }

  Future<void> checkAccess(Account? activeAccount) async {
    if (activeAccount != null) {
      final api = TimuApiProvider.of(super.context).api;

      if (isRegistering) {
        setState(() {
          progress = Progress.waitingForApproval;
        });
      } else {
        try {
          await api.invoke(
              name: 'demand-role',
              nounPath: widget.nounUrl,
              public: true,
              body: {'role': 'core:contributor'});

          setState(() {
            progress = Progress.hasAccess;
          });
        } on AccessDeniedError {
          setState(() {
            progress = Progress.waitingForApproval;
          });
        } on RequiresAuthenticationError {
          setState(() {
            progress = Progress.waitingForApproval;
          });
        } on NotFoundError {
          setState(() {
            progress = Progress.meetingNotFound;
          });
        }
      }
    } else {
      setState(() {
        progress = Progress.needsAccess;
      });
    }
  }

  onApprove() {
    setState(() {
      progress = Progress.loggedIn;
      isRegistering = false;
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

    progress = Progress.init;
    print('initializing require access');
    checkAccess(activeAccount);
  }

  @override
  Widget build(BuildContext context) {
    switch (progress) {
      case Progress.loggedIn:
        return widget.child;

      case Progress.needsAccess:
        return GuestEntryPage(onRegisterUser);

      case Progress.waitingForApproval:
        return WebsocketProvider(
          nounUrl: widget.nounUrl,
          channel: 'lobby',
          child: LobbyWaitPage(
            onApproved: onApprove,
            onDenied: onDeined,
          ),
        );

      case Progress.processing: // Fallthrough
      case Progress.meetingNotFound: // Fallthrough
      case Progress.init:
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

    final ws = WebsocketState.of(super.context).websocket;

    sub?.cancel();
    sub = ws?.listenClients((clients) {
      setState(() {
        waitingGuests = clients
            .where((client) => client.profile['type'] == 'core:guest')
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
