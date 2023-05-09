import 'package:flutter/material.dart';

class BackIconButton extends StatelessWidget {
  const BackIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      // icon: const Icon(Icons.arrow_back),
      icon: Image.asset(
        'lib/assets/arrow-angle-left.png',
        width: 18,
        height: 18,
      ),
      onPressed: () {
        // Implement the back button functionality
        Navigator.of(context).pop();
      },
    );
  }
}
