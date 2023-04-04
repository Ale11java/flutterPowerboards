import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _meetingHeaderButtonOnColor = Color.fromARGB(0xff, 0x77, 0x52, 0xFF);
const _meetingHeaderButtonColor = Color.fromARGB(0xff, 0x4A, 0x46, 0x98);
const _meetingHeaderAltColor = Color.fromARGB(0xff, 0x60, 0x73, 0x8B);
const _meetingHeaderTitleColor = Color.fromARGB(0xff, 0x2F, 0x2D, 0x57);
const _meetingHeaderBorderColor = const Color(0xffcccccc);

final _meetingHeaderFont = GoogleFonts.robotoFlex(
    textStyle: const TextStyle(
        height: 0,
        color: _meetingHeaderTitleColor,
        fontSize: 21,
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

  final String title;
  final DateTime start;
  final List<Widget> leftButtons;
  final List<Widget> rightButtons;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: 48,
        decoration: const BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(color: _meetingHeaderBorderColor))),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
            child: Row(children: <Widget>[
              Expanded(
                  child: IntrinsicHeight(child: Row(children: leftButtons))),
              Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: IntrinsicWidth(
                          child:
                              MeetingHeaderTitle(start: start, text: title)))),
              Expanded(
                  child: IntrinsicHeight(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: rightButtons))),
            ])));
  }
}

class MeetingHeaderButton extends FilledButton {
  MeetingHeaderButton(
      {required this.text,
      required this.icon,
      super.onPressed,
      super.key,
      this.on = false})
      : super(
            style: FilledButton.styleFrom(
                    elevation: 0,
                    enableFeedback: false,
                    surfaceTintColor: Colors.transparent,
                    splashFactory: NoSplash.splashFactory,
                    padding: EdgeInsets.all(0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white)
                .copyWith(
              overlayColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  return Colors.transparent;
                },
              ),
            ),
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
                        child: Icon(
                          icon,
                          size: 32,
                          color: on ? Colors.white : _meetingHeaderButtonColor,
                        )))));

  final String text;
  final IconData icon;

  final bool on;
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

  final String text;
  final DateTime start;

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(text, style: _meetingHeaderFont),
          SizedBox(width: 10),
          MeetingHeaderClock(start: start)
        ]);
  }
}
