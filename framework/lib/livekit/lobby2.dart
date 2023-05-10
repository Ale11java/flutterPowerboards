import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:livekit_client/livekit_client.dart';
import 'package:timu_dart/ui/text.dart';
import 'package:timu_dart/ui/primary_button.dart';
import 'package:webrtc_interface/webrtc_interface.dart';
import 'room.dart';

class Lobby2 extends StatefulWidget {
  const Lobby2({required this.join, super.key});
  final void Function() join;
  @override
  State<StatefulWidget> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby2> {
  late VideoRoomProviderState roomState;
  LocalVideoTrack? video;
  LocalAudioTrack? audio;
  VideoRoom? room;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    roomState = context.findAncestorStateOfType<VideoRoomProviderState>()!;
    roomState.fastConnectOptions = FastConnectOptions();
    if (!kDebugMode) {
      LocalVideoTrack.createCameraTrack(const CameraCaptureOptions())
          .then((track) {
        setState(() {
          video = track;
        });
      });
      LocalAudioTrack.create(const AudioCaptureOptions()).then((track) {
        setState(() {
          audio = track;
        });
      });
    }
  }

  void toggleCamera() {
    if (video != null) {
      setState(() {
        video?.dispose();
        video = null;
      });
    }
  }

  void toggleAudio() {
    if (audio != null) {
      audio?.dispose();
      setState(() {
        audio = null;
      });
    } else {
      LocalAudioTrack.create(const AudioCaptureOptions()).then((track) {
        setState(() {
          audio = track;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    roomState.fastConnectOptions = FastConnectOptions(
      microphone: TrackOption(track: audio, enabled: audio != null),
      camera: TrackOption(track: video, enabled: video != null),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const ScreenTitle(text: "Adjust your Mic and Camera"),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            width: 400,
            height: 400,
            child: video != null
                ? VideoTrackRenderer(
                    video!,
                    fit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  )
                : const ColoredBox(color: Colors.black),
          ),
        ),
        Row(
          children: [
            PrimaryButton(
              text: video == null ? "No Camera" : "Camera",
              onPressed: toggleCamera,
            ),
            const SizedBox(width: 10),
            PrimaryButton(
              text: audio == null ? "Muted" : "Audio",
              onPressed: toggleAudio,
            ),
            const Spacer(),
            PrimaryButton(text: "Join", onPressed: widget.join),
          ],
        ),
      ],
    );
  }
}

class Lobby extends StatelessWidget {
  const Lobby({required this.join, super.key});
  final void Function() join;
  @override
  Widget build(BuildContext context) {
    return PrimaryButton(text: "Join", onPressed: join);
  }
}
