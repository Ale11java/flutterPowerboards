part of 'timu_api.dart';

final _uuid = Uuid();

class MockTimuApi implements TimuApi {
  MockTimuApi(
      {required this.defaultNetwork,
      required this.host,
      required this.headers,
      this.port = 443});

  // TODO remove these props and extract an actual interface class
  @override
  final int defaultNetwork;
  @override
  final String host;
  @override
  final int port;
  @override
  final Map<String, String> headers;

  final objects = <String, TimuObject>{};

  @override
  Future<TimuObject> create(
      {required String type,
      int? network,
      TimuObjectUri? container,
      List<PreuploadedAttachmentReference>? preuploads,
      bool upsert = false,
      required Map<String, dynamic> data}) {
    final o = TimuObject({
      'id': _uuid.v4(),
      ...data,
    });
    objects[o.id] = o;
    return Future<TimuObject>(() => o);
  }

  @override
  Future<PreuploadedAttachmentReference> preupload(XFile file) {
    throw UnimplementedError();
  }

  @override
  Future<PreuploadedAttachmentReference> preuploadStream(
      {required String name, required Stream<List<int>> stream}) {
    throw UnimplementedError();
  }

  @override
  Future<TimuObject> get(TimuObjectUri uri) async {
    final id = uri.split('/').last;
    final o = objects[id];
    if (o != null) {
      return Future<TimuObject>(() => o);
    }
    throw NotFoundError();
  }
}
