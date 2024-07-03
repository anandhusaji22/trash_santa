// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:santa/widges/drawn.dart';

// class Order {
//   final String orderId;
//   final String customerName;
//   final String deliveryAddress;
//   final String restaurantName;
//   final String status;

//   Order({
//     required this.orderId,
//     required this.customerName,
//     required this.deliveryAddress,
//     required this.restaurantName,
//     required this.status,
//   });
// }

// class DeliveryPartnerScreen extends StatefulWidget {
//   @override
//   _DeliveryPartnerScreenState createState() => _DeliveryPartnerScreenState();
// }

// class _DeliveryPartnerScreenState extends State<DeliveryPartnerScreen> {
//   List<Order> orders = [];
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   Future<void> _fetchOrders() async {
//     // Simulated URL with your actual HTTP endpoint
//     var response = await http.get(Uri.parse('https://your-api-endpoint.com/orders'));
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       setState(() {
//         orders = List<Order>.from(data.map((order) => Order(
//               orderId: order['orderId'],
//               customerName: order['customerName'],
//               deliveryAddress: order['deliveryAddress'],
//               restaurantName: order['restaurantName'],
//               status: order['status'],
//             )));
//       });
//     } else {
//       throw Exception('Failed to load orders');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchOrders();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         title: const Text('Home Automation'),
//         actions: [
//           // More button to open the drawer
//           IconButton(
//             icon: const Icon(Icons.more_vert),
//             onPressed: () {
//               _scaffoldKey.currentState!.openDrawer();
//             },
//           ),
//         ],
//       ),
//       // Drawer using MainDrawer4
//       drawer: MainDrawer4(),
//       body: Column(
//         children: [
//           Container(
//             height: MediaQuery.of(context).size.height / 4,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.black),
//             ),
//             child: const Center(
//               child: Text('Your content here'),
//             ),
//           ),
//           Expanded(
//             child: RefreshIndicator(
//               onRefresh: _fetchOrders,
//               child: Center(
//                 child: ListView.builder(
//                   itemCount: orders.length,
//                   itemBuilder: (context, index) {
//                     final order = orders[index];
//                     return Card(
//                       margin: const EdgeInsets.all(8.0),
//                       child: ListTile(
//                         title: Text('Order #${order.orderId}'),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Customer: ${order.customerName}'),
//                             Text('Address: ${order.deliveryAddress}'),
//                             Text('Restaurant: ${order.restaurantName}'),
//                             Text('Status: ${order.status}'),
//                           ],
//                         ),
//                         trailing: ElevatedButton(
//                           onPressed: () {
//                             // Implement delivery details or status update functionality
//                           },
//                           child: const Text('View Details'),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
