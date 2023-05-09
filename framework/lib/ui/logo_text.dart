import 'package:flutter/material.dart';

class LogoText extends StatelessWidget {
  const LogoText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'TIMU ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              fontFamily: 'Roboto',
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          TextSpan(
            text: 'Powerboards',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              // fontWeight: FontWeight.w500,
              fontFamily: 'Roboto',
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ],
      ),
    );
  }
}
