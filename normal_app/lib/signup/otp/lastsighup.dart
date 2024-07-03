import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:santa/signup/map/mapsignup.dart';

class signup3 extends StatefulWidget {
  const signup3({Key? key}) : super(key: key);

  @override
  signup3State createState() => signup3State();
}

class signup3State extends State<signup3> {
  TextEditingController emailOrPhoneController = TextEditingController();
  TextEditingController idcode = TextEditingController();

  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    emailOrPhoneController = TextEditingController(text: '+91');
    _requestLocationPermission(); // Request location permission when screen is loaded
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isOtpSent = false;
  int _timerSeconds = 60;
  late Timer _timer;
  bool passwordVisible = false;
  bool isOtpVerified = false;
  bool numberdisplay = false; // Changed from true to false
  String _latitude = '';
  String _longitude = '';
  bool _isLoadingLocation = true;

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _fetchCurrentLocation();
    } else {
      // Handle denied permission
      // For example, show a message to the user
      print('Location permission denied');
    }
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (Timer timer) {
      if (_timerSeconds == 0) {
        timer.cancel();
        setState(() {
          isOtpSent = false;
          _timerSeconds = 60;
        });
      } else {
        setState(() {
          _timerSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up page'),
      ),
      body: _isLoadingLocation
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: !numberdisplay,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: idcode,
                            decoration: const InputDecoration(
                              labelText: 'Enter ID Code',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          ElevatedButton(
                            onPressed: () {
                              sendOtp2('test', idcode.text);
                              setState(() {
                                numberdisplay = true;
                              });
                            },
                            child: const Text('Submit'),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !isOtpVerified && numberdisplay,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailOrPhoneController,
                            decoration: const InputDecoration(
                              labelText: ' Phone Number',
                              hintText: 'enter the 10 digit number include +91',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.phone_android_sharp),
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 13,
                            validator: (value) {
                              return null;
                            },
                            onEditingComplete: () {
                              FocusScope.of(context).nextFocus();
                            },
                          ),
                          const SizedBox(height: 12.0),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: otpController,
                                  decoration: const InputDecoration(
                                    labelText: 'OTP',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.lock),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    sendOtp('new login', emailOrPhoneController.text, idcode.text);
                                  }
                                },
                                child: Text(isOtpSent ? 'Resend OTP ($_timerSeconds s)' : 'Send OTP'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Visibility(
                      visible: !isOtpVerified && isOtpSent,
                      child: ElevatedButton(
                        onPressed: () => verifyOtp(),
                        child: const Text('Verify OTP'),
                      ),
                    ),
                    Visibility(
                      visible: isOtpVerified && numberdisplay,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: !passwordVisible,
                          ),
                          const SizedBox(height: 12.0),
                          TextFormField(
                            controller: confirmPasswordController,
                            decoration: const InputDecoration(
                              labelText: 'Confirm Password',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lock),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () {
                              if (passwordController.text == confirmPasswordController.text) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LocationScreenf(latitude: _latitude, longitude: _longitude, email5: emailOrPhoneController.text, password: passwordController.text, id: idcode.text),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Password is wrong'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            child: const Text('Continue'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void sendOtp(String type, String number, String id) async {
    final queryParameters = {
      'type': type,
      'number': id,
      'mob': number,
    };

    final uri = Uri.https(
      'bkbxcbtffotkbhoehsqmpospzq0pqech.lambda-url.ap-south-1.on.aws',
      '/path/to/endpoint',
      queryParameters,
    );

    try {
      final response = await http.get(uri);

      if (response.body == "otp sent") {
        setState(() {
          isOtpSent = true;
        });
        startTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${response.body}: Please login'),
            duration: const Duration(seconds: 2),
          ),
        );
        setState(() {
          isOtpSent = false;
          isOtpVerified = false;
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error during request: '),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        isOtpSent = false;
        isOtpVerified = false;
      });
      print('Error during request: $error');
    }
  }

  void sendOtp2(String type, String number) async {
    final queryParameters = {
      'type': type,
      'number': number,
    };

    final uri = Uri.https(
      'bkbxcbtffotkbhoehsqmpospzq0pqech.lambda-url.ap-south-1.on.aws',
      '/path/to/endpoint',
      queryParameters,
    );

    try {
      final response = await http.get(uri);

      if (response.body == "otp sent") {
        setState(() {
          numberdisplay = true;
        });
        startTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${response.body}: Please login'),
            duration: const Duration(seconds: 2),
          ),
        );
        setState(() {
          numberdisplay = false;
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error during request: '),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        isOtpSent = false;
        isOtpVerified = false;
      });
      print('Error during request: $error');
    }
  }

  void verifyOtp() async {
    final queryParameters = {
      'type': 'otp verify',
      'number': emailOrPhoneController.text,
      'otp': otpController.text,
    };

    final uri = Uri.https(
      'bkbxcbtffotkbhoehsqmpospzq0pqech.lambda-url.ap-south-1.on.aws',
      '/path/to/endpoint',
      queryParameters,
    );

    try {
      final response = await http.get(uri);

      if (response.body == "otp verified") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP verified successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          isOtpVerified = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP verification failed'),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          isOtpVerified = false;
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during OTP verification: $error'),
          duration: const Duration(seconds: 2),
        ),
      );
      setState(() {
        isOtpVerified = false;
      });
      print('Error during OTP verification: $error');
    }
  }

  void _fetchCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _latitude = position.latitude.toString();
        _longitude = position.longitude.toString();
        _isLoadingLocation = false;
      });
    } catch (e) {
      print('Error fetching location: $e');
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }
}
