part of 'text.dart';

class ScreenTitle extends StatelessWidget {
  const ScreenTitle({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 21,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w800,
        height: 1.33,
        letterSpacing: 0,
        decoration: TextDecoration.none,
      ),
    );
  }
}
