import 'package:flutter/material.dart';
import '../constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.email});
  final String email;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Welcome $email',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class ViewProfile extends StatelessWidget {
  const ViewProfile({
    super.key,
    required this.email,
  });
  final String email;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Viewing $email's profile",
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({
    super.key,
    required this.userEmail,
    required this.role,
  });

  final String userEmail, role;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int _selectNavBarItemIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectNavBarItemIndex = index;
    });
  }

  Widget getBody() {
    if (_selectNavBarItemIndex == 0) {
      return HomePage(email: widget.userEmail);
    }
    return ViewProfile(email: widget.userEmail);
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
