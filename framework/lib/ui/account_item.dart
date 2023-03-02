import 'package:flutter/material.dart';

import '../../ui.dart';
import '../model/account.dart';

class AccountItem extends StatelessWidget {
  const AccountItem({
    super.key,
    required this.account,
    required this.onPressed,
  });
  final Account account;
  final void Function(Account account)? onPressed;

  @override
  Widget build(BuildContext context) {
    String imageName = 'lib/assets/app-timu.png';
    if (account.provider == 'google') {
      imageName = 'lib/assets/app-google.png';
    } else if (account.provider == 'microsoft') {
      imageName = 'lib/assets/app-office-365.png';
    }

    final bool isSignedOut = account.accessToken == null;

    return ElevatedButton(
        onPressed: isSignedOut || onPressed == null
            ? null
            : () => {onPressed!(account)},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          elevation: 0,
          padding: const EdgeInsets.all(15),
        ),
        child: Opacity(
            opacity: isSignedOut ? .3 : 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: Image.asset(
                    imageName,
                    width: 18,
                    height: 18,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        account.email,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ScreenText(
                            text: isSignedOut ? 'Signed out' : 'Signed in'),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
