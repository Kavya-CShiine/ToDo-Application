import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocationMapScreen(),
    );
  }
}

class LocationMapScreen extends StatefulWidget {
  @override
  _LocationMapScreenState createState() => _LocationMapScreenState();
}

class _LocationMapScreenState extends State<LocationMapScreen> {
  GoogleMapController? mapController;
  LatLng _currentLocation = LatLng(0.0, 0.0);
  Set<Marker> _markers = {};
  String _locationMessage = "";

  // Method to get the current location
  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _locationMessage = "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
      });

      // Add a marker for the current location
      _addMarker(_currentLocation);

      // Display nearby locations within 5 km radius
      _displayNearbyLocations();
      
      // Move the camera to the user's current location
      mapController?.animateCamera(CameraUpdate.newLatLngZoom(_currentLocation, 12));
    } else {
      setState(() {
        _locationMessage = "Location permission denied!";
      });
    }
  }

  // Method to add a marker
  void _addMarker(LatLng position) {
    _markers.add(Marker(
      markerId: MarkerId('current_location'),
      position: position,
      infoWindow: InfoWindow(title: "Your Location"),
    ));
  }

  // Method to display nearby locations within a 5 km radius
  void _displayNearbyLocations() {
    // Here we are using dummy data for nearby locations (just as an example)
    List<LatLng> nearbyLocations = [
      LatLng(_currentLocation.latitude + 0.05, _currentLocation.longitude), // 5 km East
      LatLng(_currentLocation.latitude - 0.05, _currentLocation.longitude), // 5 km West
      LatLng(_currentLocation.latitude, _currentLocation.longitude + 0.05), // 5 km North
      LatLng(_currentLocation.latitude, _currentLocation.longitude - 0.05), // 5 km South
    ];

    // Add markers for each nearby location within the radius
    for (var location in nearbyLocations) {
      double distance = _calculateDistance(_currentLocation, location);
      if (distance <= 5) {
        _markers.add(Marker(
          markerId: MarkerId('nearby_location_${location.latitude}_${location.longitude}'),
          position: location,
          infoWindow: InfoWindow(title: "Nearby Location"),
        ));
      }
    }

    setState(() {});
  }

  // Method to calculate distance between two lat/lng points
  double _calculateDistance(LatLng start, LatLng end) {
    const int earthRadius = 6371; // Radius of the Earth in kilometers
    double dLat = _degToRad(end.latitude - start.latitude);
    double dLon = _degToRad(end.longitude - start.longitude);
    double a = 
        (sin(dLat / 2) * sin(dLat / 2)) + 
        cos(_degToRad(start.latitude)) * cos(_degToRad(end.latitude)) * 
        (sin(dLon / 2) * sin(dLon / 2));
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c; // Distance in kilometers
  }

  // Method to convert degrees to radians
  double _degToRad(double deg) {
    return deg * (pi / 180);
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Get location when screen is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nearby Locations within 5 km")),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLocation,
                zoom: 14,
              ),
              onMapCreated: (controller) {
                mapController = controller;
              },
              markers: _markers,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _locationMessage,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: Icon(Icons.location_on),
      ),
    );
  }
}

