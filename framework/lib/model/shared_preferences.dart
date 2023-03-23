import 'package:android_content_provider/android_content_provider.dart';

class SharedPreferences {
  static const String providerAuthority = 'com.timu.sharedpreferences';
  static final Uri providerUrl =
      Uri.parse('content://$providerAuthority/query');

  Future<String?> read({required String key}) async {
    final cursor = await AndroidContentResolver.instance.query(
      uri: providerUrl.toString(),
    );

    String? value;

    if (cursor != null) {
      try {
        final end =
            (await cursor.batchedGet().getCount().commit()).first! as int;
        final batch = cursor.batchedGet().getString(0).getString(1);

        late List<List<Object?>> preferencesData;

        preferencesData = await batch.commitRange(0, end);

        final preferences = preferencesData
            .map((data) => SharePreferenceData.fromCursorData(data))
            .toList();

        for (final SharePreferenceData d in preferences) {
          if (d.key == key) {
            value = d.value;
          }
        }
      } finally {
        cursor.close();
      }
    }

    return value;
  }
}

class SharePreferenceData {
  const SharePreferenceData({
    required this.key,
    required this.value,
  });

  factory SharePreferenceData.fromCursorData(List<Object?> data) =>
      SharePreferenceData(
        key: data[0]! as String,
        value: data[1]! as String,
      );

  final String key;
  final String value;
}
