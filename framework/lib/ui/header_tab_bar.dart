import 'package:flutter/material.dart';
import 'header_tab.dart';

class HeaderTabBar extends StatelessWidget {
  const HeaderTabBar({
    super.key,
    required this.tabs,
    required this.controller,
  });

  final List<HeaderTab> tabs;
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      indicatorWeight: 3,
      indicatorColor: const Color(0xFF7752FF),
      labelColor: const Color(0xFF7752FF),
      unselectedLabelColor: const Color(0xFF4A4698),
      tabs: tabs
          .map((tab) => SizedBox(
              width: 28,
              child: Tab(
                icon: Tooltip(
                  message: tab.semanticLabel,
                  child: Icon(
                    tab.icon,
                    size: 16,
                  ),
                ),
                height: 48,
              )))
          .toList(),
    );
  }
}
