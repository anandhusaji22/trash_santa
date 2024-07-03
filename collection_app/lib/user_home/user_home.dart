// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage8 extends StatefulWidget {
  // Retrieve the phone number from SharedPreferences

  @override
  _HomePage8State createState() => _HomePage8State();
}

class _HomePage8State extends State<HomePage8> {
  bool _isLoading = false;
  String _username = '';
  String _totalWaste = '';
  String _coinBalance = '';
  String _thisMonth = '';

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

      final response = await http.get(Uri.https(
        '3lehlczcqi5umgsp2v4yv2z2440karrn.lambda-url.ap-south-1.on.aws',
        '/path/to/endpoint',
        {
          'page': 'points',
          'number': '$phoneNumber',
        },
      ));
      if (response.statusCode == 200) {
        print(response.body);

        final jsonData = json.decode(response.body);
        setState(() {
          _username = jsonData['username'];
          _totalWaste = jsonData['totalwaste'].toString();
          _coinBalance = jsonData['coinbalance'].toString();
          _thisMonth = jsonData['thismonth'].toString();
        });
      } else {
        _showErrorSnackbar(context, 'Failed to load data');
        print(response.statusCode);
      }
    } catch (e) {
      _showErrorSnackbar(context, 'No internet connection');
    } finally {
      {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Container(
          color: const Color.fromARGB(255, 10, 4, 37),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Center(),
                      ),
                      nameCard(
                        username:
                            _username.isNotEmpty ? _username : 'No data found',
                        totalWaste: _totalWaste.isNotEmpty
                            ? _totalWaste
                            : 'No data found',
                        coinBalance: _coinBalance.isNotEmpty
                            ? _coinBalance
                            : 'No data found',
                        thisMonth: _thisMonth.isNotEmpty
                            ? _thisMonth
                            : 'No data found',
                        textColor: const Color.fromARGB(255, 255, 255, 255),
                        backgroundColor: const Color.fromARGB(232, 99, 20, 209),
                        buttonColor: const Color.fromARGB(221, 255, 240, 240),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 6, 1, 28),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.all(20),
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  const Text(
                                    'Recycle ♲',
                                    style: TextStyle(
                                      fontSize: 21.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    _totalWaste.isNotEmpty
                                        ? _totalWaste
                                        : 'No data found',
                                    style: const TextStyle(
                                      fontSize: 21.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(
                                  255,
                                  6,
                                  1,
                                  28,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                children: [
                                  const Text(
                                    'This Month ♲',
                                    style: TextStyle(
                                      fontSize: 21.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  Text(
                                    _thisMonth.isNotEmpty
                                        ? _thisMonth
                                        : 'No data found',
                                    style: const TextStyle(
                                      fontSize: 21.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Modify the ProductCard widget to display images dynamically
                            // based on the images stored in the assets folder
                            _buildDynamicProductCards(),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicProductCards() {
    // Example list of image filenames stored in the assets folder
    final List<String> assetImageNames = [
      '1.jpg',
      '2.jpg',
      '3.jpg',
      '4.jpg',
      '5.jpg',
      '6.jpg',
      // Add more image filenames as needed
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: assetImageNames
          .map((imageName) => ProductCard(
                name: 'Product ${assetImageNames.indexOf(imageName) + 1}',
                price: 19, // You can set the price dynamically as needed
                imageUrl: 'assets/images/$imageName',
              ))
          .toList(),
    );
  }
}

class nameCard extends StatelessWidget {
  final String username;
  final String coinBalance;
  final String thisMonth;
  final Color backgroundColor;
  final Color textColor;
  final Color buttonColor;
  final String totalWaste;

  const nameCard({
    super.key,
    required this.username,
    required this.totalWaste,
    required this.coinBalance,
    required this.textColor,
    required this.backgroundColor,
    required this.buttonColor,
    required this.thisMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: const [0.1, 0.4, 0.6, 0.9],
            colors: [
              const Color.fromARGB(255, 42, 70, 225),
              const Color.fromARGB(255, 90, 42, 212),
              Colors.purple.shade500,
              const Color.fromARGB(255, 51, 78, 236),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Text(
              username,
              style: TextStyle(color: textColor, fontSize: 29),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Coin Balance',
                      style: TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.point_of_sale,
                          size: 32,
                        ),
                        Text(
                          '$coinBalance points',
                          style: TextStyle(
                            fontSize: 19.0,
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     // Implement some functionality or remove if not needed
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: buttonColor,
            //   ),
            //   child: const Text('View Details'),
            // ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final String imageUrl;
  final Color backgroundColor;
  final Color textColor;
  final Color buttonColor;

  const ProductCard({
    Key? key,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.backgroundColor = Colors.blueAccent,
    this.textColor = Colors.black,
    this.buttonColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: backgroundColor,
            child: Image.asset(
              imageUrl,
              height: 150.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  '$price coins',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Show dialog when "View Details" button is pressed
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Product Details',
                        style: TextStyle(color: Colors.white)),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Name: $name',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text('Price: ${price.toStringAsFixed(2)} coins',
                            style: const TextStyle(color: Colors.white)),
                        // You can add more details here
                      ],
                    ),
                    backgroundColor: const Color.fromARGB(255, 10, 4, 37),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          _confirmDate(context, '${price.toInt()}');
                          ////////////////////////////////////////////////////////////
                          // Implement your confirmation action here
                          //Navigator.of(context).pop(); // Close dialog
                        },
                        child: const Text('Confirm',
                            style: TextStyle(color: Colors.white)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                        },
                        child: const Text('Cancel',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
            ),
            child: const Text('Buy Now'),
          ),
        ],
      ),
    );
  }
}
void _confirmDate(BuildContext context, price) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phoneNumber = prefs.getString('phoneNumber') ?? '';

    final response = await http.get(Uri.https(
      'ynpbcrvulsb3zmx3h3rlflm4qm0frenk.lambda-url.ap-south-1.on.aws',
      '/path/to/endpoint',
      {'type': 'buy', 'number': phoneNumber, 'amount': price},
    ));

    if (response.body == "purchase successful") {
      print(response.body);
       Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Purchase Successful'),
            content: Text(response.body),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      Navigator.of(context).pop(); // Close dialog
    } else {
      print(response.body);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Status'),
            content: Text(response.body),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  } catch (e) {
    // Handle error
  }
}
