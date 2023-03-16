import 'dart:async';

import 'package:flutter/material.dart';

import '../model/account.dart';
import '../timu_api/timu_api.dart';
import '../timu_api/websocket.dart';
import 'auth_model.dart';
import 'auth_storage_cache.dart';
import 'guest_entry_page.dart';
import 'lobby_wait_page.dart';
import 'websocket_provider.dart';

enum Progress {
  init,
  lggedIn,
  needsAccess,
  hasAccess,
  waitingForApproval,
  processing,
}

extension IterableExt<T> on Iterable<T> {
  Iterable<T> superJoin(T separator) {
    final iterator = this.iterator;
    if (!iterator.moveNext()) {
      return [];
    }

    final l = [iterator.current];
    while (iterator.moveNext()) {
      l..add(separator)..add(iterator.current);
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
        final storage = context.findAncestorStateOfType<AuthStorageCacheState>();

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
      }
    } else {
      setState(() {
        progress = Progress.needsAccess;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Account? activeAccount = AuthModel.of(super.context).activeAccount;

    if (progress == Progress.init) {
      checkAccess(activeAccount);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (progress) {
      case Progress.lggedIn:
        return widget.child;

      case Progress.needsAccess:
        return GuestEntryPage(onRegisterUser);

      case Progress.waitingForApproval:
        return WebsocketProvider(
          nounUrl: widget.nounUrl,
          channel: 'lobby',
          child: const LobbyWaitPage(),
        );

      case Progress.processing: // Fallthrough
      case Progress.init:
        return const Center(
            child: SizedBox(
                width: 50, height: 50, child: CircularProgressIndicator()));

      case Progress.hasAccess:
        return WebsocketProvider(
            nounUrl: widget.nounUrl,
            channel: 'lobby',
            child: _NotificationPopup(child: widget.child));

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

      Overlay(
        initialEntries: <OverlayEntry>[
          OverlayEntry(builder: (BuildContext context) {
          return Positioned(
            top: 50,
            right: 50,
            child: Column(children: waitingGuests
                .map<Widget>((client) => _ClientWidget(client))
                .superJoin(const SizedBox(height: 10))
                .toList(growable: false)));
          })
        ]
      ),
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

        final response = await api.invoke(
          name: 'grant-access',
          nounPath: parent.nounUrl,
          body: {
            'id': client.profile['id']
          },
        );

        final String jwt = response['token'] as String;

        ws?.publish({'token': jwt}, {});
      }
    }

    return Container(
        width: 400,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0XFF2F2D57),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x3a000000),
                blurRadius: 20,
                offset: Offset(0, 2),
              ),
            ]),
        child: Row(
          children: [
            Expanded(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${client.profile['firstName']} ${client.profile['lastName']}' ,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: Colors.white),
                ),
                const Text('Is waiting in lobby...',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: Colors.white),
                )
              ]
            ),
          ),
          SizedBox(
            width: 100,
            child: Column(
            children: [
              FilledButton(
                onPressed: () => grantAccess(client),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(42),
                ),
                child: const Text('APPROVE',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    color: Color(0xFF484575),
                  )),
              ),
                FilledButton(
                  onPressed: () => print('deny'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(42),
                  ),
                  child: const Text('DENY',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      color: Color(0xFF484575),
                    )
                ),
              ),
            ]),
          ),
        ]),
      );
  }
}
