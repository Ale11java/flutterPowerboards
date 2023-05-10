import 'package:flutter/material.dart';

const Color PRIMARY_COLOR_1 = Color(0xFF2F2D57);
const Color PRIMARY_COLOR_2 = Color(0xFF5D59A3);
const Color PRIMARY_COLOR_3 = Color(0xFF7569DF);
const Color PRIMARY_COLOR_4 = Color(0xFFF0ECFF);
const Color PRIMARY_COLOR_5 = Color(0xFF977AFF);

const Color PRIMARY_COLOR = Color(0xFF4B0082);
const Color PRIMARY_COLOR_DARK = Color(0xFF2F2D57);
const Color PRIMARY_COLOR_MEDIUM = Color(0xFF7752FF);
const Color PRIMARY_COLOR_LIGHT = Color(0xFFE6E6FA);
const Color SECONDARY_HEADER_COLOR = Color(0xFFADD8E6);
const Color FILL_COLOR = Color(0xfff0ecff);
const Color GRAYSCALE_1 = Color(0xff646667);
const Color GRAYSCALE_2 = Color(0xffF7F9FB);
const Color GRAYSCALE_3 = Color(0xffD5DADD);

class LoginThemeWidget extends StatelessWidget {
  const LoginThemeWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(
        primaryColor: PRIMARY_COLOR_2,
        primaryColorDark: PRIMARY_COLOR_1,
        primaryColorLight: PRIMARY_COLOR_LIGHT,
        secondaryHeaderColor: SECONDARY_HEADER_COLOR,
        appBarTheme: theme.appBarTheme.copyWith(
          backgroundColor: Colors.white,
          // titleTextStyle:
          //     theme.textTheme.titleLarge?.apply(color: Colors.white),
          // iconTheme: const IconThemeData(color: Colors.white),
        ),
        textTheme: theme.textTheme.copyWith(
          titleMedium: theme.textTheme.titleMedium?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
            color: PRIMARY_COLOR_1,
          ),
        ),
        inputDecorationTheme: theme.inputDecorationTheme.copyWith(
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
            color: Color(0xFFFFFFFF),
          ),
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
            color: PRIMARY_COLOR_3,
          ),
          errorStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
            color: Colors.red,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0XFFED6464),
            ),
            borderRadius: BorderRadius.circular(50.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0XFFED6464),
            ),
            borderRadius: BorderRadius.circular(50.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              // color: Color(0xFFAC95FF),
              // color: Theme.of(context).primaryColorLight,
              color: Color(0xFFFFFFFF),
            ),
            borderRadius: BorderRadius.circular(50.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              // color: Color(0xFFFFFFFF),
              color: PRIMARY_COLOR_3,
            ),
            borderRadius: BorderRadius.circular(23.0),
          ),
          // focusColor: Color(0xfff0ecff),
          fillColor: PRIMARY_COLOR_4,
          filled: true,
        ),
      ),
      child: child,
    );
  }
}
