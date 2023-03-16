import 'package:flutter/material.dart';

class ParticipantOverlay extends StatelessWidget {
  const ParticipantOverlay({
    super.key,
    required this.name,
    required this.muted,
  });

  final String name;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    return ColoredBox(
      color: Colors.black.withOpacity(0.3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          Icon(
            muted ? Icons.mic_off : Icons.mic,
            color: Colors.white,
            size: 40,
          ),
          Image.asset(
            'assets/icons/mic-${pixelRatio}x.png',
            width: 24 * pixelRatio,
            height: 24 * pixelRatio,
          ),
        ],
      ),
    );
  }
}
