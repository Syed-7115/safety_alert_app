import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const SafetyApp());
}

class SafetyApp extends StatelessWidget {
  const SafetyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SOSScreen(),
    );
  }
}

class SOSScreen extends StatefulWidget {
  @override
  _SOSScreenState createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> {

  final String emergencyNumber = "7780778332"; // CHANGE NUMBER

  Future<void> sendSOS() async {

    // Get location permission
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    String locationLink =
        "https://www.google.com/maps?q=${position.latitude},${position.longitude}";

    String message = "HELP! I am in danger. My location: $locationLink";

    // Open SMS app
    final Uri smsUri = Uri.parse("sms:$emergencyNumber?body=$message");
    await launchUrl(smsUri);

    // Make phone call
    final Uri callUri = Uri.parse("tel:$emergencyNumber");
    await launchUrl(callUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        title: const Text("Safety Alert"),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: sendSOS,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.all(40),
            shape: const CircleBorder(),
          ),
          child: const Text(
            "SOS",
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      ),
    );
  }
}