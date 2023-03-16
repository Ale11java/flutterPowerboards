import 'package:flutter/material.dart';

import 'join_page.dart';
import 'text.dart';

class GuestEntryPage extends StatelessWidget {
  const GuestEntryPage(this.onSubmit, {super.key});

  final Function(String, String) onSubmit;

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
                      UsernameField(onSubmit),
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
