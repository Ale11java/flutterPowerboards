import 'header_tab.dart';
import 'package:flutter/material.dart';

abstract class EditorTab {
  const EditorTab({required this.tab});

  final HeaderTab tab;

  Widget build(BuildContext context);
}
