import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:frontend_mobile/pages/reservation_matches.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'create_team.dart';
import 'view_player_profile.dart';
import 'view_team_profile.dart';
import '../components/response_dialog_box.dart';
import '../components/friend_card.dart';
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
  List<Team>? teamsPlayerInvolvedIn;
  List<String>? friendsIDs;
  final TextEditingController friendIdController = TextEditingController();
  final TextEditingController sportCenterSearchController =
      TextEditingController();
  final TextEditingController teamSearchController = TextEditingController();
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  final DateFormat timeFormat = DateFormat.Hm();

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

  Future<List<String>> getFriendsIds() async {
    final Dio dio = Dio();
    final friendsResponse = await dio.get(
      '$apiRoute/getFriends/${widget.player.playerID}',
    );
    List<dynamic> friendsIdsData = friendsResponse.data;
    friendsIDs = friendsIdsData.map((e) => e as String).toList();
    return friendsIDs!;
  }

  Future<List<Team>> getTeams() async {
    final Dio dio = Dio();
    final response = await dio.get(
      '$apiRoute/getAPlayersTeams/${widget.player.playerID}',
    );
    teamsPlayerInvolvedIn =
        (response.data as List).map((data) => Team.fromJson(data)).toList();
    return teamsPlayerInvolvedIn!;
  }

  AppBar getAppBar() {
    if (_selectNavBarItemIndex == 0) {
      return AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Reservation & Matches',
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
          controller: sportCenterSearchController,
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
                        .contains(
                            sportCenterSearchController.text.toLowerCase()))
                    .toList(),
              );
            },
          ),
          Tooltip(
            message: 'Sort By Distance',
            child: IconButton(
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
          ),
          Tooltip(
            message: 'Sort by highest Ratings',
            child: IconButton(
              icon: const Icon(Icons.high_quality),
              onPressed: () {
                if (sportCenters == null) return;
                setState(
                  () {
                    sportCenters!.sort((a, b) =>
                        a.facilityQualityAverageRating!
                            .compareTo(b.facilityQualityAverageRating as num) *
                        -1);
                    allSportCenters!.sort((a, b) =>
                        a.facilityQualityAverageRating!
                            .compareTo(b.facilityQualityAverageRating as num) *
                        -1);
                  },
                );
              },
            ),
          ),
          const SizedBox(width: 20)
        ],
      );
    } else if (_selectNavBarItemIndex == 2) {
      return AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          style: const TextStyle(
            color: kLightColor,
            fontSize: 18,
          ),
          controller: friendIdController,
          cursorColor: kPrimaryColor,
          decoration: const InputDecoration(
            fillColor: kDarkGreen,
            hintText: 'Add Friend by their ID',
            hintStyle: TextStyle(color: kLighterDark),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () async {
              final String idInput = friendIdController.text;
              if (idInput.length == 7 &&
                  int.tryParse(idInput.substring(0, 3)) != null &&
                  int.tryParse(idInput.substring(4, 7)) != null &&
                  idInput[3] == '-') {
                final Dio dio = Dio();
                try {
                  final response = await dio.get(
                    '$apiRoute/getPlayer/$idInput',
                  );
                  if (response.data != null) {
                    final Player player = Player.fromJson(response.data);
                    try {
                      final response = await dio.post(
                        '$apiRoute/addFriend',
                        data: {
                          'playerID1': widget.player.playerID,
                          'playerID2': idInput
                        },
                      );
                      if (response.statusCode == 200) {
                        friendsIDs = null;
                        _onItemTapped(0);
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) => ResponseDialogBox(
                              text:
                                  'Congrats you added ${player.name} as a friend',
                            ),
                          );
                        }
                      }
                    } on DioError catch (e) {
                      throw Exception(e.stackTrace);
                    }
                  } else {
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => const ResponseDialogBox(
                          text: 'No player has the ID you specified',
                        ),
                      );
                    }
                  }
                } on DioError catch (e) {
                  throw Exception(e.stackTrace);
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) => const ResponseDialogBox(
                    text:
                        'Invalid player IDs format\n(should be like -> 000-000)',
                  ),
                );
              }
            },
          ),
          const SizedBox(width: 20),
        ],
      );
    } else if (_selectNavBarItemIndex == 3) {
      return AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          style: const TextStyle(
            color: kLightColor,
            fontSize: 18,
          ),
          controller: teamSearchController,
          cursorColor: kPrimaryColor,
          decoration: const InputDecoration(
            fillColor: kDarkGreen,
            hintText: "Search for a team by it's name",
            hintStyle: TextStyle(color: kLighterDark),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final String teamNameInput = teamSearchController.text;
              final Dio dio = Dio();
              try {
                final response = await dio.get(
                  '$apiRoute/getTeamByName/$teamNameInput',
                );
                if (response.data != null) {
                  Team team = Team.fromJson(response.data);
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewTeamProfile(
                          team: team,
                          userId: widget.player.playerID!,
                        ),
                      ),
                    );
                  }
                } else {
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) => const ResponseDialogBox(
                        text: "No team has the name you're searching for",
                      ),
                    );
                  }
                }
              } on DioError catch (e) {
                throw Exception(e.stackTrace);
              }
            },
          ),
          const SizedBox(width: 20),
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
      return ReservationsAndMatches(player: widget.player);
    } else if (_selectNavBarItemIndex == 1) {
      if (sportCenters != null) {
        return _getSportCentersBody(sportCenters!);
      }
      return FutureBuilder(
        future: getSportCenters(),
        builder: (context, sportCenters) {
          if (sportCenters.hasData) {
            return _getSportCentersBody(sportCenters.data!);
          }
          if (sportCenters.hasError) {
            return Center(child: Text(sportCenters.error.toString()));
          }
          return const Center(child: CircularProgressIndicator());
        },
      );
    } else if (_selectNavBarItemIndex == 2) {
      if (friendsIDs != null) {
        return _getFriendsBody(friendsIDs!);
      }
      return FutureBuilder(
        future: getFriendsIds(),
        builder: (context, friendsIDs) {
          if (friendsIDs.hasData) {
            return _getFriendsBody(friendsIDs.data!);
          }
          if (friendsIDs.hasError) {
            return Center(child: Text(friendsIDs.error.toString()));
          }
          return const Center(child: CircularProgressIndicator());
        },
      );
    } else if (_selectNavBarItemIndex == 3) {
      if (teamsPlayerInvolvedIn != null) {
        return _getTeamsBody(teamsPlayerInvolvedIn!);
      }
      return FutureBuilder(
        future: getTeams(),
        builder: (context, teams) {
          if (teams.hasData) {
            return _getTeamsBody(teams.data!);
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

  Widget _getSportCentersBody(List<SportCenter> sportCenters) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: sportCenters.length,
      itemBuilder: (context, index) => SportCenterCard(
        sportCenter: sportCenters[index],
        player: widget.player,
      ),
    );
  }

  Widget _getFriendsBody(List<String> friendsIDs) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 50),
          const Text(
            'Your Friends',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: friendsIDs.length,
            itemBuilder: (context, index) => FriendCard(
              friendId: friendsIDs[index],
              userId: widget.player.playerID!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getTeamsBody(List<Team> teams) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              'Your Teams',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: teams.length,
              itemBuilder: (context, index) => TeamCard(
                team: teams[index],
                playerId: widget.player.playerID!,
              ),
            )
          ],
        ),
      ),
    );
  }

  FloatingActionButton? getFloatingActionButton() {
    if (_selectNavBarItemIndex == 3) {
      return FloatingActionButton(
        onPressed: routeToCreateTeamForm,
        child: const Icon(Icons.group_add),
      );
    }
    return null;
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
      floatingActionButton: getFloatingActionButton(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        selectedFontSize: 11,
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
            icon: Icon(Icons.people_outline),
            label: 'Friends',
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
