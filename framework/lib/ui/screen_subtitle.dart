import 'package:flutter/material.dart';

class ScreenSubtitle extends StatelessWidget {
  final String text;

  const ScreenSubtitle({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Color.fromRGBO(171, 148, 255, 1),
        fontSize: 16,
        fontFamily: "Roboto",
        height: 1,
        letterSpacing: 0,
      ),
    );
  }
}
