import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });
  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        // disabledBackgroundColor: Colors.transparent,
        // shadowColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(56)),
        elevation: 0,
        padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
      ),
      child: Text(
        text.toUpperCase(),
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
            textStyle: const TextStyle(
          color: Color.fromRGBO(72, 69, 117, 1),
          fontSize: 13,
          fontWeight: FontWeight.w900,
          decoration: TextDecoration.none,
        )),
      ),
    );
  }
}
