// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:ktu_pro/user_home/more/more.dart';
import 'package:ktu_pro/user_home/notification.dart';
import 'package:ktu_pro/user_home/point.dart';
import 'package:ktu_pro/user_home/user_home.dart';

class UserHomePage1 extends StatefulWidget {
  

  @override
  _UserHomePage1State createState() => _UserHomePage1State();
}

class _UserHomePage1State extends State<UserHomePage1> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: WillPopScope(
        onWillPop: () async {
          if (_currentIndex == 0) {
            return true; // Allow to pop if current index is 0 (HomePage8)
          } else {
            setState(() {
              _currentIndex = 0; // Reset to HomePage8 when back button is pressed
            });
            return false; // Prevent default back behavior
          }
        },
        child: Center(
          child: _getPage(_currentIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue, // Set the color for the selected item
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet_sharp),
            label: 'Earns',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_time_sharp ),
            label: 'More',
          ),
        ],
      ),
    );
  }
  

  Widget _getPage(int index) {
    
    switch (index) {
      case 0:
        return HomePage8();
      case 1:
        return Point();
      case 2:
        return HomePage55();
      case 3:
        return SettingsScreen();
      default:
        return Container(); // Return an empty container or your default page
    }
  }
}
