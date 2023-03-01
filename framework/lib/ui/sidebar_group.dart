import 'package:flutter/material.dart';

class SidebarGroupButton extends StatelessWidget {
  final AssetImage icon;
  final String text;
  final Color iconColor;

  const SidebarGroupButton(
      {required this.icon, required this.text, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image(image: icon, color: iconColor),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Text(text),
        ),
      ],
    );
  }
}

class SidebarGroup extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> children;
  final double verticalSpacing;

  const SidebarGroup({
    required this.title,
    required this.children,
    this.verticalSpacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(title),
        ),
        Column(
          children: [
            for (final child in children)
              Column(
                children: [
                  SidebarGroupButton(
                    icon: AssetImage(child['iconPath']),
                    text: child['title'],
                    iconColor: child['iconColor'],
                  ),
                  if (children.last != child) SizedBox(height: verticalSpacing),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class SidebarScreen extends StatelessWidget {
  final List<Map<String, dynamic>> sections;

  const SidebarScreen({required this.sections});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          children: [
            SidebarGroup(
              title: "Sections",
              children: [
                for (final section in sections)
                  {
                    'iconPath': AssetImage(section['iconPath']),
                    'title': section['title'],
                    'iconColor': section['iconColor'],
                  },
              ],
            ),
          ],
        ),
      ),
    );
  }
}
