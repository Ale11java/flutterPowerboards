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

    return GestureDetector(
        onTap: () => {
              if (onPressed != null) {onPressed!(account)}
            },
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                  width: 18, // change this to the desired width of the image
                  height: 18, // change this to the desired height of the image
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                // flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // ScreenTitle(text: account.email),
                    Text(
                      account.email,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w800,
                        // letterSpacing: 0,
                        // decoration: TextDecoration.none,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ScreenText(
                          text: account.accessToken == null
                              ? 'Signed out'
                              : 'Signed in'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
