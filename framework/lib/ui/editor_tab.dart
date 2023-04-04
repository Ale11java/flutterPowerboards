import 'package:flutter/material.dart';

abstract class EditorTab {
  const EditorTab({required this.label, required this.icon});

  final String label;
  final IconData icon;

  Widget build(BuildContext context);
}
