import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/pages/view_player_profile.dart';
import 'package:dio/dio.dart';
import '../data/player.dart';
import '../constants.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({
    super.key,
    required this.friendId,
  });

  final String friendId;

  Future<Player> getPlayer() async {
    final Dio dio = Dio();
    try {
      final response = await dio.get(
        '$apiRoute/getPlayer/$friendId',
      );
      Player player = Player.fromJson(response.data);
      final imageResponse = await dio.get(
        '$apiRoute/getProfilePictureByEmail/${player.email}',
      );
      if (imageResponse.data != null) {
        List<dynamic> dynamicList = imageResponse.data['img']['data']['data'];
        List<int> intList = dynamicList.map((e) => e as int).toList();
        Uint8List imageData = Uint8List.fromList(intList);
        player.imageByteArray = imageData;
      }
      return player;
    } on DioError catch (e) {
      throw Exception(e.stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPlayer(),
      builder: (context, player) {
        if (player.hasData) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              elevation: 3,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(width: 5),
                      Text(
                        player.data!.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 5),
                      ButtonTheme(
                        child: ButtonBar(
                          children: [
                            ElevatedButton(
                              child: const Text('View Profile'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewPlayerProfile(
                                      player: player.data!,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 5),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                ],
              ),
            ),
          );
        }
        if (player.hasError) {
          return Center(child: Text(player.error.toString()));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
