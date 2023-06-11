import 'package:band_names/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Server Status: ${socketService.serverStatus}")],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          socketService.socket.emit("emmit-message",
              {"name": "Danny", "message": "Hello from Flutter"});
        },
        child: const Icon(Icons.message),
      ),
    );
  }
}
