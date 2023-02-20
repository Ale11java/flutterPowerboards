import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
        // padding: const EdgeInsets.all(16),
        padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(56),
          color: Colors.white,
        ),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            color: Color.fromRGBO(72, 69, 117, 1),
            fontSize: 13,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w900,
            decoration: TextDecoration.none,
          ),
        ));
  }
}
