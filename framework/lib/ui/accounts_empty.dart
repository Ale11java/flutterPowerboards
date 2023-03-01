import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../ui.dart';
import 'primary_button.dart';

class AccountsEmpty extends StatelessWidget {
  const AccountsEmpty({
    super.key,
  });

  Future<void> _launchURL() async {
    final Uri url = Uri.parse(
        'https://app.timu.com/add-account?redirect_uri=timutest://home');
    if (!await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      const SizedBox(height: 100),
      const ScreenTitle(text: 'Sign into the TIMU app'),
      const SizedBox(height: 15),
      const ScreenSubtitle(text: 'To continue'),
      const SizedBox(height: 40),
      PrimaryButton(
        text: 'Open TIMU app',
        onPressed: _launchURL,
      )
    ]);
  }
}
