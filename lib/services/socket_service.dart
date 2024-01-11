import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:chat/global/environment.dart';

enum ServerStatus {
  onLine,
  offLine,
  connecting
}


class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  
  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;



  void connect() async {

    final token = await AuthService.getToken();

    // Dart client
    _socket = IO.io( Environment.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders' : {
        'x-token' : token
      }
    });

    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.onLine;
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.offLine;
      notifyListeners();
    });

  }

  void disconnect() {
    _socket.disconnect();
  }

}