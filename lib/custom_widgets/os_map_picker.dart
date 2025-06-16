// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class OSMMapPickerScreen extends StatefulWidget {
  final double longitude;
  final double latitude;

  const OSMMapPickerScreen(
      {super.key, required this.longitude, required this.latitude});
  @override
  _OSMMapPickerScreenState createState() => _OSMMapPickerScreenState();
}

class _OSMMapPickerScreenState extends State<OSMMapPickerScreen> {
  late LatLng selectedLocation;

  @override
  void initState() {
    super.initState();
    selectedLocation = LatLng(widget.latitude, widget.longitude);
  } // default: Islamabad

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pick Location')),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: selectedLocation,
              initialZoom: 13,
              onTap: (tapPosition, point) {
                setState(() {
                  selectedLocation = point;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 40,
                    height: 40,
                    point: selectedLocation,
                    child:
                        Icon(Icons.location_pin, color: Colors.red, size: 40),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  "latitude": selectedLocation.latitude,
                  "longitude": selectedLocation.longitude,
                });
              },
              child: Text("Confirm Location"),
            ),
          )
        ],
      ),
    );
  }
}
