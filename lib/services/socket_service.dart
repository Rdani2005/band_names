import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  online,
  offline,
  connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;

  ServerStatus get serverStatus => _serverStatus;

  late IO.Socket _socket;

  IO.Socket get socket => _socket;

  set serverStatus(ServerStatus serverStatus) {
    _serverStatus = serverStatus;
    notifyListeners();
  }

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    _socket = IO.io('http://10.0.2.2:8080/', {
      'transports': ['websocket'],
      'autoConnect': true,
    });
    socket.on('connect', (_) {
      serverStatus = ServerStatus.online;
    });
    socket.on('disconnect', (_) {
      serverStatus = ServerStatus.offline;
    });
    socket.on('message', (payload) {
      print("Server message: $payload");
    });
  }
}
