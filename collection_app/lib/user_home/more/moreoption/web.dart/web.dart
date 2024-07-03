// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'dart:convert';
// import 'dart:io';

// class MapView extends StatefulWidget {
//   @override
//   _MapViewState createState() => _MapViewState();
// }

// class _MapViewState extends State<MapView> {
//   @override
//   void initState() {
//     super.initState();
//     // Enable hybrid composition for Android
//     if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Map View'),
//       ),
//       body: WebView(
//         initialUrl: 'about:blank',
//         javascriptMode: JavascriptMode.unrestricted,
//         onWebViewCreated: (WebViewController webViewController) {
//           _loadHtmlFromAssets(webViewController);
//         },
//       ),
//     );
//   }

//   void _loadHtmlFromAssets(WebViewController webViewController) {
//     String apiKey = "v1.public.eyJqdGkiOiI4YzAyNWFjOS1hYzQ1LTQzZWMtODExZC1jMTk0MzQyZGYyYzYifZT9n1E7Sqgl8j4Dj4aa_8GVIZf3OO3ILAr1LGq_yqUuZANyjd6krxhPPeNS-totkiFaY_CaVRx6bty7nbE6dGcnJxHjTqvvQtsFnxp6U_bLq0c7QvKyVJENEyVGmzA2IK3m4zj0mpkHaQPrhijjqw8NNK94zXD5NEmWKr-pr2cMXTRXA2KSWREbIO6Dpp4qXDCcMyFEun49wpHeH_f0K067UH188SeMZuGckgqsR_VUeNuMoLGZJkzR8YyxkYECLQHYeYrjwWFKzX3UtFtNYPDhTUUOFsqIM8Jkh328ATJFUUFcdWQ4Z6IQ6sQ-YPCqexVuLmLsV61vNZGrhRiim14.Njg1MGZlZTUtYTI2ZS00MDdlLWJjNDktMDNmZDlkNzVmMjQ0"; // API key
//     String region = "ap-south-1"; // Region
//     String mapName = "ptupro"; // Map name
//     String htmlContent = """
//   <!DOCTYPE html>
// <html>
// <head>
//   <meta name="viewport" content="width=device-width, initial-scale=1.0">
//   <link href="https://unpkg.com/maplibre-gl@1.14.0/dist/maplibre-gl.css" rel="stylesheet" />
//   <style>
//     body { margin: 0; }
//     #map { width: 100%; height: 100vh; }
//     .marker {
//       width: 30px; /* Adjust width as needed */
//       height: 40px; /* Adjust height as needed */
//       background-image: url('https://static.vecteezy.com/system/resources/previews/016/314/852/non_2x/map-pointer-icon-gps-location-symbol-maps-pin-location-map-icon-free-png.png'); /* URL of the location pointer image */
//       background-size: cover;
//       background-color: transparent; /* Set background color to transparent */
//     }
//     .button-container {
//       margin-top: 10px;
//       text-align: center;
//     }
//     .confirm-button {
//       padding: 10px 20px;
//       background-color: #007bff;
//       color: #fff;
//       border: none;
//       cursor: pointer;
//       border-radius: 5px;
//     }
//   </style>
// </head>
// <body>
//   <!-- Map container -->
//   <div id="map"></div>
//   <!-- Button to confirm coordinates -->
//   <div class="button-container">
//     <button class="confirm-button" onclick="showSelectedCoordinates()">Confirm Coordinates</button>
//   </div>
//   <!-- JavaScript dependencies -->
//   <script src="https://unpkg.com/maplibre-gl@1.14.0/dist/maplibre-gl.js"></script>
//   <script>
   
//     // URL for style descriptor
//     const styleUrl = 'https://maps.geo.${region}.amazonaws.com/maps/v0/maps/${mapName}/style-descriptor?key=${apiKey}';
//     // Initialize the map
//     const map = new maplibregl.Map({
//       container: "map",
//       style: styleUrl,
//       center: [76.31561302693645, 9.916996365230167], // Adjusted coordinates
//       zoom: 11,
//     });
//     map.addControl(new maplibregl.NavigationControl(), "top-left");

//     // Create a marker element
//     var marker = document.createElement('div');
//     marker.className = 'marker';

//     // Initialize marker at the center coordinates
//     var markerElement = new maplibregl.Marker(marker)
//         .setLngLat([76.31561302693645, 9.916996365230167])
//         .addTo(map);

//     // Function to display selected coordinates
//     function showSelectedCoordinates() {
//       var coordinates = markerElement.getLngLat();
//       var lat = coordinates.lat;
//       var lon = coordinates.lng;
//       alert('Selected Coordinates: ' + lon + ', ' + lat);
//     }

//     // Event listener for map move event
//     map.on('move', function() {
//       var center = map.getCenter();
//       markerElement.setLngLat(center);
//     });
//   </script>
// </body>
// </html>
//     """;

//     webViewController.loadUrl(Uri.dataFromString(htmlContent,
//         mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
//         .toString());
//   }
// }
