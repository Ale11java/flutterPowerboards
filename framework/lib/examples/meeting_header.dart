import 'package:flutter/material.dart';

import '../ui/header_tab.dart';
import '../ui/meeting_header.dart';
import '../timu_icons/timu_icons.dart';

class MeetingHeaderExample extends StatefulWidget {
  const MeetingHeaderExample({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MeetingHeaderExampleState();
  }
}

class _MeetingHeaderExampleState extends State<MeetingHeaderExample>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return MeetingHeader(
        tabController: TabController(vsync: this, length: 1),
        tabs: [HeaderTab(semanticLabel: "test", icon: TimuIcons.tool_code)],
        title: 'This is a Meeting',
        start: DateTime.now(),
        buttons: <Widget>[
          MeetingHeaderButton(text: 'Text', icon: TimuIcons.layer_text),
          MeetingHeaderButton(on: true, text: 'Tools', icon: TimuIcons.tools)
        ]);
  }
}
