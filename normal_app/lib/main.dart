// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';
import 'package:santa/forgotpass/forgotpass.dart';
import 'package:santa/logincheck/privider.dart';
import 'package:santa/signup/otp/lastsighup.dart';
import 'package:santa/user_home/user_homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for SharedPreferences
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle errors gracefully
          return const Scaffold(
            backgroundColor: Color.fromARGB(255, 10, 4, 37),
            body: Center(
              child: Text(
                'Error loading data. Please try again later.',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        } else {
          // Retrieve user authentication state from shared preferences
          bool isLoggedIn = snapshot.data?.getBool('isLoggedIn') ?? false;

          // Determine which page to navigate to based on authentication state
          Widget initialPage = isLoggedIn ? UserHomePage1() : LoginPage();

          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => UserProvider()),
            ],
            child: MaterialApp(
              home: initialPage,
              routes: {
                '/login': (context) => LoginPage(),
                '/home': (context) => UserHomePage1(),
              },
            ),
          );
        }
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
     // Set your desired country code
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 4, 37),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: const FlutterLogo(size: 100),
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.only(bottom: 20.0),
              ),
              TextFormField(
                controller: _emailController,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: ' Phone ID Number',
                  hintText: 'Enter the 5 digit ID number ',
                  hintStyle:
                      TextStyle(color: Colors.white60), // Hint text color
                  labelStyle:
                      TextStyle(color: Colors.white60), // Label text color
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // Border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.white), // Focused border color
                  ),
                  prefixIcon: Icon(Icons.phone_android_rounded,
                      color: Colors.white), // Prefix icon color
                ),
                keyboardType: TextInputType.phone,
                maxLength: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your ID';
                  }
                  if (value.length != 5) {
                    return 'Phone id should be 5 digits long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                controller: _passwordController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle:
                      TextStyle(color: Colors.white), // Label text color
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // Border color
                  ),
                  prefixIcon: Icon(Icons.lock,
                      color: Colors.white), // Prefix icon color
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white, // Icon color
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Afterotp4(
                      context,
                      'login',
                      _emailController.text,
                      _passwordController.text,
                    );
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const signup3()),
                          );
                        },
                        child: const Text('Signup'),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Forgot()),
                      );
                    },
                    child: const Text(
                      'Forgot Password??',
                      style: TextStyle(
                        color: Colors.white30,
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}

void Afterotp4(
    BuildContext context, String type, String number, String pass) async {
  final queryParameters = {
    'type': type,
    'number': number,
    'password': pass,
  };

  final uri = Uri.https(
    'bkbxcbtffotkbhoehsqmpospzq0pqech.lambda-url.ap-south-1.on.aws',
    '/path/to/endpoint',
    queryParameters,
  );

  try {
    final response = await http.get(uri);

    if (response.body == "Success") {
      Provider.of<UserProvider>(context, listen: false).login();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setString('email', number);
      prefs.setString('phoneNumber', number);
      prefs.setString(
          'phoneNumber', number); // Save phone number to SharedPreferences

// Save email to SharedPreferences

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserHomePage1(),
        ),
      );
    } else {
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
