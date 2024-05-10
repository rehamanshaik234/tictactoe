
import 'package:flutter/material.dart';
import 'package:playspace/controller/websocket_server/server.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Client extends StatefulWidget {
  const Client({super.key});

  @override
  State<Client> createState() => _ClientState();
}

class _ClientState extends State<Client> {

  @override
  void initState() {
    connectToSocket();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(

    );
  }

  void connectToSocket() async{
    WebSocketChannel webSocket=WebSocketChannel.connect(Uri.parse('ws://192.168.1.25:8080'),);

    webSocket.sink.add('Hello World');
  }

}
