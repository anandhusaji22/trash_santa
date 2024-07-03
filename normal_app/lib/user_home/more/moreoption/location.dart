import 'dart:convert'; // Importing the 'dart:convert' library for JSON encoding and decoding.
import 'package:flutter/material.dart'; // Importing the Flutter material package.
import 'package:webview_flutter/webview_flutter.dart'; // Importing the WebView Flutter package.

// Defining a StatefulWidget for the LocationScreen.
class LocationScreen extends StatefulWidget {
  final String latitude; // The latitude of the location.
  final String longitude; // The longitude of the location.

  // Constructor for the LocationScreen widget.
  LocationScreen({required this.latitude, required this.longitude});

  @override
  _LocationScreenState createState() => _LocationScreenState(); // Creating the state for the widget.
}

// State class for the LocationScreen widget.
class _LocationScreenState extends State<LocationScreen> {
  bool _locationFetched = true; // Boolean to track if the location is fetched. Always true here.
  String selectedCoordinates = ''; // String to hold the selected coordinates.

  @override
  Widget build(BuildContext context) {
    // Building the widget tree.
    return Scaffold(
      appBar: AppBar(
        // AppBar for the screen.
        title: const Center(
          child: Text(
            'Location Screen', // Title text.
            style: TextStyle(color: Colors.white), // Text style.
          ),
        ),
        backgroundColor: Colors.transparent, // Transparent background color for app bar.
        elevation: 0, // No elevation for app bar.
      ),
      backgroundColor: const Color.fromARGB(255, 10, 4, 37), // Background color of the screen.
      body: Stack(
        // Stack widget to overlay content.
        children: [
          _buildContent(), // Building the main content.
          Align(
            // Aligning a widget at the bottom center of the screen.
            alignment: Alignment.bottomCenter,
            child: Container(
              // Container to display selected coordinates.
              padding: EdgeInsets.all(20),
              color: Colors.black.withOpacity(0.5), // Black with opacity for background color.
              child: Text(
                selectedCoordinates, // Displaying selected coordinates.
                style: TextStyle(color: Colors.white), // Text style.
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    // Function to build the main content.
    return Column(
      children: [
        Expanded(
          // Expanded widget to occupy available space.
          flex: 3,
          child: _locationFetched
              ? MapView(
                  // If location is fetched, display MapView widget.
                  latitude: widget.latitude,
                  longitude: widget.longitude,
                  onCoordinatesSelected: (String coordinates) {
                    setState(() {
                      selectedCoordinates = coordinates; // Update selected coordinates.
                    });
                  },
                )
              : Container(), // If location not fetched, display an empty container.
        ),
        Expanded(
          // Expanded widget for additional content.
          flex: 2,
          child: Center(
            // Centering the content vertically.
            child: Padding(
              padding: const EdgeInsets.all(15.0), // Padding for the content.
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Additional content like latitude, longitude, etc.
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Text('Latitude: ${widget.latitude}',
                            style: const TextStyle(color: Colors.white60)),
                        const SizedBox(height: 10),
                        Text('Longitude: ${widget.longitude}',
                            style: const TextStyle(color: Colors.white60)),
                        Text('Selected Coordinates: $selectedCoordinates,',
                          style: const TextStyle(color: Colors.white60)),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _locationFetched
                      ? Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MapView extends StatefulWidget {
  // Defining a StatefulWidget for the MapView.
  final String latitude; // Latitude of the location.
  final String longitude; // Longitude of the location.
  final Function(String) onCoordinatesSelected; // Callback function for selected coordinates.

  // Constructor for the MapView widget.
  const MapView(
      {Key? key,
      required this.latitude,
      required this.longitude,
      required this.onCoordinatesSelected})
      : super(key: key);

  @override
  _MapViewState createState() => _MapViewState(); // Creating the state for the widget.
}

// State class for the MapView widget.
class _MapViewState extends State<MapView> {
  late WebViewController _webViewController; // WebViewController for WebView.

  @override
  Widget build(BuildContext context) {
    // Building the WebView widget.
    return WebView(
      initialUrl: 'about:blank', // Initial URL for WebView.
      javascriptMode: JavascriptMode.unrestricted, // Enable unrestricted JavaScript execution.
      onWebViewCreated: (WebViewController webViewController) {
        _webViewController = webViewController; // Store the WebViewController.
        _loadHtmlFromAssets(widget.latitude, widget.longitude); // Load HTML content.
      },
      javascriptChannels: <JavascriptChannel>{
        // JavaScript channels for communication.
        JavascriptChannel(
          name: 'flutter_inappwebview',
          onMessageReceived: (JavascriptMessage message) {
            var coordinates = jsonDecode(message.message); // Decode JSON message.
            widget.onCoordinatesSelected(
                'Selected Coordinates: ${coordinates['lng']}, ${coordinates['lat']}'); // Pass selected coordinates.
          },
        ),
      },
    );
  }

  void _loadHtmlFromAssets(String lati, String long) async {
    // Function to load HTML content from assets.
    print('agetha$lati,$long'); // Logging latitude and longitude.
    String apiKey =
        "v1.public.eyJqdGkiOiI4YzAyNWFjOS1hYzQ1LTQzZWMtODExZC1jMTk0MzQyZGYyYzYifZT9n1E7Sqgl8j4Dj4aa_8GVIZf3OO3ILAr1LGq_yqUuZANyjd6krxhPPeNS-totkiFaY_CaVRx6bty7nbE6dGcnJxHjTqvvQtsFnxp6U_bLq0c7QvKyVJENEyVGmzA2IK3m4zj0mpkHaQPrhijjqw8NNK94zXD5NEmWKr-pr2cMXTRXA2KSWREbIO6Dpp4qXDCcMyFEun49wpHeH_f0K067UH188SeMZuGckgqsR_VUeNuMoLGZJkzR8YyxkYECLQHYeYrjwWFKzX3UtFtNYPDhTUUOFsqIM8Jkh328ATJFUUFcdWQ4Z6IQ6sQ-YPCqexVuLmLsV61vNZGrhRiim14.Njg1MGZlZTUtYTI2ZS00MDdlLWJjNDktMDNmZDlkNzVmMjQ0"; // API key.
    String region = "ap-south-1"; // Region.
    String mapName = "ptupro"; // Map name.

    String htmlContent = """
<!DOCTYPE html>
<html>
<head>
  <link href="https://unpkg.com/maplibre-gl@1.14.0/dist/maplibre-gl.css" rel="stylesheet" />
  <style>
    body { margin: 0; position: relative; } /* Set body position to relative */
    #map { height: calc(100vh - 50px); background-color: transparent; } /* Adjust height */
    .marker {
      width:50px; /* Adjust width as needed */
      height: 50px; /* Adjust height as needed */
      background-image: url('https://static.vecteezy.com/system/resources/previews/016/314/852/non_2x/map-pointer-icon-gps-location-symbol-maps-pin-location-map-icon-free-png.png'); /* URL of the location pointer image */
      background-size: cover;
      background-color: transparent; /* Set background color to transparent */
    }
    .button-container {
      position: absolute; /* Position the button absolutely */
      bottom: 0; /* Place at the bottom */
      left: 0; /* Align to the left */
      width: 100%; /* Full width */
      padding: 10px 0; /* Adjust padding */
      text-align: center;
    }
    .confirm-button {
      padding: 20px 40px;
      background-color: #007bff;
      color: #fff;
      border: none;
      cursor: pointer;
      border-radius: 5px;
      font-size: 18px;
    }
  </style>
</head>
<body>
  <!-- Map container -->
  <div id="map"></div>
  <!-- Button to confirm coordinates -->
  <div class="button-container">
    <button class="confirm-button" onclick="showSelectedCoordinates()">Confirm Coordinates</button>
  </div>
  <!-- JavaScript dependencies -->
  <script src="https://unpkg.com/maplibre-gl@1.14.0/dist/maplibre-gl.js"></script>
  <script>
    const apiKey = "$apiKey"; // API key
    const region = "$region"; // Region
    const mapName = "$mapName"; // Map name
    const latt = $long; // Latitude
    const longi = $lati; // Longitude
    // URL for style descriptor
    const styleUrl = `https://maps.geo.$region.amazonaws.com/maps/v0/maps/$mapName/style-descriptor?key=$apiKey`;
    // Initialize the map
    const map = new maplibregl.Map({
      container: "map",
      style: styleUrl,
      center: [latt, longi], // Use variables for coordinates
      zoom: 11,
    });
    map.addControl(new maplibregl.NavigationControl(), "top-left");

    // Create a marker element
    var marker = document.createElement('div');
    marker.className = 'marker';

    // Initialize marker at the center coordinates
    var markerElement = new maplibregl.Marker(marker)
        .setLngLat([latt, longi]) // Use variables for coordinates
        .addTo(map);

    // Function to display selected coordinates
    function showSelectedCoordinates() {
      var coordinates = markerElement.getLngLat();
      flutter_inappwebview.postMessage(JSON.stringify(coordinates));
    }

    // Event listener for map move event
    map.on('move', function() {
      var center = map.getCenter();
      markerElement.setLngLat(center);
    });
  </script>
</body>
</html>n
""";

    _webViewController.loadUrl(Uri.dataFromString(htmlContent,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString()); // Loading HTML content into the WebView.
  }
}
