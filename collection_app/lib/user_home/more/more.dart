import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ktu_pro/user_home/more/about.dart';
import 'package:provider/provider.dart';
import 'package:ktu_pro/logincheck/privider.dart';
import 'package:ktu_pro/user_home/more/moreoption/address.dart';
import 'package:ktu_pro/user_home/more/moreoption/chagepass.dart';
import 'package:ktu_pro/user_home/more/moreoption/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
      appBar: AppBar(
        title: const Center(
          child: Text(
            'User Settings',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 10, 4, 37),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  const SizedBox(height: 16),
                  buildListTile('Change Password', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Forgot1()),
                    );
                  }),
                  const SizedBox(height: 16),
                  buildListTile('Change Address', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage87()),
                    );
                  }),
                  const SizedBox(height: 16),
                  buildListTile('Change Location', () {
                    if (_latitude.isNotEmpty && _longitude.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationScreen(
                            latitude: _latitude,
                            longitude: _longitude,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Fetching location... Please wait.'),
                      ));
                    }
                  }),
                  const SizedBox(height: 16),
                  buildListTile('About', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutScreen()),
                    );
                  }),
                  
                  const SizedBox(height: 16),
                  buildListTile('Logout', () {
                    showConfirmationDialog(context, 'Logout', () {
                      logout(context);
                    });
                  })
                ],
              ),
            ),
    );
  }

  Widget buildListTile(String title, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueGrey.shade50,
      ),
      child: ListTile(
        title: Text(title),
        onTap: onTap,
      ),
    );
  }

  void logout(BuildContext context) async {
    try {
      Provider.of<UserProvider>(context, listen: false).logout();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  void showConfirmationDialog(BuildContext context, String action, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 10, 4, 37),
        title: Text('Confirm $action',style: TextStyle(color: Colors.white60)),
        content: Text('Are you sure you want to $action?',style: TextStyle(color: Colors.white60),),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No',style: TextStyle(color: Colors.white60)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              onConfirm(); // Execute the callback function
            },
            child: Text('Yes',style: TextStyle(color: Colors.white60)),
          ),
        ],
      ),
    );
  }

  void _fetchCurrentLocation() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        var permissionStatus = await Geolocator.requestPermission();
        if (permissionStatus != LocationPermission.whileInUse && permissionStatus != LocationPermission.always) {
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
