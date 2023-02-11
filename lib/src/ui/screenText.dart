import 'package:flutter/material.dart';

class ScreenText extends StatelessWidget {
  final String text;

  const ScreenText({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Color.fromRGBO(171, 148, 255, 1),
        fontSize: 11,
        fontFamily: "Roboto",
        height: 1.91,
        letterSpacing: 0,
      ),
      textAlign: TextAlign.center,
    );
  }
}
