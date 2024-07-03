import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class LocationScreen extends StatefulWidget {
  final String latitude;
  final String longitude;

  LocationScreen({required this.latitude, required this.longitude});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String selectedCoordinates = '';
  String _username = '';
  String _area = '';
  String _email = '';
  String _ph = '';
  String _city = '';
  String _pinno = '';
  String _house_no = '';
  String _location ='';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String phoneNumber = prefs.getString('phoneNumber') ?? '';
      final response = await http.get(
        Uri.https(
          '3lehlczcqi5umgsp2v4yv2z2440karrn.lambda-url.ap-south-1.on.aws',
          '/path/to/endpoint',
          {'page': 'address', 'number': '$phoneNumber'},
        ),
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');

        final jsonData = json.decode(response.body);
        setState(() {
          _username = jsonData['fullname'];
          _house_no = jsonData['house_no'];
          _area = jsonData['area'];
          _city = jsonData['city'];
          _pinno = jsonData['pin_no'];
          _ph = jsonData['number'];
          _email = jsonData['email'];
          _location =jsonData['location'];
        });
      } else {
        _showErrorSnackbar('Failed to load data');
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackbar('No internet connection');
      print('Error: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _saveChanges(
      BuildContext context,
      String type,
      String fullName,
      String email,
      String houseNumber,
      String area,
      String city,
      String pin,
      String password,
      String email5,String location)
       async {
        Map<String, String> userData = {
    "number": email5,
    "area": area,
    "city": city,
    "email": email,
    "fullname": fullName,
    "house_no": houseNumber,
    "pin_no": pin,
    "password": password,
    "location": location,
  };

  String data = jsonEncode(userData);

  // Append query parameters directly to the URI
  final uri = Uri.https(
    'fnfmkp32x4on5vljtbdvlzoviq0bemmb.lambda-url.ap-south-1.on.aws',
    '/path/to/endpoint',
    {'type': type, 'data': data, 'number': email5},
  );

  
    try {
      final response = await http.get(uri);

      if (response.body == "success") {
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location Change Successfully'),
            duration: const Duration(seconds: 2),
          ),
        );
        print(response.body);
        Navigator.of(context).pop();

      } else {
                print(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.body),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      print('$error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error during request: '),
          duration: Duration(seconds: 2),
        ),
      );
    }
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
        onRefresh: _refreshData,
        child: Stack(
          children: [
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : MapView(
                  latitude: widget.latitude,
                  longitude: widget.longitude,
                  onCoordinatesSelected: (String coordinates) {
                    setState(() {
                      selectedCoordinates = coordinates;
                    });
                  },
                ),
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
                        const SizedBox(height: 20),
                        Text(
                          'Selected Coordinates: $selectedCoordinates',
                          style: const TextStyle(color: Colors.white60),
                        ),
                        const SizedBox(height: 20),
                         ElevatedButton(
  onPressed: () => _saveChanges(
    context,
    'change_address', // Type parameter should be 'update'
    _username,
    _email,
    _house_no,
    _area,
    _city,
    _pinno,'password',
    _ph,
    selectedCoordinates,
  ),
  child: Text('Save Location'),
),
                      ],
                    ),
                  ),
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

  const MapView({
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
              '${coordinates['lng']}, ${coordinates['lat']}',
            );
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
    #map { height: 100vh; background-color: transparent; }
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
</html>
""";

    _webViewController.loadUrl(
      Uri.dataFromString(
        htmlContent,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString(),
    );
  }
}
