import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'data/player.dart';

final dio = Dio();
final String apiRoute = Platform.isAndroid
    ? 'http://10.0.2.2:5000/api'
    : 'http://localhost:5000/api';

Future<Player> getPlayer1() async {
  final response = await dio.get('$apiRoute/getPlayer/277-612');
  if (response.statusCode == 200) {
    return Player.fromJson(response.data);
  } else {
    throw Exception('failed to get sport center reviews');
  }
}

void main() async {
  // ignore_for_file: avoid_print
  print(apiRoute);
  final Player player1 = await getPlayer1();
  print(player1);
  runApp(MyApp(player1: player1));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.player1});

  final Player player1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PlayerPage(title: 'Player1 info', player1: player1),
    );
  }
}

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key, required this.title, required this.player1});

  final String title;
  final Player player1;
  @override
  State<PlayerPage> createState() => _PlayerPage();
}

class _PlayerPage extends State<PlayerPage> {
  late String player1Info;

  @override
  void initState() {
    super.initState();
    player1Info = widget.player1.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(
          player1Info,
        ),
      ),
    );
  }
}
