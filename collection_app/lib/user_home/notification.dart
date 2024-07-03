import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Define the Transaction class
class Transaction {
  final String title;
  final double amount;
  final DateTime date;
  final DateTime time;
  final double wasteCollected;

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.time,
    required this.wasteCollected,
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

  int _selectedMonth = DateTime.now().month; // Track the selected month

  @override
  void initState() {
    super.initState();
    _refreshData(); // Fetch data when screen is entered
  }

  // Generate dummy transactions for each month
  void _generateDummyTransactions() {
    // Clear existing transactions
    transactions.clear();
    // Generate dummy transactions for each month
    for (int i = 1; i <= 12; i++) {
      for (int j = 0; j < 10; j++) {
        transactions.add(Transaction(
          title: 'Transaction $j of $i',
          amount: (j * i * 10).toDouble(),
          date: DateTime(DateTime.now().year, i, 1),
          time: DateTime.now(),
          wasteCollected:
              (j * i * 0.5).toDouble(), // Dummy waste collected in kg
        ));
      }
    }
  }

  // Fetch data from API
  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true; // Set loading indicator
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String phoneNumber = prefs.getString('phoneNumber') ?? '';

      // Generate dummy transactions instead of fetching from API
      _generateDummyTransactions();

      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    } catch (e) {
      _showErrorSnackbar('No internet connection'); // Show error message

      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  // Show error message in a Snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
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

  // Filter transactions based on selected month
  List<Transaction> _filterTransactionsByMonth(int month) {
    return transactions
        .where((transaction) => transaction.date.month == month)
        .toList();
  }

  // Helper method to get the name of the month
  String _getMonthName(int month) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'June',
      'July',
      'Aug',
      'Sept',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1]; // Adjust index to start from 0
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 4, 37),
      body: Container(
        color: const Color.fromARGB(255, 10, 4, 37),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  'Admin',
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
                    data: _data5, data2: false, // Pass the _data5 to the widget
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
                                child: Text('No Data Found'),
                              ) // Show "No Data Found" if transactions list is empty
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
                                  SizedBox(
                                    height: 50, // Adjust height as needed
                                    child: PageView.builder(
                                      controller:
                                          PageController(viewportFraction: 0.3),
                                      itemCount: 12,
                                      itemBuilder: (context, index) {
                                        int month = index + 1;
                                        return Center(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _selectedMonth = month;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: _selectedMonth == month
                                                  ? Colors.blue
                                                  : Colors.grey,
                                            ),
                                            child: Text(
                                              _getMonthName(month),
                                              style: TextStyle(
                                                color: _selectedMonth == month
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  // Display each transaction in ProductCard
                                  for (var transaction
                                      in _filterTransactionsByMonth(
                                          _selectedMonth))
                                    ProductCard(
                                      name: transaction.title,
                                      price: transaction.amount,
                                      time: transaction.time,
                                      wasteCollected:
                                          transaction.wasteCollected,
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
  void _confirmDate() async {
    if (selectedDate.isNotEmpty && selectedTime != null) {
      setState(() {
        isDateConfirmed = true; // Set confirmation state
      });
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String phoneNumber = prefs.getString('phoneNumber') ?? '';

        // // Construct the data payload to be sent to the server
        // Map<String, dynamic> requestData = {
        //   'phoneNumber': phoneNumber,
        //   // 'selectedDate': selectedDate,
        //   // 'selectedTime': '${selectedTime!.hour}:${selectedTime!.minute}',
        // };

        // Make a POST request to the server
       
      final response = await http.get(Uri.https(
        'kjfr55shxlpdpxoity6sgokyha0twafq.lambda-url.ap-south-1.on.aws',
        '/path/to/endpoint',
        {
          
          'phno': '$phoneNumber',
        },
      ));

        // Check if the request was successful
        if (response.statusCode == 200) {
          // Handle success response
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Date and Time confirmed successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          // Handle error response
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to confirm Date and Time: ${response.body}'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        // Handle exception
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error confirming Date and Time'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select Date and Time'),
          duration: Duration(seconds: 2),
        ),
      );
    }
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
                    // Text(
                    //   'Date: $selectedDate',
                    //   style: const TextStyle(
                    //     fontSize: 16,
                    //     color: Colors.white,
                    //   ),
                    // ),
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
  final String data;
  final bool data2; // Add data parameter

  const NameCard({
    required this.username,
    required this.totalWaste,
    required this.coinBalance,
    required this.textColor,
    required this.backgroundColor,
    required this.buttonColor,
    required this.thisMonth,
    required this.data, 
                          required this.data2 ,
// Initialize data parameter
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
              'Notification Bar',
              style: TextStyle(color: textColor, fontSize: 29),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (coinBalance.isNotEmpty)
                      Text(
                        '[Requested to collected the trash on $totalWaste ]',
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                        ),
                      ),
                    if (data.isNotEmpty) // Check if data is not empty
                      Text(
                        '[Requested to collected the trash on $data ]', // Display the data received
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
            if(data2)
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
  final DateTime time;
  final double wasteCollected;
  final Color backgroundColor;
  final Color textColor;
  final Color buttonColor;

  const ProductCard({
    required this.name,
    required this.price,
    required this.time,
    required this.wasteCollected,
    this.backgroundColor = const Color.fromARGB(255, 10, 4, 37),
    this.textColor = Colors.white,
    this.buttonColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 13.0,
            
            color: textColor,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amount: ${price.toStringAsFixed(2)}', // Format price with two decimal places
              style: TextStyle(
                fontSize: 13.0,
                color: textColor,
                
              ),
            ),
            Text(
              'Time: ${time.hour}:${time.minute}', // Display time
              style: TextStyle(
                fontSize: 13.0,
                color: textColor,
               
              ),
            ),
            Text(
              'Waste Collected: $wasteCollected kg', // Display waste collected
              style: TextStyle(
                fontSize: 13.0,
                color: textColor,
              
              ),
            ),
          ],
        ),
        // trailing: ElevatedButton(
        //   onPressed: () {
        //     // Implement product details or add to cart functionality
        //   },
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: buttonColor,
        //   ),
        //   child: const Text('View Details'),
        // ),
      ),
    );
  }
}

