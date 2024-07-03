import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ktu_pro/signup/map/mapsignup.dart';

class signup3 extends StatefulWidget {
  const signup3({Key? key}) : super(key: key);

  @override
  signup3State createState() => signup3State();
}

class signup3State extends State<signup3> {
  TextEditingController emailOrPhoneController = TextEditingController();
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
  int _timerSeconds = 30;
  late Timer _timer;
  bool passwordVisible = false;
  bool isOtpVerified = false;
  bool numberdisplay = true;
  String _latitude = '';
  String _longitude = '';
  bool _isLoadingLocation = true;

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (Timer timer) {
      if (_timerSeconds == 0) {
        timer.cancel();
        setState(() {
          isOtpSent = false;
          _timerSeconds = 30;
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
                      visible: !isOtpVerified, // Hide when OTP is verified
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
                                    sendOtp('new login', emailOrPhoneController.text);
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
                      visible: !isOtpVerified,
                      child: ElevatedButton(
                        onPressed: () => verifyOtp(),
                        child: const Text('Verify OTP'),
                      ),
                    ),
                    // Visibility to wrap the OTP verification fields
                    Visibility(
                      visible: isOtpVerified,
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
                                    builder: (context) => LocationScreenf(latitude: _latitude, longitude: _longitude, email5: emailOrPhoneController.text, password: passwordController.text)
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

  void sendOtp(String type, String number) async {
    setState(() {
      isOtpSent = true;
    });

    final queryParameters = {
      'type': type,
      'number': number,
    };

    final uri = Uri.https(
      'fnfmkp32x4on5vljtbdvlzoviq0bemmb.lambda-url.ap-south-1.on.aws',
      '/path/to/endpoint',
      queryParameters,
    );

    try {
      final response = await http.get(uri);

      if (response.body == "otp sent") {
        print('Response data: ${response.body}');
        print(number);
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

  void verifyOtp() async {
    // Implement OTP verification logic here
    // You can use a similar approach as sendOtp function

    final queryParameters = {
      'type': 'otp verify', // Change 'otp' value based on your API
      'number': emailOrPhoneController.text,
      'otp': otpController.text,
    };

    final uri = Uri.https(
      'fnfmkp32x4on5vljtbdvlzoviq0bemmb.lambda-url.ap-south-1.on.aws',
      '/path/to/endpoint',
      queryParameters,
    );

    try {
      final response = await http.get(uri);

      if (response.body == "otp verified") {
        print('Response data: ${response.body}');
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

  void _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      _fetchCurrentLocation();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permission denied'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
