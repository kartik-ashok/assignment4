// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class LocationPage extends StatefulWidget {
//   @override
//   _LocationPageState createState() => _LocationPageState();
// }

// class _LocationPageState extends State<LocationPage> {
//   static const platform = MethodChannel('com.example/location');

//   String _location = "Unknown";

//   Future<void> _getLocation() async {
//     try {
//       final result = await platform.invokeMethod('getCurrentLocation');
//       setState(() {
//         _location = "Lat: ${result['latitude']}, Lon: ${result['longitude']}";
//       });
//     } on PlatformException catch (e) {
//       setState(() {
//         _location = "Failed to get location: ${e.message}";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Geolocation via Platform Channel")),
//       body: Center(child: Text(_location)),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.my_location),
//         onPressed: _getLocation,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  static const platform = MethodChannel('com.example/location');

  String _location = "Unknown";

  Future<void> _getLocation() async {
    try {
      final result = await platform.invokeMethod('getCurrentLocation');

      setState(() {
        final latitude = result['latitude'] ?? "N/A";
        final longitude = result['longitude'] ?? "N/A";
        final address = result['address'] ?? "Unknown address";

        _location = "Lat: $latitude, Lon: $longitude\nAddress: $address";
      });
    } on PlatformException catch (e) {
      setState(() {
        _location = "Failed to get location: ${e.message}";
      });
    } catch (e) {
      setState(() {
        _location = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Geolocation via Platform Channel")),
      body: Center(child: Text(_location, textAlign: TextAlign.center)),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.my_location),
        onPressed: _getLocation,
      ),
    );
  }
}
