import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:webrtc_interface/webrtc_interface.dart';

import './room.dart';
import '../ui/primary_button.dart';
import '../ui/text.dart';

class Lobby extends StatefulWidget {
  const Lobby({required this.join, super.key});

  final void Function() join;

  @override
  State<StatefulWidget> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  late VideoRoomProviderState roomState;
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
    } else {
      video?.dispose();
      LocalVideoTrack.createCameraTrack(const CameraCaptureOptions())
          .then((track) {
        setState(() {
          video = track;
        });
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

  LocalVideoTrack? video;
  LocalAudioTrack? audio;

  VideoRoom? room;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    roomState.fastConnectOptions = FastConnectOptions(
        microphone: TrackOption(track: audio, enabled: audio != null),
        camera: TrackOption(track: video, enabled: video != null));

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const ScreenTitle(text: "Adjust your Mic and Camera"),
      const SizedBox(height: 15),
      Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
              width: 400,
              height: 400,
              child: video != null
                  ? VideoTrackRenderer(video!,
                      fit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover)
                  : const ColoredBox(color: Colors.black))),
      Row(children: [
        PrimaryButton(
            text: video == null ? "No Camera" : "Camera",
            onPressed: toggleCamera),
        const SizedBox(width: 10),
        PrimaryButton(
            text: audio == null ? "Muted" : "Audio", onPressed: toggleAudio),
        const Spacer(),
        PrimaryButton(text: "Join", onPressed: widget.join)
      ]),
    ]);
  }
}
