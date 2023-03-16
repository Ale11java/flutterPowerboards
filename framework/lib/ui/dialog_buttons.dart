import 'package:flutter/material.dart';

class ButtonSize extends InheritedWidget {
  const ButtonSize({
    super.key,
    required this.size,
    required super.child,
  });

  final Size size;

  static ButtonSize? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ButtonSize>();
  }

  static ButtonSize of(BuildContext context) {
    final ButtonSize? size = maybeOf(context);

    assert(size != null, 'there is no ButtonSize above in the tree');

    return size!;
  }

  @override
  bool updateShouldNotify(ButtonSize oldWidget) {
    return size != oldWidget.size;
  }
}

class DialogButton extends StatelessWidget {
  const DialogButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.bgColor,
    this.textColor,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Widget child;
  final Color? bgColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final Size size = ButtonSize.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Expanded(
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: size,
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            backgroundColor: bgColor,
            textStyle: TextStyle(
              color: Colors.white, // set this to a default value
            ),
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              color: textColor,
            ),
            child: child,
          ),
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
    required Color textColor,
  }) : super(key: key, onPressed: onPressed, child: child, bgColor: bgColor);

  // @override
  // Widget build(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //     child: Expanded(
  //       child: TextButton(
  //         onPressed: onPressed,
  //         style: TextButton.styleFrom(
  //           padding: const EdgeInsets.all(16.0),
  //           alignment: Alignment.center,
  //           backgroundColor: bgColor,
  //           side: const BorderSide(width: 3, color: Color(0XFF7651fb)),
  //           textStyle: const TextStyle(color: Colors.white),
  //         ),
  //         child: child,
  //       ),
  //     ),
  //   );
  // }
}

class OkDialogButton extends DialogButton {
  const OkDialogButton({
    Key? key,
    required VoidCallback onPressed,
    required Widget child,
    Color? bgColor,
    required Color textColor,
  }) : super(key: key, onPressed: onPressed, child: child, bgColor: bgColor);
}

class EmphasizedDialogButton extends DialogButton {
  const EmphasizedDialogButton({
    super.key,
    required VoidCallback onPressed,
    required super.child,
    Color? bgColor,
    required Color textColor,
  }) : super(onPressed: onPressed, bgColor: bgColor);
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

class MaxTextWidthButtonSize extends ButtonSize {
  const MaxTextWidthButtonSize({
    super.key,
    required super.size,
    required this.text,
    required super.child,
  });
  //width: _calculateWidth(200.0, text),
  final String text;

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
