import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'view_player_profile.dart';
import '../components/sport_center_card.dart';
import '../data/field.dart';
import '../data/player.dart';
import '../data/sport_center.dart';
import '../constants.dart';

class PlayerHomePage extends StatefulWidget {
  const PlayerHomePage({
    super.key,
    required this.player,
  });

  final Player player;

  @override
  State<PlayerHomePage> createState() => _PlayerHomePageState();
}

class _PlayerHomePageState extends State<PlayerHomePage> {
  bool isAscending = false;
  int _selectNavBarItemIndex = 0;
  List<SportCenter>? allSportCenters;
  List<SportCenter>? sportCenters;
  final TextEditingController searchController = TextEditingController();

  void _onItemTapped(int index) =>
      setState(() => _selectNavBarItemIndex = index);

  Future<List<SportCenter>> getSportCenters() async {
    final Dio dio = Dio();
    final response = await dio.get(
      '$apiRoute/getAllSportCenters',
    );
    sportCenters = (response.data as List)
        .map((data) => SportCenter.fromJson(data))
        .toList();
    for (SportCenter sportCenter in sportCenters!) {
      final imageResponse = await dio.get(
        '$apiRoute/getSportCenterProfilePictureByName/${sportCenter.name}',
      );
      if (imageResponse.data != null) {
        List<dynamic> dynamicList = imageResponse.data['img']['data']['data'];
        List<int> intList = dynamicList.map((e) => e as int).toList();
        Uint8List imageData = Uint8List.fromList(intList);
        sportCenter.imageByteArray = imageData;
      }
      final fieldsResponse = await dio.get(
        '$apiRoute/getFields/${sportCenter.name}',
      );
      List<dynamic> fieldsData = fieldsResponse.data;
      List<Field> fields = fieldsData.map((e) => Field.fromJson(e)).toList();
      fields.sort((a, b) => a.fieldNumber.compareTo(b.fieldNumber));
      sportCenter.fields = fields;
      final distanceResponse = await dio.post(
        '$apiRoute/calculate_distance',
        data: {
          "player_lat": widget.player.location.latitude,
          "player_lon": widget.player.location.longitude,
          "facility_lat": sportCenter.location.latitude,
          "facility_lon": sportCenter.location.longitude
        },
      );
      sportCenter.distanceFromPlayer = double.parse(distanceResponse.data['d']);
    }
    allSportCenters = sportCenters;
    return sportCenters!;
  }

  AppBar getAppBar() {
    if (_selectNavBarItemIndex == 0) {
      return AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Home Page',
            style: TextStyle(
              color: kLightColor,
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    } else if (_selectNavBarItemIndex == 1) {
      return AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          style: const TextStyle(
            color: kLightColor,
            fontSize: 18,
          ),
          controller: searchController,
          cursorColor: kPrimaryColor,
          decoration: const InputDecoration(
            fillColor: kDarkGreen,
            hintText: 'Search for sports centers',
            hintStyle: TextStyle(color: kLighterDark),
          ),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(
                  () => sportCenters = allSportCenters!
                      .where((sportCenter) => sportCenter.name
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase()))
                      .toList(),
                );
              }),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              setState(
                () {
                  isAscending = !isAscending;
                  if (isAscending) {
                    sportCenters!.sort(
                      (a, b) => a.distanceFromPlayer!
                          .compareTo(b.distanceFromPlayer as num),
                    );
                    allSportCenters!.sort(
                      (a, b) => a.distanceFromPlayer!
                          .compareTo(b.distanceFromPlayer as num),
                    );
                  } else {
                    sportCenters!.sort(
                      (a, b) =>
                          a.distanceFromPlayer!
                              .compareTo(b.distanceFromPlayer as num) *
                          -1,
                    );
                    allSportCenters!.sort(
                      (a, b) =>
                          a.distanceFromPlayer!
                              .compareTo(b.distanceFromPlayer as num) *
                          -1,
                    );
                  }
                },
              );
            },
          ),
        ],
      );
    } else {
      return AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Player Profile',
            style: TextStyle(
              color: kLightColor,
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    }
  }

  Widget getBody() {
    if (_selectNavBarItemIndex == 0) {
      return Center(
        child: Text(
          'Welcome ${widget.player.name}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    } else if (_selectNavBarItemIndex == 1) {
      if (sportCenters != null) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: sportCenters!.length,
          itemBuilder: (context, index) => SportCenterCard(
            sportCenter: sportCenters![index],
          ),
        );
      }
      return FutureBuilder(
        future: getSportCenters(),
        builder: (context, sportCenters) {
          if (sportCenters.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: sportCenters.data!.length,
              itemBuilder: (context, index) => SportCenterCard(
                sportCenter: sportCenters.data![index],
              ),
            );
          }
          if (sportCenters.hasError) {
            return Center(child: Text(sportCenters.error.toString()));
          }
          return const Center(child: CircularProgressIndicator());
        },
      );
    } else {
      return ViewPlayerProfile(player: widget.player);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Sport-Centers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectNavBarItemIndex,
        selectedItemColor: kDarkColor,
        onTap: _onItemTapped,
        elevation: 5,
      ),
    );
  }
}
