import 'package:flutter/material.dart';
import 'view_player_profile.dart';
import '../data/player.dart';
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
  int _selectNavBarItemIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectNavBarItemIndex = index;
    });
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
    }
    if (_selectNavBarItemIndex == 1) {
      // TODO: Connect Search to backend by getAllSportCenters API call
      // TODO: after connecting to backend fix the look and display of cards
      // use the code below as a template for displaying sports center
      //when player decides to search
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          elevation: 10,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                leading: Icon(Icons.album),
                title: Text('Flutter Card Image Example'),
                subtitle: Text('An example flutter card with image'),
              ),
              Container(
                alignment: Alignment.center,
                child: Image.asset(defaultSportCenterImagePath),
              ),
              ButtonTheme(
                child: ButtonBar(
                  children: [
                    ElevatedButton(
                      child: const Text('Google Maps'),
                      onPressed: () {/* ... */},
                    ),
                    ElevatedButton(
                      child: const Text('Show More'),
                      onPressed: () {/* ... */},
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return ViewPlayerProfile(player: widget.player);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Player Home Page',
            style: TextStyle(
              color: kLightColor,
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
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
