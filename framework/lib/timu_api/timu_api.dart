/// TIMU Flutter API

library timu_api;

import 'dart:convert';
import 'package:cross_file/cross_file.dart';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

part 'mock_timu_api.dart';

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
    }
    return UnexpectedStatusCode(statusCode);
  }
}

class TimuApi {
  TimuApi(
      {required this.defaultNetwork,
      required this.host,
      required this.headers,
      this.port = 443});

  final int defaultNetwork;
  final String host;
  final int port;
  final Map<String, String> headers;

  Future<PreuploadedAttachmentReference> preupload(XFile file) async {
    return preuploadStream(name: file.name, stream: file.openRead());
  }

  Future<PreuploadedAttachmentReference> preuploadStream(
      {required String name, required Stream<List<int>> stream}) async {
    var response = await http.post(
        Uri(
            scheme: "https",
            host: host,
            port: port,
            path: "/api/graph/+preupload"),
        headers: headers,
        body: jsonEncode(<String, dynamic>{
          "name": name,
        }));

    if (response.statusCode != 200) {
      throw response.toError();
    }

    var requestData = jsonDecode(response.body);

    var id = requestData["id"] as String;
    var url = requestData["url"] as String;
    var contentType = requestData["contentType"] as String;

    var bodyBytes = stream;

    var upload = http.StreamedRequest("PUT", Uri.parse(url))
      ..headers.addAll(<String, String>{"Content-Type": contentType});

    bodyBytes.listen((event) {
      upload.sink.add(event);
    }, onDone: () {
      upload.sink.close();
    });

    var uploadResponse = await upload.send();

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
    var req = <String, dynamic>{
      ...data,
      "network": network ?? defaultNetwork,
      "type": type,
      "container": container,
      "preuploadedAttachments": preuploads
    };

    var response = await http.post(
        Uri(
            scheme: "https",
            host: host,
            port: port,
            path: "/api/graph/$type",
            queryParameters: <String, dynamic>{"upsert": upsert.toString()}),
        headers: headers,
        body: jsonEncode(req));

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw response.toError();
    }

    return TimuObject(jsonDecode(response.body));
  }

  Future<TimuObject> get(TimuObjectUri uri) async {
    var response = await http.get(
        Uri(scheme: "https", host: host, port: port, path: uri),
        headers: headers);

    if (response.statusCode != 200) {
      throw response.toError();
    }

    return TimuObject(jsonDecode(response.body));
  }

  // Map<String, dynamic> invoke({
  //   required TimuObject object,
  //   required String name,
  //   bool public = false,
  //   Map<String, dynamic> params = Map<String, dynamic>}) {
  // }
}

class TimuObject {
  TimuObject(this.rawData);

  String get id {
    return rawData["id"]!;
  }

  TimuObjectUri get url {
    return rawData["url"]!;
  }

  String get type {
    return rawData["url"]!;
  }

  TimuObjectUri? get container {
    return rawData["url"]!;
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
    var attachments = <Attachment>[];
    var json = rawData["attachments"];

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
