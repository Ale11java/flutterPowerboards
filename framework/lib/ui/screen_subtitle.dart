part of 'text.dart';

/// Default screen subtitle.
///
///
/// ```run-dartpad:theme-dark:mode-flutter:run-true:split-40:width-100%:height-800px
/// import 'package:flutter/material.dart';
/// import 'package:timu_dart/ui.dart';
///
/// void main() => runApp(const MyApp());
///
/// class MyApp extends StatelessWidget {
///   const MyApp({super.key});
///
///   static const String _title = 'ScreenText Sample';
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       title: _title,
///       home: Scaffold(
///         body: const MyStatelessWidget(),
///       ),
///     );
///   }
/// }
///
/// class MyStatelessWidget extends StatelessWidget {
///   const MyStatelessWidget({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return Container(
///       padding: const EdgeInsets.all(20.0),
///       child: ScreenSubtitle(
///         text: 'Here we have general default screen subtitle.',
///       ),
///     );
///   }
/// }
/// ```
class ScreenSubtitle extends StatelessWidget {
  const ScreenSubtitle({
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
