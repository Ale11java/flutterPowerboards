import 'package:flutter/material.dart';

import '../ui/meeting_header.dart';

class MeetingHeaderExample extends StatelessWidget {
  const MeetingHeaderExample({super.key});
  @override
  Widget build(BuildContext context) {
    return MeetingHeader(
        title: 'This is a Meeting',
        start: DateTime.now(),
        buttons: <Widget>[
          MeetingHeaderButton(
              text: 'Test',
              icon: const AssetImage('lib/assets/layer-text.png')),
          MeetingHeaderButton(
              on: true,
              text: 'Test',
              icon: const AssetImage('lib/assets/layer-text.png'))
        ]);
  }
}
