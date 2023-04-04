import 'package:flutter/material.dart';
import '../timu_icons/timu_icons.dart';
import '../ui/header_tab.dart';
import '../ui/header_tab_bar.dart';

class HeaderTabBarExample extends StatefulWidget {
  const HeaderTabBarExample({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HeaderTabBarExampleState();
  }
}

class _HeaderTabBarExampleState extends State<HeaderTabBarExample>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
        color: Colors.grey,
        child: Center(
            child: ColoredBox(
                color: Colors.white,
                child: HeaderTabBar(
                  controller: TabController(length: 3, vsync: this),
                  tabs: [
                    HeaderTab(label: 'Tab 1', icon: TimuIcons.tools),
                    HeaderTab(label: 'Tab 2', icon: TimuIcons.layer_text),
                    HeaderTab(
                        label: 'Tab 3', icon: TimuIcons.layer_camera_grid),
                  ],
                ))));
  }
}
