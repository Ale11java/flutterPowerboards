import 'package:appcheck/appcheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../ui.dart';
import 'primary_button.dart';

class AccountsEmpty extends StatefulWidget {
  const AccountsEmpty({
    super.key,
  });

  @override
  AccountsEmptyState createState() => AccountsEmptyState();
}

class AccountsEmptyState extends State<AccountsEmpty> {
  bool? hasApp = false;

  @override
  void initState() {
    super.initState();

    _hasApp();
  }

  // Future<void> _launchURL() async {
  //   final Uri url = Uri.parse(hasApp ?? false
  //       ? 'https://app.timu.com/add-account?redirect_uri=timutest://home'
  //       : 'https://play.google.com/store/apps/details?id=com.timu');
  //   if (!await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication)) {
  //     throw Exception('Could not launch $url');
  //   }
  // }

  Future<void> _hasApp() async {
    const package = 'com.timu';

    try {
      await AppCheck.checkAvailability(package).then((app) {
        setState(() {
          hasApp = true;
        });
      });
    } on PlatformException {
      //app not installed
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = hasApp ?? false ? 'Open TIMU app' : 'Install TIMU app';
    return Column(children: <Widget>[
      const SizedBox(height: 100),
      const ScreenTitle(text: 'Sign into the TIMU app'),
      const SizedBox(height: 15),
      const ScreenSubtitle(text: 'To continue'),
      const SizedBox(height: 40),
      PrimaryButton(
        text: text,
        // onPressed: _launchURL,
        onPressed: () => context.push('/login-email'),
      )
    ]);
  }
}
