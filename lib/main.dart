import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names/services/services.dart';

import 'package:band_names/screens/screens.dart';

void main() => runApp(const SocketAppState());

class SocketAppState extends StatelessWidget {
  const SocketAppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService()),
      ],
      child: const SocketApp(),
    );
  }
}

class SocketApp extends StatelessWidget {
  const SocketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: 'home',
      routes: {
        'home': (_) => const HomeScreen(),
        'status': (_) => const StatusScreen(),
      },
    );
  }
}
