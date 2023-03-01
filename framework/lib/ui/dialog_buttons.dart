import 'package:flutter/material.dart';

class CustomButtonRow extends StatelessWidget {
  final List<Map<String, dynamic>> buttons;
  final MainAxisAlignment mainAxisAlignment;

  CustomButtonRow(
      {required this.buttons,
      this.mainAxisAlignment = MainAxisAlignment.spaceEvenly});

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: buttons.map((buttonData) {
        return SizedBox(
          width: buttonData['width'] ?? 100,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: buttonData['color'],
              onPrimary: buttonData['textColor'] ?? Color(0xFFFFFFFF),
              side: buttonData['borderColor'] != null
                  ? BorderSide(color: buttonData['borderColor']!, width: 1)
                  : null,
            ),
            onPressed: buttonData['onPressed'],
            child: Text(buttonData['text']),
          ),
        );
      }).toList(),
    );
  }
}
