import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? bgColor;

  const DialogButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Expanded(
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            backgroundColor: bgColor,
          ),
          child: child,
        ),
      ),
    );
  }
}

class CancelDialogButton extends DialogButton {
  const CancelDialogButton({
    Key? key,
    required VoidCallback onPressed,
    required Widget child,
    Color? bgColor,
  }) : super(key: key, onPressed: onPressed, child: child, bgColor: bgColor);
}

class OkDialogButton extends DialogButton {
  const OkDialogButton({
    Key? key,
    required VoidCallback onPressed,
    required Widget child,
    Color? bgColor,
  }) : super(key: key, onPressed: onPressed, child: child, bgColor: bgColor);
}

class EmphasizedDialogButton extends DialogButton {
  const EmphasizedDialogButton({
    Key? key,
    required VoidCallback onPressed,
    required Widget child,
    Color? bgColor,
  }) : super(key: key, onPressed: onPressed, child: child, bgColor: bgColor);
}

class DialogButtonText extends StatelessWidget {
  final String text;

  const DialogButtonText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.button,
    );
  }
}

class ButtonSize extends InheritedWidget {
  final double width;
  final List<Widget> children;

  ButtonSize({
    Key? key,
    required this.width,
    required this.children,
  }) : super(
          key: key,
          child: SizedBox(width: width, child: Row(children: children)),
        );

  static ButtonSize? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ButtonSize>();
  }

  @override
  bool updateShouldNotify(ButtonSize oldWidget) {
    return width != oldWidget.width || children != oldWidget.children;
  }
}

class MaxTextWidthButtonSize extends ButtonSize {
  final double minWidth;
  final List<Text> text;

  MaxTextWidthButtonSize({
    Key? key,
    required this.minWidth,
    required this.text,
    required List<Widget> children,
  }) : super(
          key: key,
          width: _calculateWidth(minWidth, text),
          children: children,
        );

  static double _calculateWidth(double minWidth, List<Text> text) {
    final maxTextWidth = text.fold<double>(0.0, (maxWidth, text) {
      final textPainter = TextPainter(
        text: TextSpan(text: text.data, style: text.style),
        textDirection: TextDirection.ltr,
      )..layout();
      return maxWidth > textPainter.width ? maxWidth : textPainter.width;
    });
    return maxTextWidth + 32.0 > minWidth ? maxTextWidth + 32.0 : minWidth;
  }
}
