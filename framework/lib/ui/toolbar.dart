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
///
/// ```run-dartpad:theme-dark:mode-flutter:run-true:split-40:width-100%:height-800px
/// import 'package:flutter/material.dart';
///
/// enum ToolbarDirection { horizontal, vertical }
///
/// class Toolbar extends InheritedWidget {
///   Toolbar({
///     super.key,
///     required this.direction,
///     required List<Widget> children,
///   }) : super(child: _ToolbarContents(children));
/// 
///   final ToolbarDirection direction;
/// 
///   @override
///   bool updateShouldNotify(covariant Toolbar oldWidget) {
///     return oldWidget.direction != oldWidget.direction;
///   }
/// }
/// 
/// class _ToolbarContents extends StatelessWidget {
///   const _ToolbarContents(this.children);
/// 
///   final List<Widget> children;
/// 
///   @override
///   Widget build(BuildContext context) {
///     final Toolbar toolbar = context.dependOnInheritedWidgetOfExactType<Toolbar>()!;
/// 
///     if (toolbar.direction == ToolbarDirection.horizontal) {
///       return Container(
///         height: 56.0, // in logical pixels
///         padding: const EdgeInsets.all(8.0),
///         decoration: BoxDecoration(
///           borderRadius: BorderRadius.circular(8),
///           border: Border.all(color: const Color(0xff4e4a90)),
///           boxShadow: const <BoxShadow>[
///             BoxShadow(
///               color: Color(0x19000000),
///               blurRadius: 10,
///               offset: Offset(0, 6),
///             ),
///           ],
///           color: const Color(0xff2f2d57),
///         ),
///         child: Row(children: children),
///       );
///     } else {
///       return Container(
///         width: 56.0, // in logical pixels
///         padding: const EdgeInsets.all(8.0),
///         decoration: BoxDecoration(
///           borderRadius: BorderRadius.circular(8),
///           border: Border.all(color: const Color(0xff4e4a90)),
///           boxShadow: const <BoxShadow>[
///             BoxShadow(
///               color: Color(0x19000000),
///               blurRadius: 10,
///               offset: Offset(0, 6),
///             ),
///           ],
///           color: const Color(0xff2f2d57),
///         ),
///         child: Column(children: children),
///       );
///     }
///   }
/// }
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

class _ToolbarContents extends StatelessWidget {
  const _ToolbarContents(this.children);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final Toolbar toolbar = context.dependOnInheritedWidgetOfExactType<Toolbar>()!;

    if (toolbar.direction == ToolbarDirection.horizontal) {
      return Container(
        height: 56.0, // in logical pixels
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xff4e4a90)),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
          color: const Color(0xff2f2d57),
        ),
        child: Row(children: children),
      );
    } else {
      return Container(
        width: 56.0, // in logical pixels
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xff4e4a90)),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
          color: const Color(0xff2f2d57),
        ),
        child: Column(children: children),
      );
    }
  }
}
