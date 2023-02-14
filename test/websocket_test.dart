import 'package:flutter_test/flutter_test.dart' show Future, Timeout, test;
import 'package:web_socket_channel/web_socket_channel.dart';

// wss://usa.timu.life/api/realtime/watch?url=/api/graph/core:user/f0a6e008-2e6e-494c-b1bc-fed9df61ef30&channel=default&metadata={}&token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NzUyMDY2NzksImlzcyI6Ii9hcGkvaWRlbnRpdHkvZXhjaGFuZ2UiLCJzdWIiOiJpZGVudGl0eS85ZTk1Yjc3Yi0yNWM2LTQzMmItYTAzZS1lMGQyZWVkNzgxYTEifQ.NdYiwoT9O6gTaDLWpFDJtpPIypkYoX3_4sy7mZmzZFE&options=1197
// wss://usa.timu.life/api/realtime/watch?url=/api/graph/core:user/c5d28b7c-d57d-4dc3-85d4-74a9398b121e&channel=default&metadata={}&token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NzUxOTMwNjEsImlzcyI6Ii9hcGkvaWRlbnRpdHkvZXhjaGFuZ2UiLCJzdWIiOiJpZGVudGl0eS9iNTBjODgwMC03Mzc1LTQ1M2QtODg4MC0wNDVlMmVjY2E1NDkifQ.vKGmHyZkaWTgooPJeLQBVfzMk-MFc5d9eqgBAE4Dnkk&options=1433

const url1 =
    'wss://usa.timu.life/api/realtime/watch?url=/api/graph/core:user/f0a6e008-2e6e-494c-b1bc-fed9df61ef30&channel=default&metadata={}&token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NzUyMDY2NzksImlzcyI6Ii9hcGkvaWRlbnRpdHkvZXhjaGFuZ2UiLCJzdWIiOiJpZGVudGl0eS85ZTk1Yjc3Yi0yNWM2LTQzMmItYTAzZS1lMGQyZWVkNzgxYTEifQ.NdYiwoT9O6gTaDLWpFDJtpPIypkYoX3_4sy7mZmzZFE&options=1197';
const url2 =
    'wss://usa.timu.life/api/realtime/watch?url=/api/graph/core:user/c5d28b7c-d57d-4dc3-85d4-74a9398b121e&channel=default&metadata={}&token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NzUxOTMwNjEsImlzcyI6Ii9hcGkvaWRlbnRpdHkvZXhjaGFuZ2UiLCJzdWIiOiJpZGVudGl0eS9iNTBjODgwMC03Mzc1LTQ1M2QtODg4MC0wNDVlMmVjY2E1NDkifQ.vKGmHyZkaWTgooPJeLQBVfzMk-MFc5d9eqgBAE4Dnkk&options=1433';

Future<String> printMessages(Stream<dynamic> stream) async {
  await for (final value in stream) {
    print('jkkk value $value');
  }

  return "Done";
}

void main() async {
  test(
    'Open WebSock',
    () async {
      final uri1 = Uri.parse(url1);
      final uri2 = Uri.parse(url2);

      print('Starting uri1 $uri1');
      print('Starting uri2 $uri2');

      final ws1 = WebSocketChannel.connect(uri1);
      final ws2 = WebSocketChannel.connect(uri2);

      final out = await Future.wait([
        printMessages(ws1.stream),
        printMessages(ws2.stream),
      ]);

      print('Starting $out');
    },
    timeout: const Timeout(Duration(seconds: 10)),
  );
}
