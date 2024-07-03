import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ktu_pro/signup/signup.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LocationScreenf extends StatefulWidget {
  final String latitude;
  final String longitude;
  final String email5;
  final String password;

  LocationScreenf(
      {required this.latitude,
      required this.longitude,
      required this.email5,
      required this.password,
      });

  @override
  _LocationScreenfState createState() => _LocationScreenfState();
}

class _LocationScreenfState extends State<LocationScreenf> {
  bool _locationFetched = true;
  String selectedCoordinates = '';

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
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: _locationFetched
              ? MapView(
                  latitude: widget.latitude,
                  longitude: widget.longitude,
                  onCoordinatesSelected: (String coordinates) {
                    setState(() {
                      selectedCoordinates = coordinates;
                    });
                  },
                )
              : Container(),
        ),
        Expanded(
          flex: 2,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                        Text(
                          'Selected Coordinates: $selectedCoordinates,',
                          style: const TextStyle(color: Colors.white60),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  selectedCoordinates.isNotEmpty
                      ? ElevatedButton(
                          onPressed: () {
                            // Navigating to another screen and passing latitude and longitude.
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpPage(email5: widget.email5, password: widget.password,  selectedlocation: selectedCoordinates,)
                              ),
                            );
                          },
                          child: Text('Confirm Location'),
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
  final String latitude;
  final String longitude;
  final Function(String) onCoordinatesSelected;

  const MapView(
      {Key? key,
      required this.latitude,
      required this.longitude,
      required this.onCoordinatesSelected})
      : super(key: key);

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
                '${coordinates['lng']},${coordinates['lat']}');
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
  <link href="https://unpkg.com/maplibre-gl@1.14.0/dist/maplibre-gl.css" rel="stylesheet" />
  <style>
    body { margin: 0; position: relative; }
    #map { height: calc(100vh - 50px); background-color: transparent; }
    .marker {
      width:50px;
      height: 50px;
      background-image: url('https://static.vecteezy.com/system/resources/previews/016/314/852/non_2x/map-pointer-icon-gps-location-symbol-maps-pin-location-map-icon-free-png.png');
      background-size: cover;
      background-color: transparent;
    }
    .button-container {
      position: absolute;
      bottom: 0;
      left: 0;
      width: 100%;
      padding: 10px 0;
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
  <div id="map"></div>
  <div class="button-container">
    <button class="confirm-button" onclick="showSelectedCoordinates()">Confirm Coordinates</button>
  </div>
  <script src="https://unpkg.com/maplibre-gl@1.14.0/dist/maplibre-gl.js"></script>
  <script>
    const apiKey = "$apiKey";
    const region = "$region";
    const mapName = "$mapName";
    const latt = $long;
    const longi = $lati;
    const styleUrl = `https://maps.geo.$region.amazonaws.com/maps/v0/maps/$mapName/style-descriptor?key=$apiKey`;
    const map = new maplibregl.Map({
      container: "map",
      style: styleUrl,
      center: [latt, longi],
      zoom: 11,
    });
    map.addControl(new maplibregl.NavigationControl(), "top-left");

    var marker = document.createElement('div');
    marker.className = 'marker';

    var markerElement = new maplibregl.Marker(marker)
        .setLngLat([latt, longi])
        .addTo(map);

    function showSelectedCoordinates() {
      var coordinates = markerElement.getLngLat();
      flutter_inappwebview.postMessage(JSON.stringify(coordinates));
    }

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
        .toString());
  }
}
