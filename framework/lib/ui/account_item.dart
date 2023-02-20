import 'package:flutter/material.dart';

import '../../ui.dart';
import '../model/account.dart';

class AccountItem extends StatelessWidget {
  const AccountItem({
    super.key,
    required this.account,
  });
  final Account account;

  @override
  Widget build(BuildContext context) {
    String imageName = 'lib/assets/app-timu.png';
    if (account.provider == 'google') {
      imageName = 'lib/assets/app-google.png';
    } else if (account.provider == 'microsoft') {
      imageName = 'lib/assets/app-office-365.png';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            child: Image.asset(
              imageName,
              width: 46, // change this to the desired width of the image
              height: 46, // change this to the desired height of the image
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            // flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ScreenTitle(text: account.email),
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
    );
  }
}

class SummaryButtonTitleText extends StatelessWidget {
  const SummaryButtonTitleText({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}

class SummaryButtonBodyText extends StatelessWidget {
  const SummaryButtonBodyText({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class SummaryGraphic extends StatelessWidget {
  const SummaryGraphic({
    super.key,
    required this.graphic,
  });
  final Widget graphic;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
    );
  }
}
