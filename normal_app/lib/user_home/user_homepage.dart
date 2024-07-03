// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:santa/user_home/more/more.dart';
// import 'package:santa/user_home/notification.dart';
import 'package:santa/user_home/more/map.dart';
import 'package:santa/user_home/user_home.dart';

class UserHomePage1 extends StatefulWidget {
  @override
  _UserHomePage1State createState() => _UserHomePage1State();
}

class _UserHomePage1State extends State<UserHomePage1> {
  int _currentIndex = 0;
  String _latitude = '';
  String _longitude = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

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
            icon: Icon(Icons.maps_home_work_outlined),
            label: 'Map',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.notifications),
          //   label: 'Notifications',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_time_sharp),
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
        return _buildLocationScreen();
      // case 2:
      //   return HomePage55();
      case 2:
        return SettingsScreen();
      default:
        return Container(); // Return an empty container or your default page
    }
  }

  Widget _buildLocationScreen() {
    if (_latitude.isNotEmpty && _longitude.isNotEmpty) {
      return LocationScreen(latitude: '$_latitude', longitude: '$_longitude',);
    } else {
      _fetchCurrentLocation();
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  void _fetchCurrentLocation() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        var permissionStatus = await Geolocator.requestPermission();
        if (permissionStatus != LocationPermission.whileInUse &&
            permissionStatus != LocationPermission.always) {
          print('Location permission denied.');
          setState(() {
            _isLoading = false; // Set loading state to false
          });
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (mounted) {
        setState(() {
          _latitude = position.latitude.toString();
          _longitude = position.longitude.toString();
          print('Latitude: $_latitude, Longitude: $_longitude');
          _isLoading = false; // Set loading state to false
        });
      }
    } catch (e) {
      print('Error fetching location: $e');
      setState(() {
        _isLoading = false; // Set loading state to false
      });
    }
  }
}
