import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/account.dart';
import 'account_item.dart';
import 'auth_model.dart';
import 'primary_button.dart';
import 'text.dart';

class AccountList extends StatelessWidget {
  const AccountList({
    super.key,
    this.onAccountPressed,
  });
  final void Function(Account account)? onAccountPressed;

  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://app.timu.com/add-account');
    if (!await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthModel props = AuthModel.of(context);
    final List<Account> accounts = props.accounts;

    return Column(children: <Widget>[
      const SizedBox(height: 100),
      const ScreenTitle(text: 'Select an account'),
      const SizedBox(height: 15),
      // const ScreenSubtitle(text: 'Use the TIMU app to add an account'),
      const ScreenSubtitle(text: 'To continue'),
      const SizedBox(height: 20),
      Expanded(
          child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: accounts.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == accounts.length) {
                      return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                          child: Container(
                              alignment: AlignmentDirectional.center,
                              child: PrimaryButton(
                                text: 'Add account',
                                onPressed: _launchURL,
                              )));
                    }

                    final Account account = accounts[index];
                    return AccountItem(
                      account: account,
                      onPressed: onAccountPressed,
                      // leading: activeAccount == account ? const Icon(Icons.check) : null,
                    );
                  }))),
    ]);
  }
}
