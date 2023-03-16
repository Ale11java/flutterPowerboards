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
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0XFF2F2D57),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: avatar,
            radius: 25.0,
          ),
          const SizedBox(width: 16.0),
          Container(
            width: 16.0,
            color: const Color(0XFF2F2D57),
            child: const SizedBox(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white),
                ),
                const SizedBox(height: 8.0),
                Text(
                  text,
                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (secondaryAction != null)
                      TextButton(
                        onPressed: secondaryAction!.onPressed,
                        child: Text(secondaryAction!.label),
                      ),
                    if (primaryAction != null)
                      ElevatedButton(
                        onPressed: primaryAction!.onPressed,
                        child: Text(primaryAction!.label),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationAction {
  const NotificationAction({required this.label, this.onPressed});

  final String label;
  final void Function()? onPressed;
}
