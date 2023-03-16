import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../timu_icons/timu_icons.dart';

const _floatingPanelBackground = Color.fromARGB(0xff, 0xff, 0xff, 0xff);
const _closeIconColor = Color.fromARGB(0xff, 0x92, 0xA1, 0xB5);
final _floatingPanelTitleFont = GoogleFonts.inter(
    textStyle: const TextStyle(
        fontSize: 18, letterSpacing: 0.4, fontWeight: FontWeight.w800));

class FloatingPanelWidget extends StatelessWidget {
  const FloatingPanelWidget({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 400,
        height: 400,
        child: DecoratedBox(
            decoration: BoxDecoration(
                border: Border.all(
                    color: const Color(0xffcccccc),
                    strokeAlign: BorderSide.strokeAlignOutside),
                color: _floatingPanelBackground,
                borderRadius: BorderRadius.circular(0)),
            child: DefaultTextStyle(
                style: const TextStyle(color: Colors.black), child: child)));
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
        padding: const EdgeInsets.all(8),
        child: Align(
            alignment: Alignment.topCenter,
            child: Column(children: [
              Row(children: [
                IconButton(
                    style: const ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    onPressed: onClose,
                    icon: const Icon(TimuIcons.close,
                        color: _closeIconColor, size: 20)),
                Expanded(
                    child: Text(title,
                        textAlign: TextAlign.center,
                        style: _floatingPanelTitleFont)),
                const SizedBox(width: 20)
              ]),
              Expanded(child: ListView(children: children))
            ])));
  }
}
