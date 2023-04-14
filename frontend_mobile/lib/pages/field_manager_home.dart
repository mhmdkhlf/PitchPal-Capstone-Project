import 'package:flutter/material.dart';
import 'view_field_manager_profile.dart';
import '../data/field_manager.dart';
import '../constants.dart';

class FieldManagerHomePage extends StatefulWidget {
  const FieldManagerHomePage({
    super.key,
    required this.fieldManager,
  });

  final FieldManager fieldManager;

  @override
  State<FieldManagerHomePage> createState() => _FieldManagerHomePageState();
}

class _FieldManagerHomePageState extends State<FieldManagerHomePage> {
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
          'Welcome ${widget.fieldManager.name}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
    return ViewFieldManagerProfile(fieldManager: widget.fieldManager);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Field-Manager Home Page',
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
