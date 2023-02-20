import 'package:flutter/material.dart';

class ScreenText extends StatelessWidget {
  const ScreenText({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color.fromRGBO(171, 148, 255, 1),
        fontSize: 11,
        fontFamily: 'Roboto',
        height: 1.91,
        letterSpacing: 0,
        decoration: TextDecoration.none,
      ),
    );
  }
}
