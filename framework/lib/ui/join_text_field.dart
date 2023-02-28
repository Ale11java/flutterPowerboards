// Define a custom Form widget.
import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  const InputTextField({
    super.key,
    this.controller,
    this.hintText,
    this.suffixIcon,
  });

  final TextEditingController? controller;
  final String? hintText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'Roboto',
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
          color: Colors.white,
        ),
        constraints: const BoxConstraints(
          maxHeight: 46,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
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
        suffixIcon: suffixIcon,
        suffixIconConstraints: const BoxConstraints(maxHeight: 46),
      ),
    );
  }
}

class UsernameField extends StatefulWidget {
  const UsernameField({super.key});

  @override
  State<UsernameField> createState() => _UsernameFieldState();
}

class _UsernameFieldState extends State<UsernameField> {
  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      InputTextField(
        controller: firstNameCtrl,
        hintText: 'Enter first name',
        ),
      const SizedBox(height: 20),
      InputTextField(
        controller: lastNameCtrl,
        hintText: 'Enter last name',
        ),
    ]);
  }
}

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
    return InputTextField(
      controller: controller,
      hintText: 'Enter Invite URL',
      suffixIcon:  Padding(
          padding: const EdgeInsets.all(8),
          child: FilledButton(
            onPressed: () {
              debugPrint(
                  'Received click $controller.text'); // ignore: avoid_print
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            child: const Text('JOIN NOW',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  color: Color(0xFF484575),
                )),
          ),
      ),
    );
  }
}
