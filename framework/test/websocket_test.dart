import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:rxdart/rxdart.dart';

// wss://usa.timu.life/api/realtime/watch?url=/api/graph/core:user/f0a6e008-2e6e-494c-b1bc-fed9df61ef30&channel=default&metadata={}&token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NzUyMDY2NzksImlzcyI6Ii9hcGkvaWRlbnRpdHkvZXhjaGFuZ2UiLCJzdWIiOiJpZGVudGl0eS85ZTk1Yjc3Yi0yNWM2LTQzMmItYTAzZS1lMGQyZWVkNzgxYTEifQ.NdYiwoT9O6gTaDLWpFDJtpPIypkYoX3_4sy7mZmzZFE&options=1197
// wss://usa.timu.life/api/realtime/watch?url=/api/graph/core:user/c5d28b7c-d57d-4dc3-85d4-74a9398b121e&channel=default&metadata={}&token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NzUxOTMwNjEsImlzcyI6Ii9hcGkvaWRlbnRpdHkvZXhjaGFuZ2UiLCJzdWIiOiJpZGVudGl0eS9iNTBjODgwMC03Mzc1LTQ1M2QtODg4MC0wNDVlMmVjY2E1NDkifQ.vKGmHyZkaWTgooPJeLQBVfzMk-MFc5d9eqgBAE4Dnkk&options=1433

const url1 =
    'wss://usa.timu.life/api/realtime/watch?url=/api/graph/core:user/f0a6e008-2e6e-494c-b1bc-fed9df61ef30&channel=default&metadata={}&token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NzUyMDY2NzksImlzcyI6Ii9hcGkvaWRlbnRpdHkvZXhjaGFuZ2UiLCJzdWIiOiJpZGVudGl0eS85ZTk1Yjc3Yi0yNWM2LTQzMmItYTAzZS1lMGQyZWVkNzgxYTEifQ.NdYiwoT9O6gTaDLWpFDJtpPIypkYoX3_4sy7mZmzZFE&options=1197';
const url2 =
    'wss://usa.timu.life/api/realtime/watch?url=/api/graph/core:user/c5d28b7c-d57d-4dc3-85d4-74a9398b121e&channel=default&metadata={}&token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NzUxOTMwNjEsImlzcyI6Ii9hcGkvaWRlbnRpdHkvZXhjaGFuZ2UiLCJzdWIiOiJpZGVudGl0eS9iNTBjODgwMC03Mzc1LTQ1M2QtODg4MC0wNDVlMmVjY2E1NDkifQ.vKGmHyZkaWTgooPJeLQBVfzMk-MFc5d9eqgBAE4Dnkk&options=1433';

// void main() {
//   var resBody = {};
//   resBody["email"] = "employerA@gmail.com";
//   resBody["password"] = "admin123";
//   var user = {};
//   user["user"] = resBody;
//   String str = json.encode(user);
//   print(str);
// }

Future<String> printMessages(Stream<dynamic> stream) async {
  await for (final value in stream) {
    print('jkkk value $value');
  }

  return "Done";
}

void main() async {
    final msg = {'ListClients': {}};
    final strMsg = json.encode(msg);

    final uri1 = Uri.parse(url1);
    final uri2 = Uri.parse(url2);

    print('Starting uri1 $uri1, $strMsg');
    print('Starting uri2 $uri2, $strMsg');

    final ws1 = WebSocketChannel.connect(uri1);
    final ws2 = WebSocketChannel.connect(uri2);

    ws1.stream
            .takeUntil(Stream.fromFuture(Future.delayed(Duration(seconds: 4))))
            .listen((res) {
                print('res1 $res');
            }, onDone: () {
                ws1.sink.close();
            });

    ws2.stream
            .takeUntil(Stream.fromFuture(Future.delayed(Duration(seconds: 4))))
            .listen((res) {
                print('res2 $res');
            }, onDone: () {
                ws2.sink.close();
            });


    ws1.sink.add(strMsg);

    await Future.delayed(Duration(seconds: 2));

    ws2.sink.add(strMsg);

    print('done');
}
