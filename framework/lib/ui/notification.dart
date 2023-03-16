import 'package:flutter/material.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({
    super.key,
    required this.avatar,
    required this.title,
    required this.text,
    this.primaryAction,
    this.secondaryAction,
  });

  final ImageProvider avatar;
  final String title;
  final String text;
  final NotificationAction? primaryAction;
  final NotificationAction? secondaryAction;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(0XFF2f2e57),
          borderRadius: BorderRadius.circular(10.0),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.5),
          //     spreadRadius: 2,
          //     blurRadius: 5,
          //     offset: const Offset(0, 3),
          //   ),
          // ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: avatar,
                  radius: 25.0,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w800,
                            fontSize: 14.0,
                            color: Colors.white,
                            letterSpacing: 0.4),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        text,
                        style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0,
                            color: Color(0XFFD5DADD),
                            letterSpacing: 0.4),
                      ),
                    ],
                  ),
                ),
                if (secondaryAction != null || primaryAction != null)
                  const SizedBox(height: 16.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (primaryAction != null)
                      SizedBox(
                        width: 92,
                        child: FilledButton(
                          onPressed: primaryAction!.onPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0XFFFFFFFF),
                            minimumSize: const Size.fromHeight(30),
                            textStyle: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.4,
                            ),
                            foregroundColor: const Color(0XFF2e2d57),
                          ),
                          child: Text(primaryAction!.label.toUpperCase()),
                        ),
                      ),
                    //if (primaryAction != null) const SizedBox(height: 10),
                    if (secondaryAction != null)
                      SizedBox(
                        width: 92,
                        child: FilledButton(
                          onPressed: secondaryAction!.onPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0XFF2f2d57),
                            minimumSize: const Size.fromHeight(30),
                            textStyle: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.4,
                            ),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            foregroundColor: Color(0XFFFFFFFF),
                          ),
                          child: Text(secondaryAction!.label.toUpperCase()),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationAction {
  const NotificationAction({required this.label, this.onPressed});

  final String label;
  final void Function()? onPressed;
}
