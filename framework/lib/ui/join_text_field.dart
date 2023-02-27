// Define a custom Form widget.
import 'package:flutter/material.dart';

class JoinTextField extends StatefulWidget {
  const JoinTextField({super.key});

  @override
  State<JoinTextField> createState() => _JoinTextFieldState();
}

// Define a corresponding State class.
// This class holds data related to the Form.
class _JoinTextFieldState extends State<JoinTextField> {
  // Create a text controller. Later, use it to retrieve the
  // current value of the TextField.
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller.addListener(_printLatestValue);
  }

  void _printLatestValue() {
    print('Second text field: ${controller.text}'); // ignore: avoid_print
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fill this out in the next step.
    return TextField(
      controller: controller,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'Roboto',
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: 'Enter Invite URL',
        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
          color: Colors.white,
        ),

        constraints: const BoxConstraints(
          maxHeight: 46,
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20
        ),

        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 2,
            color: Color(0xFFAC95FF),
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 3,
            color: Color(0xFFAC95FF),
          ),
          borderRadius: BorderRadius.circular(23.0),
        ),

        suffixIcon: Padding(
          padding: const EdgeInsets.all(8),
          child: FilledButton(
            onPressed: () {
              debugPrint('Received click $controller.text'); // ignore: avoid_print
            },

            style: ElevatedButton.styleFrom(
            ),

            child: const Text('JOIN NOW', style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w900,
                fontSize: 13,
                color: Color(0xFF484575),
            )),
          ),
        ),
        suffixIconConstraints: const BoxConstraints(maxHeight: 46),
      ),
    );
  }
}
