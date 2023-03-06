import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _floatingPanelBackground = Color.fromARGB(0xff, 0x2F, 0x2D, 0x57);

final _floatingPanelTitleFont = GoogleFonts.inter(
    textStyle: const TextStyle(
        fontSize: 18, letterSpacing: 0.4, fontWeight: FontWeight.w800));

class FloatingPanelWidget extends StatelessWidget {
  const FloatingPanelWidget({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 2),
                  blurRadius: 20,
                  color: Color.fromARGB((255 * 0.228148).toInt(), 0, 0, 0))
            ],
            color: _floatingPanelBackground,
            borderRadius: BorderRadius.circular(20)),
        child: DefaultTextStyle(
            style: const TextStyle(color: Colors.white), child: child));
  }
}

class FloatingPanelScaffold extends StatelessWidget {
  const FloatingPanelScaffold(
      {this.title = '', this.onClose, super.key, required this.children});

  final String title;
  final void Function()? onClose;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(38),
        child: Align(
            alignment: Alignment.topCenter,
            child: Column(children: [
              Text(title, style: _floatingPanelTitleFont),
              Expanded(child: ListView(children: children))
            ])));
  }
}
