import 'package:flutter/material.dart';
import '../timu_icons/timu_icons.dart';

class ParticipantOverlay extends StatelessWidget {
  const ParticipantOverlay({
    Key? key,
    required this.name,
    required this.muted,
  }) : super(key: key);

  final String name;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Color(0x992f2d57),
      ),
      padding: const EdgeInsets.only(
        left: 6,
        right: 9,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 16,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              muted ? TimuIcons.audio_mute : TimuIcons.audio,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 1),
          SizedBox(
            height: 16, // adjust this value to create the desired spacing
            child: Transform.translate(
              offset: Offset(0, 2), // adjust this value to shift the text down
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
