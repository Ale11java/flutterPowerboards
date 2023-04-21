import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _meetingHeaderButtonOnColor = Color.fromARGB(0xff, 0x77, 0x52, 0xFF);
const _meetingHeaderButtonColor = Color.fromARGB(0xff, 0x4A, 0x46, 0x98);
const _meetingHeaderAltColor = Color.fromARGB(0xff, 0x60, 0x73, 0x8B);
const _meetingHeaderTitleColor = Color.fromARGB(0xff, 0x2F, 0x2D, 0x57);
const _meetingHeaderBorderColor = const Color(0xffcccccc);

final meetingHeaderFont = GoogleFonts.robotoFlex(
    textStyle: const TextStyle(
        height: 1,
        color: _meetingHeaderTitleColor,
        fontSize: 16,
        fontWeight: FontWeight.w800));
final _meetingHeaderClockFont = GoogleFonts.robotoFlex(
    textStyle: const TextStyle(
        height: 0,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: _meetingHeaderAltColor));

class MeetingHeader extends StatelessWidget {
  const MeetingHeader({
    required this.title,
    required this.start,
    super.key,
    required this.leftButtons,
    required this.rightButtons,
  });

  final Widget title;
  final DateTime start;
  final List<Widget> leftButtons;
  final List<Widget> rightButtons;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: 40,
        decoration: const BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(color: _meetingHeaderBorderColor))),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
            child: Stack(children: [
              Row(
                children: <Widget>[
                  Expanded(
                      child:
                          IntrinsicHeight(child: Row(children: leftButtons))),
                  IntrinsicHeight(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                        MeetingHeaderClock(start: start),
                        ...rightButtons
                      ])),
                ],
              ),
              Align(
                  child: IntrinsicWidth(child: title),
                  alignment: Alignment.center),
            ])));
  }
}

class ToolIcon extends StatelessWidget {
  const ToolIcon(this.icon, {super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: _toolIconColor, size: 28);
  }
}

const _toolIconColor = Color.fromARGB(0xff, 0x4A, 0x46, 0x98);

class MeetingHeaderButton extends StatelessWidget {
  MeetingHeaderButton(
      {required this.text,
      required this.icon,
      required this.onPressed,
      super.key,
      this.on = false});

  final void Function() onPressed;
  final String text;
  final IconData icon;

  final bool on;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
            onTap: onPressed,
            child: Tooltip(
                message: text,
                child: SizedBox(
                    width: 42,
                    height: 42,
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: on
                                ? _meetingHeaderButtonOnColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5)),
                        child: ToolIcon(icon))))));
  }
}

class MeetingHeaderClock extends StatefulWidget {
  const MeetingHeaderClock({required this.start, super.key});

  final DateTime start;

  @override
  State<StatefulWidget> createState() => _MeetingHeaderClockState();
}

class _MeetingHeaderClockState extends State<MeetingHeaderClock> {
  late Timer timer;
  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
        DateTime.now().difference(widget.start).toString().split('.').first,
        style: _meetingHeaderClockFont);
  }
}

class MeetingHeaderTitle extends StatelessWidget {
  const MeetingHeaderTitle(
      {required this.text, required this.start, super.key});

  final Widget text;
  final DateTime start;

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(child: text),
          SizedBox(width: 10),
          MeetingHeaderClock(start: start)
        ]);
  }
}
