import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:webrtc_interface/webrtc_interface.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../timu_icons/timu_icons.dart';

import './room.dart';
import '../ui/text.dart';

import 'dart:core';
import 'package:collection/collection.dart';

import 'dart:async';
import 'dart:convert';

class Lobby extends StatefulWidget {
  Lobby({
    super.key,
    required this.join,
  });

  final void Function() join;

  @override
  State<StatefulWidget> createState() => _ControlsWidgetState();
}

class _ControlsWidgetState extends State<Lobby> {
  //

  late VideoRoomProviderState roomState;

  CameraPosition position = CameraPosition.front;

  List<MediaDevice>? _audioInputs;
  List<MediaDevice>? _audioOutputs;
  List<MediaDevice>? _videoInputs;

  StreamSubscription? _subscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    roomState = context.findAncestorStateOfType<VideoRoomProviderState>()!;
    roomState.fastConnectOptions = FastConnectOptions();
  }

  @override
  void initState() {
    super.initState();
    _subscription = Hardware.instance.onDeviceChange.stream
        .listen((List<MediaDevice> devices) {
      _loadDevices(devices);
    });
    Hardware.instance.enumerateDevices().then(_loadDevices).then((_) {
      _enableVideo();
      _enableAudio();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _loadDevices(List<MediaDevice> devices) async {
    _audioInputs = devices.where((d) => d.kind == 'audioinput').toList();
    _audioOutputs = devices.where((d) => d.kind == 'audiooutput').toList();
    _videoInputs = devices.where((d) => d.kind == 'videoinput').toList();
    setState(() {});
  }

  void _onChange() {
    // trigger refresh
    setState(() {});
  }

  bool get isMuted => audio != null;

  void _disableAudio() async {
    audio?.dispose();
    audio = null;
    localAudioDevice = null;

    setState(() {});
  }

  void _enableAudio() async {
    if (_audioInputs?.isEmpty ?? true) {
      return;
    }
    await _selectAudioInput(_audioInputs![0]);
  }

  void _disableVideo() async {
    video?.dispose();
    video = null;
    localVideoDevice = null;

    setState(() {});
  }

  void _enableVideo() async {
    if (_videoInputs?.isEmpty ?? true) {
      return;
    }
    await _selectVideoInput(_videoInputs![0]);
  }

  Future<void> _selectAudioOutput(MediaDevice device) async {
    // TODO
    //await widget.room.setAudioOutputDevice(device);
    setState(() {});
  }

  LocalAudioTrack? audio;
  MediaDevice? localAudioDevice;
  Future<void> _selectAudioInput(MediaDevice device) async {
    await LocalAudioTrack.create(AudioCaptureOptions(deviceId: device.deviceId))
        .then((track) {
      localAudioDevice = device;
      audio = track;
    });
    setState(() {});
  }

  LocalVideoTrack? video;
  MediaDevice? localVideoDevice;
  Future<void> _selectVideoInput(MediaDevice device) async {
    await LocalVideoTrack.createCameraTrack(
            CameraCaptureOptions(deviceId: device.deviceId))
        .then((track) {
      video = track;
      localVideoDevice = device;
    });
    setState(() {});
  }

  void _toggleCamera() async {
    //
    final track = video;
    if (track == null) return;

    try {
      final newPosition = position.switched();
      await track.setCameraPosition(newPosition);
      setState(() {
        position = newPosition;
      });
    } catch (error) {
      print('could not restart track: $error');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    roomState.fastConnectOptions = FastConnectOptions(
      microphone: TrackOption(track: audio, enabled: audio != null),
      camera: TrackOption(track: video, enabled: video != null),
    );

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
      Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 5,
          runSpacing: 5,
          children: [
            if (audio != null)
              PopupMenuButton<MediaDevice>(
                icon: const Icon(
                  TimuIcons.audio,
                  color: Colors.white,
                ),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<MediaDevice>(
                      value: null,
                      child: const ListTile(
                        leading: Icon(
                          TimuIcons.audio_mute,
                          color: Colors.black,
                        ),
                        title: Text('Mute Microphone'),
                      ),
                      onTap: isMuted ? _enableAudio : _disableAudio,
                    ),
                    if (_audioInputs != null)
                      ..._audioInputs!.map((device) {
                        return PopupMenuItem<MediaDevice>(
                          value: device,
                          child: ListTile(
                            leading: (device.deviceId ==
                                    (localAudioDevice?.deviceId ?? ""))
                                ? const Icon(
                                    TimuIcons.checkbox_on,
                                    color: Colors.black,
                                  )
                                : const Icon(
                                    TimuIcons.checkbox_off,
                                    color: Colors.black,
                                  ),
                            title: Text(device.label),
                          ),
                          onTap: () => _selectAudioInput(device),
                        );
                      }).toList()
                  ];
                },
              )
            else
              IconButton(
                onPressed: _enableAudio,
                icon: const Icon(TimuIcons.audio_mute),
                tooltip: 'un-mute audio',
                color: Colors.white,
              ),
            /*PopupMenuButton<MediaDevice>(
              icon: const Icon(Icons.volume_up),
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<MediaDevice>(
                    value: null, 
                    child: ListTile(
                      /*leading: Icon(
                        EvaIcons.speaker,
                        color: Colors.white,
                      ),*/
                      title: Text('Select Audio Output'),
                    ),
                  ),
                  if (_audioOutputs != null)
                    ..._audioOutputs!.map((device) {
                      return PopupMenuItem<MediaDevice>(
                        value: device,
                        child: ListTile(
                          leading: (device.deviceId ==
                                  (localAudioDevice.deviceId ?? ""))
                              ? const Icon(
                                  TimuIcons.checkbox_on,
                                  color: Colors.white,
                                )
                              : const Icon(
                                  TimuIcons.checkbox_off,
                                  color: Colors.white,
                                ),
                          title: Text(device.label),
                        ),
                        onTap: () => _selectAudioOutput(device),
                      );
                    }).toList()
                ];
              },
              
            ),*/
            if (video != null)
              PopupMenuButton<MediaDevice>(
                icon: const Icon(
                  TimuIcons.video,
                  color: Colors.white,
                ),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<MediaDevice>(
                      value: null,
                      child: const ListTile(
                        leading: Icon(
                          TimuIcons.video_off,
                          color: Colors.black,
                        ),
                        title: Text('Disable Camera'),
                      ),
                      onTap: _disableVideo,
                    ),
                    if (_videoInputs != null)
                      ..._videoInputs!.map((device) {
                        return PopupMenuItem<MediaDevice>(
                          value: device,
                          child: ListTile(
                            leading: (device.deviceId ==
                                    (localVideoDevice?.deviceId ?? ""))
                                ? const Icon(
                                    TimuIcons.checkbox_on,
                                    color: Colors.black,
                                  )
                                : const Icon(
                                    TimuIcons.checkbox_off,
                                    color: Colors.black,
                                  ),
                            title: Text(device.label),
                          ),
                          onTap: () => _selectVideoInput(device),
                        );
                      }).toList()
                  ];
                },
              )
            else
              IconButton(
                onPressed: _enableVideo,
                icon: const Icon(TimuIcons.video_off),
                tooltip: 'un-mute video',
                color: Colors.white,
              ),
            /*
            IconButton(
              icon: Icon(position == CameraPosition.back
                  ? TimuIcons.video
                  : TimuIcons.user),
              onPressed: () => _toggleCamera(),
              tooltip: 'toggle camera',
            ),*/

            FilledButton(onPressed: () => widget.join(), child: Text("Join"))
          ],
        ),
      )
    ]);
  }
}
