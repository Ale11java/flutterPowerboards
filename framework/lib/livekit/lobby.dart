import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:webrtc_interface/webrtc_interface.dart';

import './room.dart';
import '../ui/text.dart';

class Lobby extends StatefulWidget {
  const Lobby({required this.join, super.key});

  final void Function() join;

  @override
  State<StatefulWidget> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  List<Widget> buildAudioMenu(BuildContext context, Room room) {
    final audioDevices = roomState.availableAudioDevices;
    final videoDevices = roomState.availableVideoDevices;

    final List<PopupMenuEntry> audioItems = [
      PopupMenuItem(
        child: Text("None"),
        value: null,
      )
    ];
    for (final device in audioDevices) {
      audioItems.add(
        CheckedPopupMenuItem(
          checked: device == roomState.selectedAudioDevice,
          child: Text(device.name),
          value: device,
        ),
      );
    }

    final List<PopupMenuEntry> videoItems = [
      PopupMenuItem(
        child: Text("None"),
        value: null,
      )
    ];
    for (final device in videoDevices) {
      videoItems.add(
        CheckedPopupMenuItem(
          checked: device == roomState.selectedVideoDevice,
          child: Text(device.name),
          value: device,
        ),
      );
    }

    return [
      PopupMenuButton(
        icon: Icon(Icons.mic),
        itemBuilder: (context) => audioItems,
        onSelected: (device) {
          if (device != null) {
            roomState.selectAudioDevice(device);
          } else {
            roomState.selectAudioDevice(roomState.defaultAudioDevice);
          }
        },
      ),
      PopupMenuButton(
        icon: Icon(Icons.videocam),
        itemBuilder: (context) => videoItems,
        onSelected: (device) {
          if (device != null) {
            roomState.selectVideoDevice(device);
          } else {
            if (roomState.defaultVideoDevice != null) {
              roomState.selectVideoDevice(roomState.defaultVideoDevice!);
            }
          }
        },
      ),
    ];
  }

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
      Row(
        children: [
          Flexible(
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: toggleCamera,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(56),
                    ),
                    padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                  ),
                  child: Text(
                    video == null ? "No Camera" : "Camera",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: toggleAudio,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(56),
                    ),
                    padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                  ),
                  child: Text(
                    audio == null ? "Muted" : "Audio",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: widget.join,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(56),
                    ),
                    padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                  ),
                  child: const Text(
                    "Join",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10), // Add a SizedBox with width 10 here
          ElevatedButton(
            onPressed: () {
              // Add your action here
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(56),
              ),
              padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
            ),
            child: const Text(
              "Default Device",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          SizedBox(width: 10), // Add a SizedBox with width 10 here
          ElevatedButton(
            onPressed: () {
              // Add your action here
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(56),
              ),
              padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
            ),
            child: const Text(
              "External Device",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    ]);
  }
}
