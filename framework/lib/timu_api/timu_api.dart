/// TIMU Flutter API

library timu_api;

import 'dart:convert';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'websocket.dart';

class RequiresAuthenticationError implements Exception {}

class AccessDeniedError implements Exception {}

class NotFoundError implements Exception {}

class UnexpectedStatusCode implements Exception {
  UnexpectedStatusCode(this.statusCode);
  final int statusCode;
}

extension HttpResponse on http.Response {
  Exception toError() {
    switch (statusCode) {
      case 401:
        return RequiresAuthenticationError();
      case 403:
        return AccessDeniedError();
      case 404:
        return NotFoundError();
    }
    return UnexpectedStatusCode(statusCode);
  }
}

class TimuApiProvider extends InheritedWidget {
  const TimuApiProvider({
    super.key,
    required super.child,
    required this.api,
  });

  final TimuApi api;

  static TimuApiProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TimuApiProvider>();
  }

  static TimuApiProvider of(BuildContext context) {
    final TimuApiProvider? result = maybeOf(context);

    assert(result != null, 'No TimuApiProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant TimuApiProvider oldWidget) {
    return api != oldWidget.api;
  }
}

class MyProfileProvider extends InheritedWidget {
  const MyProfileProvider(
      {required this.profile, required super.child, super.key});
  final TimuObject profile;

  static MyProfileProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyProfileProvider>();
  }

  static MyProfileProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyProfileProvider>()!;
  }

  @override
  bool updateShouldNotify(MyProfileProvider oldWidget) {
    return oldWidget.profile.id != profile.id;
  }
}

class MyApiProvider extends StatelessWidget {
  const MyApiProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final apiProvider = TimuApiProvider.of(context);
    final api = apiProvider.api;

    if (api.accessToken == "") {
      return child;
    }

    return FutureBuilder<TimuObject>(
        future: api.me(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return TimuApiProvider(
                api: TimuApi(
                    host: api.host,
                    headers: api.headers,
                    accessToken: api.accessToken,
                    defaultNetwork: snapshot.data!.network),
                child:
                    MyProfileProvider(profile: snapshot.data!, child: child));
          } else if (snapshot.hasError) {
            return Container(
                color: Colors.red, alignment: Alignment.center, child: child);
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}

class TimuApi {
  TimuApi(
      {this.accessToken = '',
      this.defaultNetwork,
      required this.host,
      required this.headers,
      this.port = 443})
      : queryParameters = {
          "access_token": accessToken,
          ...(defaultNetwork != null
              ? {"network": defaultNetwork.toString()}
              : {})
        };

  final String accessToken;
  int? defaultNetwork;
  final String host;
  final int port;
  final Map<String, String> headers;

  final Map<String, String> queryParameters;

  TimuApi withToken(String token) {
    return TimuApi(
        host: host,
        headers: headers,
        accessToken: token,
        defaultNetwork: defaultNetwork,
        port: port);
  }

  Future<PreuploadedAttachmentReference> preupload(XFile file) async {
    return preuploadStream(name: file.name, stream: file.openRead());
  }

  Future<PreuploadedAttachmentReference> preuploadStream(
      {required String name, required Stream<List<int>> stream}) async {
    final response = await http.post(
        Uri(
            scheme: 'https',
            host: host,
            port: port,
            path: '/api/graph/+preupload',
            queryParameters: queryParameters),
        headers: headers,
        body: jsonEncode(<String, dynamic>{
          'name': name,
        }));

    if (response.statusCode != 200) {
      throw response.toError();
    }

    final requestData = jsonDecode(response.body);

    final String id = requestData['id'];
    final String url = requestData['url'];
    final String contentType = requestData['contentType'];

    final bodyBytes = stream;

    final upload = http.StreamedRequest('PUT', Uri.parse(url))
      ..headers.addAll(<String, String>{'Content-Type': contentType});

    bodyBytes.listen((event) {
      upload.sink.add(event);
    }, onDone: () {
      upload.sink.close();
    });

    final uploadResponse = await upload.send();

    if (uploadResponse.statusCode != 200) {
      throw response.toError();
    }

    return PreuploadedAttachmentReference(id: id, name: name);
  }

  Future<TimuObject> create(
      {required String type,
      int? network,
      TimuObjectUri? container,
      List<PreuploadedAttachmentReference>? preuploads,
      bool upsert = false,
      required Map<String, dynamic> data}) async {
    final req = <String, dynamic>{
      ...data,
      'network': network ?? defaultNetwork,
      'type': type,
      'container': container,
      'preuploadedAttachments': preuploads
    };

    final response = await http.post(
        Uri(
            scheme: 'https',
            host: host,
            port: port,
            path: '/api/graph/$type',
            queryParameters: <String, dynamic>{
              'upsert': upsert.toString(),
              ...queryParameters
            }),
        headers: headers,
        body: jsonEncode(req));

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw response.toError();
    }

    return TimuObject(jsonDecode(response.body));
  }

  TimuWebsocket createWebsocket(String url, String channel,
      {Map<String, dynamic>? metadata}) {
    return TimuWebsocket(
      apiRoot: host,
      url: url,
      accessToken: accessToken,
      network: defaultNetwork,
      channel: channel,
      metadata: metadata,
    );
  }

  Future<TimuObject> me() async {
    final response = await http.get(
        Uri(
            scheme: 'https',
            host: host,
            port: port,
            path: '/api/graph/me',
            queryParameters: queryParameters),
        headers: headers);

    if (response.statusCode != 200) {
      throw response.toError();
    }

    return TimuObject(jsonDecode(response.body));
  }

  Future<TimuObject> get(TimuObjectUri uri) async {
    final response = await http.get(
        Uri(
            scheme: 'https',
            host: host,
            port: port,
            path: uri,
            queryParameters: queryParameters),
        headers: headers);

    if (response.statusCode != 200) {
      throw response.toError();
    }

    return TimuObject(jsonDecode(response.body));
  }

  Future<Map<String, dynamic>> invoke({
    required String name,
    required String nounPath,
    bool public = false,
    Map<String, dynamic> params = const <String, dynamic>{},
    Map<String, dynamic> body = const <String, dynamic>{},
  }) async {
    final String method = public ? '+public' : '+invoke';
    final Map<String, dynamic> p = {...queryParameters};

    print('host: $host; path: $nounPath/$method/$name');

    final http.Response response = await http.post(
        Uri(
            scheme: 'https',
            host: host,
            port: port,
            path: '$nounPath/$method/$name',
            queryParameters: {...params, ...p}),
        headers: headers,
        body: json.encode(body));

    if (response.statusCode != 201 && response.statusCode != 200) {
      print(response.statusCode);
      throw response.toError();
    }

    if (response.body == '') {
      return {};
    }

    return json.decode(response.body);
  }
}

const missingAttachment = Attachment(name: '', size: 0, url: '');

class TimuObject {
  TimuObject(this.rawData);

  int get network {
    return rawData["network"]!.toInt();
  }

  String get id {
    return rawData["id"]!;
  }

  TimuObjectUri get url {
    return rawData["url"]!;
  }

  String get type {
    return rawData["type"]!;
  }

  TimuObject? get container {
    return rawData["container"]!;
  }

  DateTime get createdAt {
    return DateTime.parse(rawData["createdAt"]);
  }

  DateTime get updatedAt {
    return DateTime.parse(rawData["updatedAt"]);
  }

  TimuObjectUri get createdBy {
    return rawData["url"]!;
  }

  TimuObjectUri get updatedBy {
    return rawData["url"]!;
  }

  List<Attachment> getAttachments() {
    final attachments = <Attachment>[];
    final json = rawData["attachments"];

    if (json is List<Map<String, dynamic>>) {
      for (var j in json) {
        attachments.add(Attachment.fromJSON(j));
      }
    }
    return attachments;
  }

  final Map<String, dynamic> rawData;
}

class Attachment {
  const Attachment({required this.name, required this.url, required this.size});

  Attachment.fromJSON(Map<String, dynamic> json)
      : name = json["name"] as String,
        url = json["url"] as String,
        size = (json["size"] as double).toInt();

  final String name;
  final String url;
  final int size;
}

class PreuploadedAttachmentReference {
  PreuploadedAttachmentReference({required this.id, required this.name});

  final String id;
  String name;

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }
}

typedef TimuObjectUri = String;
