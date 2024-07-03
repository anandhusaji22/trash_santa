import 'package:flutter/material.dart';


class HomePage8 extends StatefulWidget {
  @override
  _HomePage8State createState() => _HomePage8State();
}

class _HomePage8State extends State<HomePage8> {
  bool _isLoading = false;
  String _userid = '';
  String _totalhouse = '30';
  String _currentactive = '20';
  String _today = '';
  String _thisMonthwaste = '';
  List<Customer> _customers = [];

  @override
  void initState() {
    super.initState();
    _addDummyData(); // Call a method to add dummy data
  }

  void _addDummyData() {
    // Add sample customers to the list
    _customers = [
      Customer(
        name: 'John Doe',
        orderId: 1234,
        deliveryAddress: '123 Main St',
        restaurantName: 'ABC Restaurant',
        status: 'Delivered',
      ),
      Customer(
        name: 'Jane Smith',
        orderId: 5678,
        deliveryAddress: '456 Elm St',
        restaurantName: 'XYZ Restaurant',
        status: 'In Progress',
      ),
      // Add more customers as needed
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: NameCard(
                        userid: _userid.isNotEmpty ? _userid : 'Albin Chacko ',
                        totalWaste5: _thisMonthwaste.isNotEmpty
                            ? _totalhouse
                            : '0',
                        currentActive: _currentactive.isNotEmpty
                            ? _currentactive
                            : '0',
                        totalHouse: _totalhouse.isNotEmpty ? _totalhouse : '0',
                        todayWaste: _today.isNotEmpty ? _today : '0',
                        textColor: const Color.fromARGB(255, 255, 255, 255),
                        backgroundColor:
                            const Color.fromARGB(232, 99, 20, 209),
                        buttonColor: const Color.fromARGB(221, 255, 240, 240),
                      ),
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white, // Set border color here
                            width: 2, // Set border width here
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(
                              8.0), // Add padding to create space between text and border
                          child: Text(
                            "Waste Collected",
                            style: TextStyle(
                                color: Colors.white), // Set text color
                          ),
                        ),
                      ),
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
                                  'Today',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  _thisMonthwaste.isNotEmpty
                                      ? '$_thisMonthwaste kg'
                                      : '0.00',
                                  style: const TextStyle(
                                    fontSize: 17.0,
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
                                  'This month',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                Text(
                                  _thisMonthwaste.isNotEmpty
                                      ? '$_thisMonthwaste kg'
                                      : '0.00',
                                  style: const TextStyle(
                                    fontSize: 17.0,
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
                        children: _customers.isNotEmpty
                            ? _customers
                                .map((customer) => CustomerDetails(
                                      name: customer.name,
                                      orderId: customer.orderId,
                                      deliveryAddress:
                                          customer.deliveryAddress,
                                      restaurantName: customer.restaurantName,
                                      status: customer.status,
                                    ))
                                .toList()
                            : const [Text('No customers found')],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class NameCard extends StatelessWidget {
  final String userid;
  final String currentActive;
  final String totalHouse;
  final Color backgroundColor;
  final Color textColor;
  final Color buttonColor;
  final String totalWaste5;
  final String todayWaste;

  const NameCard({
    Key? key,
    required this.userid,
    required this.totalWaste5,
    required this.currentActive,
    required this.textColor,
    required this.backgroundColor,
    required this.buttonColor,
    required this.totalHouse,
    required this.todayWaste,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 0.4, 0.6, 0.9],
            colors: [
              Color.fromARGB(255, 42, 70, 225),
              Color.fromARGB(255, 90, 42, 212),
              Colors.purpleAccent,
              Color.fromARGB(255, 51, 78, 236),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Text(
              userid,
              style: TextStyle(color: textColor, fontSize: 29),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Total House',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text('100'),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "||",
                              style: TextStyle(fontSize: 30),
                            ),
                            Text(
                              "||",
                              style: TextStyle(fontSize: 30),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Active House',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text('50'),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle button tap
                // Add your logic here
              },
              child: Text('Send Message'),
              style: ElevatedButton.styleFrom(
                primary: buttonColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CustomerDetails extends StatelessWidget {
  final String name;
  final int orderId;
  final String deliveryAddress;
  final String restaurantName;
  final String status;

  const CustomerDetails({
    Key? key,
    required this.name,
    required this.orderId,
    required this.deliveryAddress,
    required this.restaurantName,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: ListTile(
        title: Text('Order #$orderId'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer: $name'),
            Text('Address: $deliveryAddress'),
            Text('Restaurant: $restaurantName'),
            Text('Status: $status'),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            // Navigate to the customer details screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerDetailsScreen(
                  customerName: name,
                  orderId: orderId,
                ),
              ),
            );
            // Implement delivery details or status update functionality
          },
          child: const Text('View Details'),
        ),
      ),
    );
  }
}

class Customer {
  final String name;
  final int orderId;
  final String deliveryAddress;
  final String restaurantName;
  final String status;

  Customer({
    required this.name,
    required this.orderId,
    required this.deliveryAddress,
    required this.restaurantName,
    required this.status,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      name: json['name'],
      orderId: json['orderId'],
      deliveryAddress: json['deliveryAddress'],
      restaurantName: json['restaurantName'],
      status: json['status'],
    );
  }
}

class CustomerDetailsScreen extends StatelessWidget {
  final String customerName;
  final int orderId;

  const CustomerDetailsScreen({
    Key? key,
    required this.customerName,
    required this.orderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Details - $customerName'),
      ),
      body: Center(
        child: Text('Order details for $customerName with order ID #$orderId'),
      ),
    );
  }
}
