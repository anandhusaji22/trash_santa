import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ktu_pro/main.dart';

class Forgot extends StatefulWidget {
  @override
  ForgotState createState() => ForgotState();
}

class ForgotState extends State<Forgot> {
  TextEditingController emailOrPhoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  void initState() {
    super.initState();
    emailOrPhoneController = TextEditingController(text: '+91');
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isOtpSent = false;
  int _timerSeconds = 30;
  late Timer _timer;
  bool passwordVisible = false;
  bool isOtpVerified = false;

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
        title: const Text('Forget Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isOtpVerified)
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
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }

                    if (int.tryParse(value) == null) {
                      return 'Invalid phone number';
                    }

                    if (value.length != 13) {
                      return 'Phone number should be 10 digits long';
                    }

                    return null;
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                ),
              const SizedBox(height: 12.0),
              if (!isOtpVerified)
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
                          sendOtp('forget password', emailOrPhoneController.text);
                        }
                      },
                      child: Text(isOtpSent ? 'Resend OTP ($_timerSeconds s)' : 'Send OTP'),
                    ),
                  ],
                ),
              const SizedBox(height: 12.0),
              if (!isOtpVerified)
                ElevatedButton(
                  onPressed: () => verifyOtp(),
                  child: const Text('Verify OTP'),
                ),
              if (isOtpVerified)
                Column(
                  children: [
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
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
                          Afterotp('set password', emailOrPhoneController.text, passwordController.text);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('password is wrong'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: const Text('Continue'),
                    ),
                  ],
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

      print('Response data: ${response.body}');

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
        print('Error: ${response.statusCode}');
        print('Response data: ${response.body}');
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
        SnackBar(
          content: Text('Error during request: $error'),
          duration: const Duration(seconds: 2),
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
      'fnfmkp32x4on5vljtbdvlzoviq0bemmb.lambda-url.ap-south-1.on.aws',
      '/path/to/endpoint',
      queryParameters,
    );

    try {
      final response = await http.get(uri);

      print('Response data: ${response.body}');

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
        print('Error: ${response.statusCode}');
        print('Response data: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP verification failed'),
            duration: const Duration(seconds: 2),
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

  void Afterotp(String type, String number, String pass) async {
    final queryParameters = {
      'type': type,
      'number': number,
      'password': pass,
    };

    final uri = Uri.https(
      'fnfmkp32x4on5vljtbdvlzoviq0bemmb.lambda-url.ap-south-1.on.aws',
      '/path/to/endpoint',
      queryParameters,
    );

    try {
      final response = await http.get(uri);

      print('Response data: ${response.body}');

      if (response.body == "password set successfull") {
        print('Response data: ${response.body}');
        print(number);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('password reset successfull'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      } else {
        print('Error: ${response.statusCode}');
        print('Response data: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${response.body}'),
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
      print('Error during request: $error');
    }
  }
}
