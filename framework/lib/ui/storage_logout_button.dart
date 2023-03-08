import 'package:flutter/material.dart';

import 'auth_storage_state.dart';
import 'primary_button.dart';

class StorageLogoutButton extends StatelessWidget {
  const StorageLogoutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: 'Logout',
      onPressed: () {
        context
            .findAncestorStateOfType<AuthStorageState>()!
            .setActiveAccount(null);
      },
    );
  }
}
