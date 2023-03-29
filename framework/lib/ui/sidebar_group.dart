import 'package:flutter/material.dart';
import '../timu_icons/timu_icons.dart';
import 'dialog_buttons.dart';

class SidebarGroup extends StatelessWidget {
  final String title;
  final List<SidebarGroupButton> createChildren;
  final List<SidebarGroupButton> viewChildren;
  final List<SidebarGroupButton> presentChildren;
  final List<SidebarGroupButton> shareChildren;

  const SidebarGroup({
    required this.title,
    required this.createChildren,
    required this.viewChildren,
    required this.presentChildren,
    required this.shareChildren,
    required List children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 50, 10, 30),
      child: Container(
        color: Color(0XFF23253C),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              _buildSection('CREATE', createChildren),
              _buildSection('VIEW', viewChildren),
              _buildSection('PRESENT', presentChildren),
              _buildSection('SHARE', shareChildren),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0XFFed6464),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: SizedBox(
                        width: 200,
                        height: 40,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'End & Leave',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<SidebarGroupButton> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
                height: 3,
                fontSize: 12,
                color: Color(0XFF9b80ff)),
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
  final IconData icon;
  final String text;

  const SidebarGroupButton({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Color(0xFF9b80ff)),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
