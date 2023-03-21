import 'package:flutter/material.dart';
import 'text.dart';

class UserMeetingAccessDenied extends StatelessWidget {
  const UserMeetingAccessDenied({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0XFF2F2D57),
      child: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 400,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ScreenTitle(
                      text: 'Your meeting access has been denied',
                      textAlign: TextAlign.center),
                  SizedBox(height: 16),
                  ScreenSubtitle(
                      text: 'Please contact the meeting owner and try again',
                      textAlign: TextAlign.center),
                ]),
          ),
        ),
      ),
    );
  }
}
