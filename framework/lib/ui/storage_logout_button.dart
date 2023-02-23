import 'package:flutter/material.dart';

import '../model/storage.dart';
import 'auth_model.dart';
import 'primary_button.dart';

class StorageLogoutButton extends StatelessWidget {
  const StorageLogoutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Storage storage = AuthModel.storageOf(context);

    return PrimaryButton(
      text: 'Logout',
      onPressed: () {
        storage.setActiveAccount(null);
      },
    );
  }
}
