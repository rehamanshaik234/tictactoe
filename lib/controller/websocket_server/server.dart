import 'dart:io';

import 'package:network_info_plus/network_info_plus.dart';

class WebSocketServer{

  void createChannel()async{
    NetworkInfo info=NetworkInfo();
    final ipAddress = (await info.getWifiIP())!;
    print(await info.getWifiIP());
    late WebSocket webSocket;
    ///adding local Ip address to run server
    final server2 = await HttpServer.bind(ipAddress,8080,shared: true);
    print('@@@@@@@@@@@@@@@@@@@@Server running on port ${server2.address}');
    try{
      await for (HttpRequest request in server2) {
        webSocket = await WebSocketTransformer.upgrade(request);
        print('WebSocket request received');
        ///listening to incoming data
        webSocket.listen((message) {
          print('========================Received message: $message =============================');

          if(message is String) {

          } else {
            ///writing audio data to file

          }
        });
      }}catch(e){
      print(e);
    }

  }
}