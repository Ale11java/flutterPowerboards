// Room.dart
import "dart:async";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:livekit_client/livekit_client.dart" as lk;
import "package:livekit_client/src/constants.dart";
import 'package:webrtc_interface/src/mediadevices.dart';
import "../timu_icons/timu_icons.dart";
import "../timu_api/timu_api.dart";
import "package:http/http.dart" as http;
import "dart:convert";
import "../ui/meeting_header.dart";
import "package:livekit_client/src/proto/livekit_models.pb.dart";
import "package:timu_dart/timu_icons/timu_icons.dart";
import "package:timu_dart/ui.dart" as tui;
import "package:timu_dart/timu_api/timu_api.dart";
import 'package:flutter/foundation.dart';
import "package:timu_dart/ui/meeting_header.dart";

class ConnectionInfo {
  String provider = "livekit";
  String device = "";
  String room = "";
  String username = "";
  String accessToken = "";

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "provider": provider,
      "device": device,
      "room": room,
      "username": username,
      "accessToken": accessToken
    };
  }
}

class ConnectionResponse {
  ConnectionResponse();

  ConnectionResponse.fromJSON(Map<String, dynamic> json) {
    url = (json["url"] != null ? json["url"] : "");
    token = (json["token"] != null ? json["token"] : "");
    roomType = (json["roomType"] != null ? json["roomType"] : "");
  }

  String url = "";
  String token = "";
  String roomType = "";
}

Future<ConnectionResponse> getConnection(
    BuildContext context, String nounURL, ConnectionInfo connection) async {
  var host = TimuApiProvider.of(context).api.host;
  var accessToken = connection.accessToken;
  var username = connection.username;
  var connectURL =
      "https://${host}/${nounURL}/+${accessToken == "" ? "public" : "invoke"}/connect?";
  if (username != "") {
    connectURL += "username=${Uri.encodeComponent(username)}";
  }
  final headers = <String, String>{};
  if (connection.accessToken != "") {
    headers["authorization"] = "Bearer ${connection.accessToken}";
  }
  final response = await http.post(Uri.parse(connectURL),
      headers: headers, body: connection.toJSON());
  final connectionResponse =
      ConnectionResponse.fromJSON(jsonDecode(response.body));
  return connectionResponse;
}

class VideoRoom extends InheritedWidget {
  const VideoRoom({
    required this.room,
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  final lk.Room room;

  static VideoRoom? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VideoRoom>();
  }

  static VideoRoom of(BuildContext context) {
    return maybeOf(context)!;
  }

  @override
  bool updateShouldNotify(covariant VideoRoom oldWidget) {
    return room != oldWidget.room;
  }
}

class VideoRoomProvider extends StatefulWidget {
  const VideoRoomProvider({super.key, required this.child});
  final Widget child;

  @override
  State<StatefulWidget> createState() => VideoRoomProviderState();
}

class VideoRoomProviderState extends State<VideoRoomProvider> {
  VideoRoomProviderState();

  lk.FastConnectOptions? fastConnectOptions;
  late lk.Room room;

  get availableAudioDevices => null;

  get availableVideoDevices => null;

  Object? get selectedAudioDevice => null;

  Object? get selectedVideoDevice => null;

  get defaultAudioDevice => null;

  MediaDeviceInfo? get defaultVideoDevice => null;

  @override
  void initState() {
    super.initState();

    const roomOptions = lk.RoomOptions(
      adaptiveStream: true,
      dynacast: true,
      defaultScreenShareCaptureOptions: lk.ScreenShareCaptureOptions(
        useiOSBroadcastExtension: true,
      ),
    );

    const connectOptions = lk.ConnectOptions(
      timeouts: Timeouts(
        connection: Duration(seconds: 30),
        debounce: Duration(milliseconds: 100),
        publish: Duration(seconds: 10),
        peerConnection: Duration(seconds: 30),
        iceRestart: Duration(seconds: 30),
      ),
    );

    room = lk.Room(roomOptions: roomOptions, connectOptions: connectOptions);

    /* var localParticipant = (room.localParticipant as lk.LocalParticipant);
    localParticipant
        .setMicrophoneEnabled(true)
        .catchError((err) async => print(err));
    localParticipant
        .setCameraEnabled(true)
        .catchError((err) async => print(err));*/
  }

  @override
  void dispose() {
    super.dispose();
    room.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VideoRoom(room: room, child: widget.child);
  }

  void selectAudioDevice(defaultAudioDevice) {}

  void selectVideoDevice(MediaDeviceInfo device) {}
}

class VideoChatConnectionWidget extends StatefulWidget {
  const VideoChatConnectionWidget(
    this.nounURL,
    this.connection, {
    required Key key,
    required this.child,
  }) : super(key: key);

  final String nounURL;
  final ConnectionInfo connection;
  final Widget child;

  @override
  State<StatefulWidget> createState() => VideoChatConnectionState();
}

class VideoChatConnectionState extends State<VideoChatConnectionWidget> {
  Future<ConnectionResponse>? _ensureConnectionFuture;

  Future<ConnectionResponse> _ensureConnection(lk.Room room) {
    _ensureConnectionFuture ??=
        getConnection(context, widget.nounURL, widget.connection);
    return _ensureConnectionFuture!;
  }

  Future<bool>? _roomConnectFuture;

  Future<bool> _ensureRoomConnect(ConnectionResponse connection, lk.Room room,
      lk.FastConnectOptions? fastConnectOptions) {
    if (_roomConnectFuture == null) {
      room.connect(connection.url, connection.token,
          fastConnectOptions: fastConnectOptions);
      final completer = Completer<bool>();
      room.addListener(() {
        if (room.localParticipant != null && !completer.isCompleted) {
          print("Local participant is ready");
          completer.complete(true);
        }
      });
      _roomConnectFuture = completer.future;
    }
    return _roomConnectFuture!;
  }

  @override
  Widget build(BuildContext context) {
    final room = VideoRoom.of(context).room;
    return FutureBuilder(
        future: _ensureConnection(room),
        builder: (context, state) {
          final fastConnectOptions = context
              .findAncestorStateOfType<VideoRoomProviderState>()!
              .fastConnectOptions;
          if (state.hasData) {
            return FutureBuilder(
                future:
                    _ensureRoomConnect(state.data!, room, fastConnectOptions),
                builder: (context, state) {
                  if (state.hasData) {
                    return VideoChatRoomWidget(room, child: widget.child);
                  } else if (state.hasError) {
                    return Text(
                        "Unable to connect, please try again: ${state.error!.toString()}");
                  } else {
                    return const CircularProgressIndicator(color: Colors.red);
                  }
                });
          } else if (state.hasError) {
            // TODO: auto retry
            return Text(
                "Unable to get connection info, please try again: ${state.error!.toString()}");
          } else {
            return const CircularProgressIndicator(color: Colors.green);
          }
        });
  }
}

class VideoChatRoomWidget extends StatelessWidget {
  const VideoChatRoomWidget(this.room, {required this.child, super.key});
  final lk.Room room;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class CameraToggle extends StatefulWidget {
  const CameraToggle({super.key});
  @override
  State<StatefulWidget> createState() => _CameraToggleState();
}

class _CameraToggleState extends State<CameraToggle> {
  bool state = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final room = VideoRoom.of(context);
    final local = room.room.localParticipant;
    state = local!.isCameraEnabled();
  }

  @override
  Widget build(BuildContext context) {
    final room = VideoRoom.of(context);
    final local = room.room.localParticipant;
    if (local != null) {
      return MeetingHeaderButton(
          text: "Camera",
          on: state,
          onPressed: () {
            setState(() {
              var value = !state;
              local.setCameraEnabled(value);
              state = value;
            });
          },
          icon: (state ? TimuIcons.video : TimuIcons.video_off));
    } else {
      return const Text("");
    }
  }
}

class MicToggle extends StatefulWidget {
  const MicToggle({super.key});
  @override
  State<StatefulWidget> createState() => _MicToggleState();
}

class _MicToggleState extends State<MicToggle> {
  bool state = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final room = VideoRoom.of(context);
    final local = room.room.localParticipant;
    state = local!.isMicrophoneEnabled();
  }

  @override
  Widget build(BuildContext context) {
    final room = VideoRoom.of(context);
    final local = room.room.localParticipant;
    if (local != null) {
      return MeetingHeaderButton(
          text: "Mic",
          on: state,
          onPressed: () {
            setState(() {
              var value = !state;
              local.setMicrophoneEnabled(value);
              state = value;
            });
          },
          icon: state ? TimuIcons.audio : TimuIcons.audio_mute);
    } else {
      return const Text("");
    }
  }
}

class DisconnectButton extends StatelessWidget {
  const DisconnectButton({super.key});
  @override
  Widget build(BuildContext context) {
    return MeetingHeaderButton(
        text: "Hangup",
        onPressed: () {
          context.go("/");
        },
        icon: TimuIcons.phone_hangup);
  }
}
