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
}

class RequireAccess extends StatefulWidget {
  const RequireAccess({super.key, required this.nounUrl, required this.widget});

  final String nounUrl;
  final Widget widget;

  @override
  State<RequireAccess> createState() => _RequireAccessState();
}

class _RequireAccessState extends State<RequireAccess> {
  Progress progress = Progress.init;

  Future<void> onRegisterUser(String firstName, String lastName) async {
    final api = TimuApiProvider.of(super.context).api;

    print('jkkk onRegister, $firstName $lastName');

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

    progress = Progress.waitingForApproval;
  }

  Future<void> checkAccess() async {
    final Account? activeAccount = AuthModel.of(context).activeAccount;

    if (activeAccount != null) {
      final api = TimuApiProvider.of(super.context).api;

      try {
        await api.invoke(
            name: 'demand-role',
            nounPath: widget.nounUrl,
            public: true,
            body: {'role': 'core:contributor'});
        progress = Progress.hasAccess;
      } on AccessDeniedError {
        progress = Progress.needsAccess;
      }
    } else {
      progress = Progress.needsAccess;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (progress == Progress.init) {
      checkAccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (progress) {
      case Progress.lggedIn:
        return widget.widget;

      case Progress.needsAccess:
        return GuestEntryPage(onRegisterUser);

      case Progress.waitingForApproval:
        return WebsocketProvider(
          nounUrl: widget.nounUrl,
          channel: 'lobby',
          child: const LobbyWaitPage(),
        );

      case Progress.init:
        return const Center(
            child: SizedBox(
                width: 50, height: 50, child: CircularProgressIndicator()));

      case Progress.hasAccess:
        return widget.widget;
    }
  }
}
