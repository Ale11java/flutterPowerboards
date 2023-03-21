import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'text.dart';

class UserHasNoAccess extends StatelessWidget {
  const UserHasNoAccess(
      {super.key,
      required this.onContinueToLobby,
      required this.onContinueAsGuest,
      required this.onSelectAccount});

  final Function() onContinueToLobby;
  final Function() onContinueAsGuest;
  final Function() onSelectAccount;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0XFF2F2D57),
      child: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 400,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const ScreenTitle(
                  text: 'You do not have access', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              const ScreenSubtitle(
                  text: 'Select one of the following options',
                  textAlign: TextAlign.center),
              const SizedBox(height: 44),
              FilledButton(
                  onPressed: onContinueToLobby,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(42),
                  ),
                  child: Text('CONTINUE TO LOBBY',
                      style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        color: Color(0xFF484575),
                      )))),
              const SizedBox(height: 28),
              Text(
                'OR',
                style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: Colors.white,
                )),
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: onSelectAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(42),
                ),
                child: Text(
                  'SWITCH ACCOUNT',
                  style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    color: Color(0xFF484575),
                  )),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'OR',
                style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: Colors.white,
                )),
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: onContinueAsGuest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(42),
                ),
                child: Text(
                  'CONTINUE AS GUEST',
                  style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    color: Color(0xFF484575),
                  )),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
