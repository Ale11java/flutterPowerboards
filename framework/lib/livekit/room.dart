import "dart:async";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:livekit_client/livekit_client.dart" as lk;
import "package:livekit_client/src/constants.dart";
import "../timu_icons/timu_icons.dart";
import "../timu_api/timu_api.dart";
import "package:http/http.dart" as http;
import "dart:convert";
import "../ui/meeting_header.dart";

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

  headers["Content-Type"] = "application/json";
  if (connection.accessToken != "") {
    headers["authorization"] = "Bearer ${connection.accessToken}";
  }

  final response = await http.post(Uri.parse(connectURL),
      headers: headers, body: jsonEncode(connection.toJSON()));

  final connectionResponse =
      ConnectionResponse.fromJSON(jsonDecode(response.body));
  return connectionResponse;
}

class VideoRoom extends InheritedWidget {
  const VideoRoom({required this.room, super.key, required super.child});
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

  @override
  void initState() {
    super.initState();

    const roomOptions = lk.RoomOptions(
        adaptiveStream: true,
        dynacast: true,
        defaultScreenShareCaptureOptions:
            lk.ScreenShareCaptureOptions(useiOSBroadcastExtension: true));

    const connectOptions = lk.ConnectOptions(
        timeouts: Timeouts(
            connection: Duration(seconds: 30),
            debounce: Duration(milliseconds: 100),
            publish: Duration(seconds: 10),
            peerConnection: Duration(seconds: 30),
            iceRestart: Duration(seconds: 30)));

    room = lk.Room(roomOptions: roomOptions, connectOptions: connectOptions);
  }

  @override
  void dispose() {
    super.dispose();

    room.dispose();
  }

  late lk.Room room;

  @override
  Widget build(BuildContext context) {
    return VideoRoom(room: room, child: widget.child);
  }
}

class VideoChatConnectionWidget extends StatefulWidget {
  const VideoChatConnectionWidget(this.nounURL, this.connection,
      {super.key, required this.child});

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
