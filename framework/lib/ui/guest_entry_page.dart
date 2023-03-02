import 'package:flutter/material.dart';
import 'join_text_field.dart';
import 'text.dart';

class GuestEntryPage extends StatelessWidget {
  const GuestEntryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF2F2D57),
      // Centers vertically
      body: Center(
        child: SingleChildScrollView(
          // Allow scrolling to the right / left of the input fields
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            // Narrow device side gutter
            child: Padding(
              padding: const EdgeInsets.all(40),
              // Horizontal Centering (capped by SizedBox)
              child: Center(
                child: SizedBox(
                  width: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const ScreenTitle(
                          text: 'Introduce yourself to other attendees'),
                      const SizedBox(height: 16),
                      const ScreenSubtitle(text: 'Daily meeting'),
                      const SizedBox(height: 44),
                      const UsernameField(),
                      const SizedBox(height: 28),
                      FilledButton(
                        onPressed: () {
                          debugPrint(
                              'Received click text'); // ignore: avoid_print
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(42),
                        ),
                        child: const Text('CONTINUE',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                              color: Color(0xFF484575),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
