import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'create_team.dart';
import 'view_player_profile.dart';
import '../components/sport_center_card.dart';
import '../components/team_card.dart';
import '../data/field.dart';
import '../data/player.dart';
import '../data/sport_center.dart';
import '../data/team.dart';
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
  List<Team>? allTeams;
  List<Team>? teamsPlayerInvolvedIn;
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

  Future<List<Team>> getTeams() async {
    final Dio dio = Dio();
    final response = await dio.get(
      '$apiRoute/getAllTeams',
    );
    allTeams =
        (response.data as List).map((data) => Team.fromJson(data)).toList();
    return allTeams!;
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
              if (sportCenters == null) return;
              setState(
                () => sportCenters = allSportCenters!
                    .where((sportCenter) => sportCenter.name
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase()))
                    .toList(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              if (sportCenters == null) return;
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
                    sportCenters!.sort((a, b) =>
                        a.distanceFromPlayer!
                            .compareTo(b.distanceFromPlayer as num) *
                        -1);
                    allSportCenters!.sort((a, b) =>
                        a.distanceFromPlayer!
                            .compareTo(b.distanceFromPlayer as num) *
                        -1);
                  }
                },
              );
            },
          ),
        ],
      );
    } else if (_selectNavBarItemIndex == 2) {
      return AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Your Teams',
            style: TextStyle(
              color: kLightColor,
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
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
          'Hello ${widget.player.name}!',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
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
    } else if (_selectNavBarItemIndex == 2) {
      if (teamsPlayerInvolvedIn != null) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: teamsPlayerInvolvedIn!.length,
          itemBuilder: (context, index) => TeamCard(
            team: teamsPlayerInvolvedIn![index],
            playerId: widget.player.playerID!,
          ),
        );
      }
      return FutureBuilder(
        future: getTeams(),
        builder: (context, teams) {
          if (teams.hasData) {
            teamsPlayerInvolvedIn = teams.data!.where((team) {
              return team.captainId == widget.player.playerID ||
                  team.playerIds.contains(widget.player.playerID);
            }).toList();
            return ListView.builder(
              shrinkWrap: true,
              itemCount: teamsPlayerInvolvedIn!.length,
              itemBuilder: (context, index) => TeamCard(
                team: teamsPlayerInvolvedIn![index],
                playerId: widget.player.playerID!,
              ),
            );
          }
          if (teams.hasError) {
            return Center(child: Text(teams.error.toString()));
          }
          return const Center(child: CircularProgressIndicator());
        },
      );
    } else {
      return ViewPlayerProfile(player: widget.player);
    }
  }

  void routeToCreateTeamForm() {
    teamsPlayerInvolvedIn = null;
    _onItemTapped(0);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTeam(captain: widget.player),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: getBody(),
      floatingActionButton: _selectNavBarItemIndex == 2
          ? FloatingActionButton(
              onPressed: routeToCreateTeamForm,
              child: const Icon(Icons.group_add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        selectedFontSize: 14,
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
            icon: Icon(Icons.groups_2),
            label: 'Teams',
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
