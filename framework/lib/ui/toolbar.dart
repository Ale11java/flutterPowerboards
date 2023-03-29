import 'package:flutter/material.dart';

enum ToolbarDirection { horizontal, vertical }

const _toolbarBorderColor = const Color(0xffcccccc);

/// Toolbar widget is the base widget to use for toolbars.
///
/// The toolbar can be either horizontal or vertical. The toolbar widget should
/// only render the box, the padding between the items, and the padding between
/// the items and the box. The content of the toolbar (such as any buttons)
/// should be a list of Widgets. It should constrain the height or width of the
/// contents of the toolbar depending on the orientation (width if it is
/// vertical and height if it is horizontal).
///
///
/// ```run-dartpad:theme-dark:mode-flutter:run-true:split-40:width-100%:height-800px
/// import 'package:flutter/material.dart';
/// import 'package:timu_dart/ui.dart';
///
/// void main() => runApp(const MyApp());
///
/// class MyApp extends StatelessWidget {
///   const MyApp({super.key});
///
///   static const String _title = 'Toolbar Sample';
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       title: _title,
///       home: Scaffold(
///         appBar: AppBar(title: const Text(_title)),
///         body: const MyStatelessWidget(),
///       ),
///     );
///   }
/// }
///
/// class MyStatelessWidget extends StatelessWidget {
///   const MyStatelessWidget({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return Container(
///       padding: const EdgeInsets.all(20.0),
///       child: Toolbar(
///         direction: ToolbarDirection.horizontal,
///         children: <Widget>[
///           TextButton(
///             child: const Text('BUY TICKETS', style: TextStyle(
///               color: Color.fromRGBO(255, 255, 255, 1),
///             )),
///             onPressed: () {/* ... */},
///           ),
///           const SizedBox(width: 8),
///           TextButton(
///             child: const Text('LISTEN', style: TextStyle(
///               color: Color.fromRGBO(255, 255, 255, 1),
///             )),
///             onPressed: () {/* ... */},
///           ),
///           const SizedBox(width: 8),
///         ],
///       ),
///     );
///   }
/// }
/// ```

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

List<Widget> _addSpacer(List<Widget> widgets) {
  final List<Widget> ret = [];

  for (final entry in widgets.asMap().entries) {
    final int i = entry.key;

    if (i > 0) {
      ret.add(const SizedBox(width: 8, height: 8));
    }
    ret.add(entry.value);
  }

  return ret;
}

class _ToolbarContents extends StatelessWidget {
  _ToolbarContents(List<Widget> childrens) : children = _addSpacer(childrens);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final Toolbar toolbar =
        context.dependOnInheritedWidgetOfExactType<Toolbar>()!;

    if (toolbar.direction == ToolbarDirection.horizontal) {
      return Container(
        height: 64.0, // in logical pixels
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(
              color: _toolbarBorderColor,
              strokeAlign: BorderSide.strokeAlignOutside),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
          color: const Color(0xffffff),
        ),
        child: Row(children: children),
      );
    } else {
      return Container(
        width: 64.0, // in logical pixels
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(
              color: _toolbarBorderColor,
              strokeAlign: BorderSide.strokeAlignOutside),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
          color: const Color(0xffffffff),
        ),
        child: Column(children: children),
      );
    }
  }
}

/// Occasionally, we will need to render separators between the widgets, these
/// can be rendered using a ToolbarSeparator widget. The widget should not
/// contain any padding, but should respect the the current toolbar orientation
/// to know whether it should render according to the height or width
/// constraint. Use a LayoutBuilder to retrieve this constraint.
class ToolbarSeparator extends StatelessWidget {
  const ToolbarSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.hasBoundedWidth) {
          return const Divider(
            color: Color.fromRGBO(78, 74, 144, 1),
            height: 24,
            thickness: 1,
          );
        } else {
          return const VerticalDivider(
              color: Color.fromRGBO(78, 74, 144, 1), width: 24, thickness: 1);
        }
      },
    );
  }
}

/// the ToolbarButton should also respect the
/// horizontal or vertical constraint provided by the toolbar depending on
/// the orientation.

/// The major difference between the buttons is simply
/// the background color and hover states of the buttons.

/// The content of
/// the button should be provided as a widget child, which could be an
/// icon, text, or another type of widget. The button should center its
/// contents, and have a minimum width that matches the constrained
/// dimension of the button so that buttons with a single icon or character
/// glyph are square.

/// The button should also have the proper amount of
/// internal padding such that if text is added to the button which causes
/// it to grow along the primary axis of the toolbar, the text has equal
/// padding between its top, left, right, and bottom edges.

class ToolbarButton extends StatelessWidget {
  const ToolbarButton({
    this.onPressed,
    this.onLongPress,
    this.child,
    super.key,
  });

  final VoidCallback? onLongPress;
  final VoidCallback? onPressed;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onLongPress: onLongPress,
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
        padding: MaterialStateProperty.all(const EdgeInsets.all(5)),
        minimumSize: MaterialStateProperty.all(const Size.square(32.0)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: child,
    );
  }
}

class ToggleToolbarButton extends ToolbarButton {
  const ToggleToolbarButton({
    this.on = false,
    super.onPressed,
    super.onLongPress,
    super.child,
    super.key,
  });

  final bool on;

  @override
  Widget build(BuildContext context) {
    if (on) {
      return FilledButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        style: FilledButton.styleFrom(
            elevation: 0,
            enableFeedback: false,
            surfaceTintColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            padding: const EdgeInsets.all(5),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            minimumSize: const Size.square(32.0),
            textStyle: const TextStyle(color: Color(0xffffffff)),
            backgroundColor: const Color(0x887752FF)),
        child: child,
      );
    } else {
      return FilledButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        style: FilledButton.styleFrom(
            elevation: 0,
            enableFeedback: false,
            surfaceTintColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            padding: const EdgeInsets.all(5),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            minimumSize: const Size.square(32.0),
            textStyle: const TextStyle(color: Color(0xffffffff)),
            backgroundColor: const Color(0x002f2d57)),
        child: child,
      );
    }
  }
}

class EmphasizedToolbarButton extends ToolbarButton {
  const EmphasizedToolbarButton({
    super.onPressed,
    super.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xFFED6464)),
        textStyle: MaterialStateProperty.all(
            const TextStyle(color: Color(0xffffffff))),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
        padding: MaterialStateProperty.all(const EdgeInsets.all(5)),
        minimumSize: MaterialStateProperty.all(const Size.square(32.0)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: child,
    );
  }
}
