import 'package:flutter/material.dart';

class PromptDialog extends SimpleDialog {
  String _input;
  final String placeholder;
  final String? initialValue;
  final String cancelText;
  final String okText;
  final void Function(String value)? onOkPressed;

  PromptDialog({
    required String input,
    required this.placeholder,
    this.initialValue,
    this.cancelText = "CANCEL",
    this.okText = "DONE",
    this.onOkPressed,
  })  : _input = input,
        super(
          title: Center(
            child: Text(
              input,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          backgroundColor: Color(0XFF2e2d57),
          children: [
            Container(
              width: 300,
              color: Color(0XFF2e2d57),
              child: _PromptDialogContent(
                placeholder: placeholder,
                initialValue: initialValue,
                cancelText: cancelText,
                okText: okText,
                onOkPressed: onOkPressed,
              ),
            ),
          ],
        );

  @override
  Widget? get input => null;
}

class _PromptDialogContent extends StatefulWidget {
  final String placeholder;
  final String? initialValue;
  final String cancelText;
  final String okText;
  final void Function(String value)? onOkPressed;

  _PromptDialogContent({
    required this.placeholder,
    this.initialValue,
    required this.cancelText,
    required this.okText,
    this.onOkPressed,
  });

  @override
  _PromptDialogContentState createState() => _PromptDialogContentState();
}

class _PromptDialogContentState extends State<_PromptDialogContent> {
  late TextEditingController _textController;
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialValue);
    _textController.addListener(_validateInput);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(1.0),
          bottom: Radius.circular(11.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _textController,
              autofocus: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: TextStyle(color: Colors.white),
                contentPadding: const EdgeInsets.all(16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      widget.cancelText.toUpperCase(),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0XFF2e2d57)),
                      side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(color: Colors.white, width: 1.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: _canSubmit ? _submit : null,
                    child: Text(
                      widget.okText.toUpperCase(),
                      style: TextStyle(
                          color: Color(0XFF2e2d57),
                          fontWeight: FontWeight.w900),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _validateInput() {
    setState(() {
      _canSubmit = _textController.text.trim().isNotEmpty;
    });
  }

  void _submit() {
    if (widget.onOkPressed != null) {
      widget.onOkPressed!(_textController.text);
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class TimuDialogTheme extends StatelessWidget {
  final Widget child;

  TimuDialogTheme({required this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0, // this removes the shadow
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith<Color?>(
              (states) => Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ),
      child: child,
    );
  }
}
