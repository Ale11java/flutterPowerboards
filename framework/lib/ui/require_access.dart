import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'notification.dart';
import '../timu_api/websocket.dart';
import 'websocket_clients.dart';
import 'websocket_provider.dart';

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
import 'dart:typed_data';
import 'package:flutter/services.dart';

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
        // progress = Progress.accountPrompt;
        progress = Progress.selectAccount;
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
        return wrap(widget.joining(context, hasAccess, () async {
          final api = TimuApiProvider.of(context).api;
          if (!hasAccess) {
            final maybeToken = await api.invoke(
                nounPath: widget.nounUrl, name: "request-access", params: {});

            if (maybeToken["token"] != null && maybeToken["token"] is String) {
              ObjectAccessTokenProviderState.of(context)
                  .setToken(widget.nounUrl, maybeToken["token"]);

              hasAccess = true;
            }
          }
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
        final Account activeAccount =
            AuthModel.of(super.context).activeAccount!;
        final oat =
            ObjectAccessTokenProviderState.of(context).getToken(widget.nounUrl);
        final token = oat ?? activeAccount.accessToken!;

        final api = TimuApiProvider.of(context).api.withToken(token);

        print("Object access token: $oat");
        print("Active account token: ${activeAccount?.accessToken}");
        print("Proceeding to meeting with token $token");

        return TimuApiProvider(
            api: api,
            child: WebsocketProvider(
                nounUrl: widget.nounUrl,
                channel: 'lobby',
                child: _NotificationPopup(child: widget.granted(context))));
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

  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    _loadSound();
  }

  Uint8List? _audioBytes;

  Future<void> _loadSound() async {
    String audioasset = "lib/assets/ding-36029.mp3"; //path to asset
    ByteData bytes = await rootBundle.load(audioasset); //load sound from assets
    Uint8List soundbytes =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    // TODO: load it into a byte array from asset bundle: https://www.fluttercampus.com/guide/222/read-files-from-assets-folder/ then use playBytes.
    //_audioBytes =
  }

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
                                if (_audioBytes != null) {
                                  player.playBytes(_audioBytes!);
                                }
                              }, key: ValueKey(client.id)))
                          .superJoin(const SizedBox(height: 10))
                          .toList(growable: false))));
        })
      ]),
    ]);
  }
}

class _ClientWidget extends StatelessWidget {
  const _ClientWidget(this.client, this.onDismiss, {super.key});

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
        onPressed: onDismiss,
      ),
    );
  }
}

Widget wrap(Widget child) {
  return ColoredBox(
      color: const Color(0XFF2F2D57),
      child: Center(child: SizedBox(width: 400, child: child)));
}
