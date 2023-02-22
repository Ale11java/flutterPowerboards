import 'package:flutter/material.dart';

class ScreenSubtitle extends StatelessWidget {
  const ScreenSubtitle({
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
        fontSize: 16,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w700,
        height: 1,
        letterSpacing: 0,
        decoration: TextDecoration.none,
      ),
    );
  }
}
