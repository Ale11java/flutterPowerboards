import 'package:flutter/material.dart';

import '../ui/floating_panel.dart';

class FloatingPanelExample extends StatelessWidget {
  const FloatingPanelExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
        width: 400,
        height: 400,
        child: FloatingPanelWidget(
            child: FloatingPanelScaffold(title: 'Contents', children: [
          Text("test"),
          Text("test"),
          Text("test"),
          Text("test")
        ])));
  }
}
