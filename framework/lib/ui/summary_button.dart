import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BasicSummaryButton extends StatelessWidget {
  const BasicSummaryButton({
    super.key,
    required this.imageName,
    required this.title,
    required this.body,
  });
  final String imageName;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return SummaryButton(
        graphic: SummaryGraphic(
            graphic: Image.asset(
          imageName,
          width: 18,
          height: 18,
        )),
        title: SummaryButtonTitleText(text: title),
        body: SummaryButtonBodyText(text: body));
  }
}

class SummaryButton extends StatelessWidget {
  const SummaryButton({
    super.key,
    required this.graphic,
    required this.title,
    required this.body,
  });
  final Widget graphic;
  final Widget title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // padding: const EdgeInsets.all(16),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(10),
      //   color: Colors.grey[200],
      //   boxShadow: const <BoxShadow>[
      //     BoxShadow(
      //       color: Colors.grey,
      //       blurRadius: 10,
      //       offset: Offset(0, 5),
      //     ),
      //   ],
      // ),
      onPressed: () {},
      style: ElevatedButton.styleFrom().copyWith(
        backgroundColor: MaterialStateProperty.resolveWith(
            (Set<MaterialState> states) => Colors.transparent),
        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return Colors.white;
          }
          return const Color(
            0xffb2bef8,
          );
        }),
        padding: MaterialStateProperty.resolveWith(
            (Set<MaterialState> states) => EdgeInsets.zero),
        elevation:
            MaterialStateProperty.resolveWith((Set<MaterialState> states) => 0),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10));
            }
            return null; // Defer to the widget's default.
          },
        ),
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered))
              // return Colors.redAccent;
              return Colors.transparent;
            return null; // Defer to the widget's default.
          },
        ),
        side: MaterialStateProperty.resolveWith<BorderSide?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return const BorderSide(
                width: 1.6,
                color: Colors.white,
              );
            }
            return null; // Defer to the widget's default.
          },
        ),
      ),
      // style: ElevatedButton.styleFrom(
      //   backgroundColor: Colors.red,
      //   // disabledBackgroundColor: Colors.transparent,
      //   // shadowColor: Colors.blue,
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      //   elevation: 0,
      //   padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
      //   side: const BorderSide(
      //     width: 3.0,
      //   ),
      // ),
      child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              graphic,
              const SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[title, body],
              )
            ],
          )
          // child: Text('fox jumped over the moon'),
          // crossAxisAlignment: CrossAxisAlignment.start,
          // children: <Widget>[
          //   // graphic,
          //   const SizedBox(width: 16),
          //   Column(
          //     // crossAxisAlignment: CrossAxisAlignment.start,
          //     children: <Widget>[
          //       // SizedBox(
          //       //   width: double.infinity,
          //       //   child: title,
          //       // ),
          //       const SizedBox(height: 16),
          //       // SizedBox(
          //       //   width: double.infinity,
          //       //   child: body,
          //       // ),
          //     ],
          ),
      // ],
    );
    // );
  }
}

class SummaryButtonTitleText extends StatelessWidget {
  const SummaryButtonTitleText({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.inter(
            textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          height: 1,
          letterSpacing: 0,
        )));
  }
}

class SummaryButtonBodyText extends StatelessWidget {
  const SummaryButtonBodyText({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        // color: Color(
        //   0xffb2bef8,
        // ),
        fontSize: 11,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
        height: 1.64,
        letterSpacing: 0,
      ),
    );
  }
}

class SummaryGraphic extends StatelessWidget {
  const SummaryGraphic({
    super.key,
    required this.graphic,
  });
  final Widget graphic;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color.fromRGBO(74, 70, 147, 1),
          // shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Image.asset(
          'lib/assets/app-timu.png',
          width: 18,
          height: 18,
        ));
  }
}
