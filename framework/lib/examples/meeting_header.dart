import 'package:flutter/material.dart';

import '../ui/meeting_header.dart';
import '../timu_icons/timu_icons.dart';

class MeetingHeaderExample extends StatelessWidget {
  const MeetingHeaderExample({super.key});
  @override
  Widget build(BuildContext context) {
    return MeetingHeader(
        title: 'This is a Meeting',
        start: DateTime.now(),
        buttons: <Widget>[
          MeetingHeaderButton(text: 'Text', icon: TimuIcons.layer_text),
          MeetingHeaderButton(on: true, text: 'Tools', icon: TimuIcons.tools)
        ]);
  }
}
