// ignore_for_file: use_build_context_synchronously


import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class HomePage87 extends StatefulWidget {
  _HomePage87State createState() => _HomePage87State();
}

class _HomePage87State extends State<HomePage87> {
  bool _isLoading = false;
  String _username = '';
  String _area = '';
  String _email = '';
  String _ph = '';
  String _city = '';
  String _pinno = '';
  String _house_no = '';
  String _location ='';

  @override
  void initState() {
    super.initState();
    _refreshData(); // Automatically trigger refresh when screen is entered
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String phoneNumber = prefs.getString('phoneNumber') ?? '';
      final response = await http.get(
        Uri.https(
          '3lehlczcqi5umgsp2v4yv2z2440karrn.lambda-url.ap-south-1.on.aws',
          '/path/to/endpoint',
          {'page': 'address', 'number': '$phoneNumber'},
        ),
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');

        final jsonData = json.decode(response.body);
        setState(() {
          _username = jsonData['fullname'];
          _house_no = jsonData['house_no'];
          _area = jsonData['area'];
          _city = jsonData['city'];
          _pinno = jsonData['pin_no'];
          _ph = jsonData['number'];
          _email = jsonData['email'];
          _location =jsonData['location'] ;// Extract address from server response
        });
      } else {
        _showErrorSnackbar('Failed to load data');
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackbar('No internet connection');
      print('Error: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _showEditScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          username: _username,
          houseNo: _house_no,
          area: _area,
          city: _city,
          pinNo: _pinno,
          phoneNumber: _ph,
          email: _email,location: _location,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showEditScreen,
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 10, 4, 37),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                ListTile(
                  title: const Text(
                    'Username',
                    style: TextStyle(color: Colors.white30),
                  ),
                  subtitle: Text(
                    _username,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  title: const Text(
                    'House No',
                    style: TextStyle(color: Colors.white30),
                  ),
                  subtitle: Text(
                    _house_no,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Area',
                    style: TextStyle(color: Colors.white30),
                  ),
                  subtitle: Text(
                    _area,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  title: const Text(
                    'City',
                    style: TextStyle(color: Colors.white30),
                  ),
                  subtitle: Text(
                    _city,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  title: const Text(
                    'PIN No',
                    style: TextStyle(color: Colors.white30),
                  ),
                  subtitle: Text(
                    _pinno,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Phone Number',
                    style: TextStyle(color: Colors.white30),
                  ),
                  subtitle: Text(
                    _ph,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Email',
                    style: TextStyle(color: Colors.white30),
                  ),
                  subtitle: Text(
                    _email,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final String username;
  final String houseNo;
  final String area;
  final String city;
  final String pinNo;
  final String phoneNumber;
  final String email;
  final String location;

  EditProfileScreen({
    required this.username,
    required this.houseNo,
    required this.area,
    required this.city,
    required this.pinNo,
    required this.phoneNumber,
    required this.email,
    required this.location,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _houseNoController;
  late TextEditingController _areaController;
  late TextEditingController _cityController;
  late TextEditingController _pinNoController;
 late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(
      text: widget.username,
    );
    _houseNoController = TextEditingController(text: widget.houseNo);
    _areaController = TextEditingController(text: widget.area);
    _cityController = TextEditingController(text: widget.city);
    _pinNoController = TextEditingController(text: widget.pinNo);
     _phoneNumberController = TextEditingController(text: widget.phoneNumber);
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _houseNoController.dispose();
    _areaController.dispose();
    _cityController.dispose();
    _pinNoController.dispose();
    // _phoneNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveChanges(
      BuildContext context,
      String type,
      String fullName,
      String email,
      String houseNumber,
      String area,
      String city,
      String pin,
      String password,
      String email5,String location)
       async {
        Map<String, String> userData = {
    "number": email5,
    "area": area,
    "city": city,
    "email": email,
    "fullname": fullName,
    "house_no": houseNumber,
    "pin_no": pin,
    "password": password,
    "location": location,
  };

  String data = jsonEncode(userData);

  // Append query parameters directly to the URI
  final uri = Uri.https(
    'fnfmkp32x4on5vljtbdvlzoviq0bemmb.lambda-url.ap-south-1.on.aws',
    '/path/to/endpoint',
    {'type': type, 'data': data, 'number': email5},
  );

  
    try {
      final response = await http.get(uri);

      if (response.body == "success") {
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Address Change Successfully'),
            duration: const Duration(seconds: 2),
          ),
        );
        print(response.body);
        Navigator.of(context).pop();

      } else {
                print(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.body),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      print('$error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error during request: '),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        )),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 10, 4, 37),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            controller: _usernameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Colors.white24),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                )),
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            controller: _houseNoController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                labelText: 'House No',
                labelStyle: TextStyle(color: Colors.white24),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                )),
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            controller: _areaController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                labelText: 'Area',
                labelStyle: TextStyle(color: Colors.white24),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                )),
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            controller: _cityController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                labelText: 'City',
                labelStyle: TextStyle(color: Colors.white24),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                )),
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            controller: _pinNoController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                labelText: 'PIN No',
                labelStyle: TextStyle(color: Colors.white24),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                )),
          ),
          const SizedBox(
            height: 15,
          ),
          // TextFormField(
          //   controller: _phoneNumberController,
          //   style: const TextStyle(color: Colors.white),
          //   decoration: const InputDecoration(
          //       labelText: 'Phone Number',
          //       labelStyle: TextStyle(color: Colors.white24),
          //       border: OutlineInputBorder(
          //         borderSide: BorderSide(color: Colors.white),
          //       )),
          // ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            controller: _emailController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white24),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                )),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              _saveChanges(
                context,
                'change_address',
                _usernameController.text,
                _emailController.text,
                _houseNoController.text,
                _areaController.text,
                _cityController.text,
                _pinNoController.text,
                'password',
                _phoneNumberController.text,widget.location
              );
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
