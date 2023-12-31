// camera_box.dart

import 'package:flutter/material.dart';
import 'participant_overlay.dart';

class CameraBox extends StatelessWidget {
  final Widget camera;
  final String participantName;
  final bool muted;

  const CameraBox({
    Key? key,
    required this.camera,
    required this.participantName,
    this.muted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(blurRadius: 5, color: Color.fromARGB(50, 0, 0, 0))
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Stack(
          children: [
            camera,
            Positioned(
              bottom: 10,
              left: 10,
              child: IntrinsicWidth(
                  child: ParticipantOverlay(
                name: participantName,
                muted: muted,
              )),
            ),
          ],
        ),
      ),
    );
  }
}
