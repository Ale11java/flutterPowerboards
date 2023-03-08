import 'package:flutter/material.dart';

class SidebarGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SidebarGroup({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        Column(
          children: children,
        ),
      ],
    );
  }
}

class SidebarGroupButton extends StatelessWidget {
  final AssetImage icon;
  final String text;

  const SidebarGroupButton({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ImageIcon(icon, size: 20, color: Color(0xFF9b80ff)),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9b80ff)),
          ),
        ],
      ),
    );
  }
}
