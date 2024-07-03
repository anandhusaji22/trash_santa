import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Order {
  final String orderId;
  final String customerName;
  final String deliveryAddress;
  final String restaurantName;
  final String status;
  final LatLng userLocation;
  final LatLng deliveryLocation;

  Order({
    required this.orderId,
    required this.customerName,
    required this.deliveryAddress,
    required this.restaurantName,
    required this.status,
    required this.userLocation,
    required this.deliveryLocation,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      customerName: json['customerName'],
      deliveryAddress: json['deliveryAddress'],
      restaurantName: json['restaurantName'],
      status: json['status'],
      userLocation: LatLng(json['userLocation']['latitude'], json['userLocation']['longitude']),
      deliveryLocation: LatLng(json['deliveryLocation']['latitude'], json['deliveryLocation']['longitude']),
    );
  }
}

class LocationScreen extends StatefulWidget {
  final String latitude;
  final String longitude;

  LocationScreen({required this.latitude, required this.longitude});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _locationFetched = true;
  bool _isLoading = false;
  List<Order> _orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders(); // Fetch data when screen initializes
  }
Future<void> _fetchOrders() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
      String phoneNumber = prefs.getString('phoneNumber') ?? '';
  final queryParameters = {
    'page':'map',
      'number': phoneNumber
    };
  setState(() {
    _isLoading = true;
  });
 final uri = Uri.https(
      '3lehlczcqi5umgsp2v4yv2z2440karrn.lambda-url.ap-south-1.on.aws',
      '/path/to/endpoint',
      queryParameters,
    );
  try {
      final response = await http.get(uri);
    if (response.statusCode == 200) {
      print(response.body);
      final jsonData = json.decode(response.body) as List<dynamic>;
      setState(() {
        _orders = jsonData.map((item) {
          final orderData = item as Map<String, dynamic>;
          final mobileNo = orderData['mobile_no']['S'] as String;
          final location = orderData['location']['S'].split(',');
          final latitude = double.parse(location[1]);
          final longitude = double.parse(location[0]);
          final address = orderData['address']['S'] as String;
          final name = orderData['name']['S'] as String;
          final state = orderData['state']['BOOL'] as bool;
          return Order(
            orderId: mobileNo,
            customerName: name,
            deliveryAddress: address,
            restaurantName: '', // You can set this to an appropriate value
            status: state ? 'Active' : 'Inactive',
            userLocation: LatLng(latitude, longitude),
            deliveryLocation: LatLng(latitude, longitude),
          );
        }).toList();
      });
    } else {
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load orders'),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: No internet.Try again'),
      ),
    );
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}


  Future<void> _refreshOrders() async {
    await _fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Location Screen',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 10, 4, 37),
      body: RefreshIndicator(
        onRefresh: _refreshOrders,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 1,
                  child: _locationFetched
                      ? MapView(
                          latitude: widget.latitude,
                          longitude: widget.longitude,
                          onCoordinatesSelected: (String coordinates) {
                            // Handle coordinates selection if needed
                          },
                        )
                      : Container(),
                ),
                Expanded(
                  flex: 1,
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : _orders.isEmpty
                          ? Center(
                              child: Text('No data found'),
                            )
                          : ListView.builder(
                              itemCount: _orders.length,
                              itemBuilder: (context, index) {
                                final order = _orders[index];
                                return Card(
                                  margin: EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text('Order #${order.orderId}'),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Customer: ${order.customerName}'),
                                        Text('Address: ${order.deliveryAddress}'),
                                        Text('Restaurant: ${order.restaurantName}'),
                                        Text('Status: ${order.status}'),
                                      ],
                                    ),
                                    trailing: ElevatedButton(
                                      onPressed: () {
                                        _navigateToOrderDetails(order.orderId, order.customerName);
                                      },
                                      child: Text('View Details'),
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToOrderDetails(String orderId, String customerName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerDetailsScreen(
          orderId: orderId,
          customerName: customerName,
        ),
      ),
    );
  }
}

class MapView extends StatefulWidget {
  final String latitude;
  final String longitude;
  final Function(String) onCoordinatesSelected;

  MapView({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.onCoordinatesSelected,
  }) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'about:blank',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _webViewController = webViewController;
        _loadHtmlFromAssets(widget.latitude, widget.longitude);
      },
      javascriptChannels: <JavascriptChannel>{
        JavascriptChannel(
          name: 'flutter_inappwebview',
          onMessageReceived: (JavascriptMessage message) {
            var coordinates = jsonDecode(message.message);
            widget.onCoordinatesSelected(
                'Selected Coordinates: ${coordinates['lng']}, ${coordinates['lat']}');
          },
        ),
      },
    );
  }

  void _loadHtmlFromAssets(String lati, String long) async {
    String apiKey =
        "v1.public.eyJqdGkiOiI4YzAyNWFjOS1hYzQ1LTQzZWMtODExZC1jMTk0MzQyZGYyYzYifZT9n1E7Sqgl8j4Dj4aa_8GVIZf3OO3ILAr1LGq_yqUuZANyjd6krxhPPeNS-totkiFaY_CaVRx6bty7nbE6dGcnJxHjTqvvQtsFnxp6U_bLq0c7QvKyVJENEyVGmzA2IK3m4zj0mpkHaQPrhijjqw8NNK94zXD5NEmWKr-pr2cMXTRXA2KSWREbIO6Dpp4qXDCcMyFEun49wpHeH_f0K067UH188SeMZuGckgqsR_VUeNuMoLGZJkzR8YyxkYECLQHYeYrjwWFKzX3UtFtNYPDhTUUOFsqIM8Jkh328ATJFUUFcdWQ4Z6IQ6sQ-YPCqexVuLmLsV61vNZGrhRiim14.Njg1MGZlZTUtYTI2ZS00MDdlLWJjNDktMDNmZDlkNzVmMjQ0";
    String region = "ap-south-1";
    String mapName = "ptupro";

    String htmlContent = """
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link href="https://unpkg.com/maplibre-gl@1.14.0/dist/maplibre-gl.css" rel="stylesheet" />
  <style>
    body { margin: 0; padding: 0; } /* Set margin and padding to zero */
    #map { height: 100vh; } /* Set map container height to fill viewport */
    .marker {
      width: 30px; /* Adjust width as needed */
      height: 40px; /* Adjust height as needed */
      background-image: url('https://static.vecteezy.com/system/resources/previews/016/314/852/non_2x/map-pointer-icon-gps-location-symbol-maps-pin-location-map-icon-free-png.png'); /* URL of the location pointer image */
      background-size: cover;
      background-color: transparent; /* Set background color to transparent */
      transform-origin: center bottom; /* Set the transform origin */
      transform: rotate(0deg); /* Initialize rotation to 0 degrees */
    }
    .live-marker {
      width: 30px; /* Adjust width as needed */
      height: 30px; /* Adjust height as needed */
      background-image: url('https://static.thenounproject.com/png/1353841-200.png'); /* URL of the live location image */
      background-size: cover;
      background-color: transparent; /* Set background color to transparent */
      transform-origin: center bottom; /* Set the transform origin */
      transform: rotate(0deg); /* Initialize rotation to 0 degrees */
    }
  </style>
</head>
<body>
  <!-- Map container -->
  <div id="map"></div>
  <!-- JavaScript dependencies -->
  <script src="https://unpkg.com/maplibre-gl@1.14.0/dist/maplibre-gl.js"></script>
  <script>
    const apiKey = "v1.public.eyJqdGkiOiI4YzAyNWFjOS1hYzQ1LTQzZWMtODExZC1jMTk0MzQyZGYyYzYifZT9n1E7Sqgl8j4Dj4aa_8GVIZf3OO3ILAr1LGq_yqUuZANyjd6krxhPPeNS-totkiFaY_CaVRx6bty7nbE6dGcnJxHjTqvvQtsFnxp6U_bLq0c7QvKyVJENEyVGmzA2IK3m4zj0mpkHaQPrhijjqw8NNK94zXD5NEmWKr-pr2cMXTRXA2KSWREbIO6Dpp4qXDCcMyFEun49wpHeH_f0K067UH188SeMZuGckgqsR_VUeNuMoLGZJkzR8YyxkYECLQHYeYrjwWFKzX3UtFtNYPDhTUUOFsqIM8Jkh328ATJFUUFcdWQ4Z6IQ6sQ-YPCqexVuLmLsV61vNZGrhRiim14.Njg1MGZlZTUtYTI2ZS00MDdlLWJjNDktMDNmZDlkNzVmMjQ0"; // API key
    const region = "ap-south-1"; // Region
    const mapName = "ptupro"; // Map name
    // URL for style descriptor
    const styleUrl = https://maps.geo.${region}.amazonaws.com/maps/v0/maps/${mapName}/style-descriptor?key=${apiKey};
    // Initialize the map
    const map = new maplibregl.Map({
      container: "map",
      style: styleUrl,
      center: [76.31561302693645, 9.916996365230167], // Default coordinates
      zoom: 10,
    });
    map.addControl(new maplibregl.NavigationControl(), "top-left");

    // Define an array of coordinates
    const coordinatesArray = [
      [76.31561302693645, 9.916996365230167],
      [76.32561302693645, 9.926996365230167],
      [76.33561302693645, 9.936996365230167]
    ];

    // Create markers for each coordinate
    coordinatesArray.forEach(coordinates => {
      // Create a marker element
      var marker = document.createElement('div');
      marker.className = 'marker';

      // Initialize marker at the coordinates
      var markerElement = new maplibregl.Marker(marker)
          .setLngLat(coordinates)
          .addTo(map);
    });

    // Get user's live location using Geolocation API
    if (navigator.geolocation) {
      navigator.geolocation.watchPosition(position => {
        const { latitude, longitude, heading } = position.coords;
        // Create a marker for the live location
        var liveMarker = document.createElement('div');
        liveMarker.className = 'marker live-marker';

        // Initialize live marker at the live location coordinates
        var liveMarkerElement = new maplibregl.Marker(liveMarker)
            .setLngLat([longitude, latitude])
            .setRotation(heading) // Set rotation based on the heading
            .addTo(map);
      }, error => {
        console.error('Error getting geolocation:', error);
      }, {
        enableHighAccuracy: true, // Enable high accuracy for better results
        maximumAge: 0,
        timeout: 5000
      });
    } else {
      console.error('Geolocation is not supported by this browser.');
    }
  </script>
</body>
</html>
""";

    _webViewController.loadUrl(Uri.dataFromString(htmlContent,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}

class CustomerDetailsScreen extends StatelessWidget {
  final String customerName;
  final String orderId;

  CustomerDetailsScreen({required this.customerName, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Customer Name: $customerName'),
            Text('Order ID: $orderId'),
            // Add more customer details here if needed
          ],
        ),
      ),
    );
  }
}
