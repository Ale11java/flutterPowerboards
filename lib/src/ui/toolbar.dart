import 'package:flutter/material.dart';

enum ToolbarDirection { horizontal, vertical }

/// Toolbar widget is the base widget to use for toolbars.
///
/// The toolbar can be either horizontal or vertical. The toolbar widget should
/// only render the box, the padding between the items, and the padding between
/// the items and the box. The content of the toolbar (such as any buttons)
/// should be a list of Widgets. It should constrain the height or width of the
/// contents of the toolbar depending on the orientation (width if it is
/// vertical and height if it is horizontal).
class Toolbar extends InheritedWidget {
  Toolbar({
    super.key,
    required this.direction,
    required List<Widget> children,
  }) : super(child: _ToolbarContents(children));

  final ToolbarDirection direction;

  @override
  bool updateShouldNotify(covariant Toolbar oldWidget) {
    return oldWidget.direction != oldWidget.direction;
  }
}

class _ToolbarContents extends StatelessWidget {
  const _ToolbarContents(this.children);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final toolbar = context.dependOnInheritedWidgetOfExactType<Toolbar>()!;

    if (toolbar.direction == ToolbarDirection.horizontal) {
      return Container(
        height: 56.0, // in logical pixels
        padding: const EdgeInsets.all(8.0),
        color: Color.fromRGBO(78, 74, 144, 1),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4.0))),
        child: Row(children: this.children),
      );
    } else {
      return Container(
        width: 56.0, // in logical pixels
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(color: Color.fromRGBO(78, 74, 144, 1)),
        child: Column(children: this.children),
      );
    }
  }
}

/// Occasionally, we will need to render separators between the widgets, these can be rendered using a ToolbarSeparator widget. The widget should not contain any padding, but should respect the the current toolbar orientation to know whether it should render according to the height or width constraint. Use a LayoutBuilder to retrieve this constraint.
///
/// ToolbarSeparator() : StatelessWidget
///
/// There are three types of standard buttons.
///
/// ToolbarButton(onPressed : Function(), child: Widget) : StatelessWidget
/// ToggleToolbarButton(on: bool, child: Widget) : ToolbarButton
/// EmphasizedToolbarButton( child: Widget) : ToolbarButton
///
/// Like the ToolbarSeparator, the ToolbarButton should also respect the horizontal or vertical constraint provided by the toolbar depending on the orientation. The major difference between the buttons is simply the background color and hover states of the buttons. The content of the button should be provided as a widget child, which could be an icon, text, or another type of widget. The button should center its contents and have a minimum width that matches the constrained dimension of the button so that buttons with a single icon or character glyph are square.
