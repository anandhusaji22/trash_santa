import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Define the Transaction class
class Transaction {
  final String title;
  final double amount;
  final DateTime date;
  final DateTime time;

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.time,
  });
}

// HomePage55 StatefulWidget
class HomePage55 extends StatefulWidget {
  @override
  _HomePage55State createState() => _HomePage55State();
}

// _HomePage55State State
class _HomePage55State extends State<HomePage55> {
  String selectedDate = ''; // Selected date for garbage collection
  TimeOfDay? selectedTime; // Selected time for garbage collection
  bool _isLoading = false; // Loading indicator
  List<Transaction> transactions = []; // Define transactions list
  String _data5 = '';

  @override
  void initState() {
    super.initState();
    _refreshData(); // Fetch data when screen is entered
  }

  // Fetch data from API
  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true; // Set loading indicator
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
        List<Transaction> fetchedTransactions = [];

        // Iterate through fetched transactions
        for (var item in jsonData['transactions']) {
          // Parse each transaction and add it to the list
          fetchedTransactions.add(Transaction(
            title: item['title'],
            amount: double.parse(item['amount']),
            date: DateTime.parse(item['date']),
            time: DateTime.parse(item['time']),
          ));
        }

        setState(() {
          _data5 = jsonData['username'];
          transactions = fetchedTransactions; // Update transactions list
        });
      } else {
        _showErrorSnackbar('Failed to load data'); // Show error message
        print(response.statusCode);
      }
    } catch (e) {
      _showErrorSnackbar('No internet connection'); // Show error message
    }

    setState(() {
      _isLoading = false; // Hide loading indicator
    });
  }

  // Show error message in a Snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(
      context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // Update selected date and time
  void updateDateAndTime(String date, TimeOfDay time) {
    setState(() {
      selectedDate = date;
      selectedTime = time;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 10, 4, 37),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'admin',
                  style: TextStyle(
                    fontSize: 34.0,
                    color: Color.fromARGB(255, 241, 238, 238),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  // NameCard widget displaying user information
                  NameCard(
                    username: 'username',
                    totalWaste: selectedDate,
                    coinBalance: selectedTime != null
                        ? '${selectedTime!.hour}:${selectedTime!.minute}'
                        : '',
                    textColor: const Color.fromARGB(255, 255, 255, 255),
                    backgroundColor: const Color.fromARGB(232, 99, 20, 209),
                    buttonColor: const Color.fromARGB(221, 255, 240, 240),
                    thisMonth: 'thisMonth',
                    data: _data5, // Pass the _data5 to the widget
                  ),
                  // NameCard5 widget for garbage collection scheduling
                  NameCard5(updateDateAndTime: updateDateAndTime),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : transactions.isEmpty
                            ? const Center(
                                child: Text(
                                    'No Data Found')) // Show "No Data Found" if transactions list is empty
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Previous History',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Display each transaction in ProductCard
                                  for (var transaction in transactions)
                                    ProductCard(
                                      name: transaction.title,
                                      price: transaction.amount,
                                    ),
                                ],
                              ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// NameCard5 widget for garbage collection scheduling
class NameCard5 extends StatefulWidget {
  final void Function(String, TimeOfDay) updateDateAndTime;

  const NameCard5({Key? key, required this.updateDateAndTime})
      : super(key: key);

  @override
  _NameCard5State createState() => _NameCard5State();
}

class _NameCard5State extends State<NameCard5> {
  String selectedDate = ''; // Selected date for garbage collection
  TimeOfDay? selectedTime; // Selected time for garbage collection
  bool isDateConfirmed = false; // Flag to check if date is confirmed

  // Method to select date for garbage collection
  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    ))!;
    if (pickedDate != DateTime.now()) {
      setState(() {
        selectedDate = pickedDate.toString();
        isDateConfirmed = false; // Reset confirmation state
      });
      _selectTime(context); // Select time after selecting date
    }
  }

  // Method to select time for garbage collection
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
        isDateConfirmed = false; // Reset confirmation state
      });
    }
  }

  // Method to confirm selected date and time
  void _confirmDate() {
    setState(() {
      isDateConfirmed = true; // Set confirmation state
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Date and Time confirmed successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
    widget.updateDateAndTime(
        selectedDate, selectedTime!); // Update date and time in parent widget
  }

  // Method to reset selected date
  void _resetDate() {
    setState(() {
      isDateConfirmed = false; // Reset confirmation state
    });
  }

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
            stops: [0.1, 0.4, 0.6, 0.9],
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
            const Text(
              'Collect My Garbage',
              style: TextStyle(
                color: Colors.white,
                fontSize: 29,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!isDateConfirmed)
              ElevatedButton(
                onPressed: () {
                  _selectDate(context); // Show date picker
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('Add'),
              ),
            if (selectedDate.isNotEmpty && !isDateConfirmed)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Selected Date and Time:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Date: $selectedDate',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    if (selectedTime != null)
                      Text(
                        'Time: ${selectedTime!.hour}:${selectedTime!.minute}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _confirmDate, // Confirm selected date and time
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              ),
            if (isDateConfirmed)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Date Confirmed:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Date: $selectedDate',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _resetDate, // Reset selected date
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Add Another Date'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// NameCard widget for displaying user information
class NameCard extends StatelessWidget {
  final String username;
  final String coinBalance;
  final String thisMonth;
  final Color backgroundColor;
  final Color textColor;
  final Color buttonColor;
  final String totalWaste;
  final String data; // Add data parameter

  const NameCard({
    required this.username,
    required this.totalWaste,
    required this.coinBalance,
    required this.textColor,
    required this.backgroundColor,
    required this.buttonColor,
    required this.thisMonth,
    required this.data, // Initialize data parameter
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
            stops: [0.1, 0.4, 0.6, 0.9],
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
              'Notification bar',
              style: TextStyle(color: textColor, fontSize: 29),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '$coinBalance ',
                      style: const TextStyle(
                        fontSize: 10.0,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Data: $data', // Display the data received
                      style: const TextStyle(
                        fontSize: 10.0,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement some functionality or remove if not needed
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
              ),
              child: const Text('Report'),
            ),
          ],
        ),
      ),
    );
  }
}

// ProductCard widget for displaying each transaction
class ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final Color backgroundColor;
  final Color textColor;
  final Color buttonColor;

  const ProductCard({
    required this.name,
    required this.price,
    this.backgroundColor = Colors.blueAccent,
    this.textColor = Colors.black,
    this.buttonColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16.0),
      leading: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: backgroundColor,
        ),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      subtitle: Text(
        'Amount: ${price.toStringAsFixed(2)}', // Format price with two decimal places
        style: TextStyle(
          fontSize: 16.0,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: ElevatedButton(
        onPressed: () {
          // Implement product details or add to cart functionality
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
        ),
        child: const Text('View Details'),
      ),
    );
  }
}
