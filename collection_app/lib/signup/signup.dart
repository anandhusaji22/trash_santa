// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously, non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ktu_pro/main.dart';

class SignUpPage extends StatefulWidget {
  final String email5;
  final String password;
  final String selectedlocation;

  SignUpPage(
      {required this.email5,
      required this.password,
      required this.selectedlocation});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController emailidController = TextEditingController();
  TextEditingController houseNameController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController houseNoController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void printUserData() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.only(bottom: 15.0),
                child: const FlutterLogo(size: 100),
              ),
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: emailidController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                    return 'Enter a valid email!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: houseNameController,
                decoration: const InputDecoration(
                  labelText: 'House Name and Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your house name and number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: areaController,
                decoration: const InputDecoration(
                  labelText: 'Area',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your area';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_city),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: pinController,
                decoration: const InputDecoration(
                  labelText: 'PIN',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_searching),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your PIN';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, print user data and navigate to the next page
                    printUserData();
                    Afterotp(
                        context,
                        'customar_signup',
                        firstNameController.text,
                        emailidController.text,
                        houseNameController.text,
                        areaController.text,
                        cityController.text,
                        pinController.text,
                        widget.password,
                        widget.email5,
                        widget.selectedlocation);
                  }
                },
                child: const Text('Next'),
              ),
              const SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Navigate back to login page
                },
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void Afterotp(
    BuildContext context,
    String type,
    String fullName,
    String email,
    String houseNumber,
    String area,
    String city,
    String pin,
    String password,
    String email5,
    String location) async {
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

    if (response.body == "registration sucessfull") {
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.body),
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error during request: $error'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
