import "package:flutter/material.dart";

import 'editor_tab.dart';

// Renders a view similar to the powerboards app on web. Under the header,
//renders a panel with a tab for each of the leftTabs on the left, and a panel
//with each of the rightTabs on the right.
// the child widget should expand to fit the space between the panels.
//Selecting a new tab should render its contents in the associated panel.
class DesktopEditorScaffold extends StatefulWidget {
  const DesktopEditorScaffold(
      {required this.header,
      required this.child,
      required this.leftTabs,
      required this.rightTabs,
      super.key});

  final Widget header;
  final Widget child;
  final List<EditorTab> leftTabs;
  final List<EditorTab> rightTabs;

  @override
  State<StatefulWidget> createState() => _DesktopEditorScaffoldState();
}

class _DesktopEditorScaffoldState extends State<DesktopEditorScaffold> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// Renders all the tabs as a tabstrip on the bottom of the page.
//The header should be rendered on the top of the screen.
//The child should fill the space between the header and bottom tab bar.
//Selecting a tab should display its contents in a slidable panel that can be dragged up and down. The child
class MobileEditorScaffold extends StatefulWidget {
  const MobileEditorScaffold(
      {required this.header,
      required this.child,
      required this.tabs,
      super.key});

  final Widget header;
  final Widget child;
  final List<EditorTab> tabs;

  @override
  State<StatefulWidget> createState() => _MobileEditorScaffoldState();
}

class _MobileEditorScaffoldState extends State<MobileEditorScaffold> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class EditorScaffold extends StatelessWidget {
  const EditorScaffold(
      {required this.header,
      required this.child,
      required this.leftTabs,
      required this.rightTabs,
      super.key});

  final Widget header;
  final Widget child;
  final List<EditorTab> leftTabs;
  final List<EditorTab> rightTabs;

  @override
  Widget build(BuildContext context) {
    // render MobileEditorScaffold if on a phone, otherwise render DesktopEditorScaffold
    throw UnimplementedError();
  }
}
