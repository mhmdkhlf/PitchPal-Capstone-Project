import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/main.dart';
import 'package:frontend_mobile/pages/review_player.dart';
import 'package:frontend_mobile/pages/view_player_profile.dart';
import 'package:dio/dio.dart';
import '../data/player.dart';
import '../constants.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({
    super.key,
    required this.friendId,
    required this.userId,
  });

  final String friendId;
  final String userId;

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
      builder: (context, friend) {
        if (friend.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Card(
              elevation: 3,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 3),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(width: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: friend.data!.imageByteArray != null
                                ? Image.memory(
                                    friend.data!.imageByteArray!,
                                    height: 30,
                                    width: 30,
                                  )
                                : Image.asset(
                                    defaultProfilePath,
                                    height: 30,
                                    width: 30,
                                  ),
                          ),
                          const SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              friend.data!.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                        ],
                      ),
                      const Divider(),
                      ButtonTheme(
                        child: ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              child: const Text('View Profile'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewPlayerProfile(
                                      player: friend.data!,
                                    ),
                                  ),
                                );
                              },
                            ),
                            ElevatedButton(
                              child: const Text('Review Player'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReviewPlayer(
                                      player: friend.data!,
                                      reviewerId: userId,
                                    ),
                                  ),
                                );
                              },
                            ),
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
        if (friend.hasError) {
          return Center(child: Text(friend.error.toString()));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
