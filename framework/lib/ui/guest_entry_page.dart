import 'package:flutter/material.dart';

import 'join_text_field.dart';
import 'text.dart';

class GuestEntryPage extends StatelessWidget {
  const GuestEntryPage({super.key});

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
            child: const Padding(
              padding: EdgeInsets.all(40),
              // Horizontal Centering (capped by SizedBox)
              child: Center(
                child: SizedBox(
                  width: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ScreenTitle(
                          text: 'Introduce yourself to other attendees'),
                      SizedBox(height: 16),
                      ScreenSubtitle(text: 'Daily meeting'),
                      SizedBox(height: 44),
                      UsernameField(),
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
