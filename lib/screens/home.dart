import 'dart:io';

import 'package:band_names/models/models.dart';
import 'package:band_names/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = <Band>[];

  @override
  void initState() {
    super.initState();
    final socketProvider = Provider.of<SocketService>(context, listen: false);
    socketProvider.socket.on('active-bands', (payload) {
      bands = (payload as List).map((band) => Band.fromMap(band)).toList();
      setState(() {});
    });
  }

  @override
  void dispose() {
    final socketProvider = Provider.of<SocketService>(context, listen: false);
    socketProvider.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketProvider = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Band Names',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            // child: Icon(Icons.check_circle_outline, color: Colors.blue[300],),
            child: socketProvider.serverStatus == ServerStatus.online
                ? Icon(
                    Icons.check_circle_outline,
                    color: Colors.blue[300],
                  )
                : Icon(
                    Icons.offline_bolt,
                    color: Colors.red[300],
                  ),
          )
        ],
      ),
      body: Column(
        children: [
          _showGraf(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (_, i) => _BandTile(band: bands[i]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();

    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text("New band"),
              content: CupertinoTextField(
                controller: textController,
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => addBandToList(textController.text),
                  isDefaultAction: true,
                  child: const Text("Add"),
                ),
                CupertinoDialogAction(
                  onPressed: () => Navigator.pop(context),
                  isDestructiveAction: true,
                  child: const Text("Dismiss"),
                ),
              ],
            );
          });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("New band"),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                onPressed: () => addBandToList(textController.text),
                elevation: 5,
                textColor: Colors.blue,
                child: const Text("Add"),
              ),
            ],
          );
        },
      );
    }
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      final socketProvider = Provider.of<SocketService>(context, listen: false);
      socketProvider.socket.emit("create_band", {"name": name});
    }

    Navigator.pop(context);
  }

  Widget _showGraf() {
    Map<String, double> dataMap = {};
    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });

    return Container(
      width: double.infinity,
      height: 200,
      child: PieChart(
        animationDuration: Duration(milliseconds: 800),
        chartValuesOptions:
            const ChartValuesOptions(showChartValuesInPercentage: true),
        dataMap: dataMap,
      ),
    );
  }
}

class _BandTile extends StatelessWidget {
  const _BandTile({
    required this.band,
  });

  final Band band;

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        socketService.socket.emit('delete_band', {'band_id': band.id});
      },
      background: Container(
        padding: const EdgeInsets.only(left: 8),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Delete Band",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      child: ListTile(
        onTap: () {
          socketService.socket.emit('vote-band', {'band_id': band.id});
        },
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing: Text(
          band.votes.toString(),
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
