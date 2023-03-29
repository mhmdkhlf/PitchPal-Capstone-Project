import 'package:flutter/material.dart';
import '../constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.userEmail,
    required this.role,
  });

  final String userEmail, role;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          'Welcome ${widget.userEmail}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
    return Center(
      child: Text(
        "Viewing ${widget.userEmail}'s profile",
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            '${widget.role} home page',
            style: const TextStyle(
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
