import 'package:flutter/material.dart';
import 'text.dart';

class InAppPage extends StatelessWidget {
  const InAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0XFF2F2D57),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ScreenTitle(text: 'In App.'),
                SizedBox(height: 16),
                ScreenSubtitle(text: 'Daily design meetup'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
