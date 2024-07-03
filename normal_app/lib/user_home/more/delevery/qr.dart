import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QRScannerScreen(),
    );
  }
}

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  TextEditingController manualCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final PermissionStatus status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Camera Permission Required'),
          content: Text('Please grant camera permission to use this feature.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.white,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 300,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Align QR Code within the frame to scan',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      showDialogBox();
                    },
                    child: Text('Enter QR Code Manually'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // Do something with the scanned data
      print('Scanned data: ${scanData.code}');
      sendScannedData(scanData.code);
      showSuccessDialog(scanData.code);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void showDialogBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter QR Code Manually'),
          content: TextField(
            controller: manualCodeController,
            decoration: InputDecoration(hintText: 'Enter QR Code'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String manualCode = manualCodeController.text;
                // Do something with the manually entered code
                print('Manually entered code: $manualCode');
                sendScannedData(manualCode);
                showSuccessDialog(manualCode);
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showSuccessDialog(String? scannedData) {
    String dataToShow = scannedData ?? "No data";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('QR Code Scanned Successfully'),
          content: Text('Scanned Data: $dataToShow'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void sendScannedData(String? scannedData) async {
    if (scannedData != null) {
      final uri = Uri.https(
        'bkbxcbtffotkbhoehsqmpospzq0pqech.lambda-url.ap-south-1.on.aws',
        '/path/to/endpoint',
        {'data': scannedData},
      );

      try {
        final response = await http.get(uri);
        if (response.statusCode == 200) {
          // Handle response here, for example, display in a dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Response'),
                content: Text(response.body),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          throw Exception('Failed to send data');
        }
      } catch (error) {
        print('Error sending data: $error');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to send data: $error'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
