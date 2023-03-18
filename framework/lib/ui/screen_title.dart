part of 'text.dart';

class ScreenTitle extends StatelessWidget {
  const ScreenTitle({
    super.key,
    required this.text,
    this.textAlign = TextAlign.left,
  });

  final String text;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.inter(
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 21,
          fontWeight: FontWeight.w800,
          height: 1.33,
          letterSpacing: 0,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
