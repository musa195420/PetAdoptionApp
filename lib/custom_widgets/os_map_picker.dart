import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:petadoption/helpers/constants.dart';
import 'package:petadoption/helpers/current_location.dart';

class OSMMapPickerScreen extends StatefulWidget {
  final double longitude;
  final double latitude;

  const OSMMapPickerScreen({
    super.key,
    required this.longitude,
    required this.latitude,
  });

  @override
  _OSMMapPickerScreenState createState() => _OSMMapPickerScreenState();
}

class _OSMMapPickerScreenState extends State<OSMMapPickerScreen> {
  late LatLng selectedLocation;
  String? address;

  @override
  void initState() {
    super.initState();
    selectedLocation = LatLng(widget.latitude, widget.longitude);
    _updateAddress();
  }

  Future<void> _updateAddress() async {
    String? result = await CurrentLocation().getAddressFromLatLngString(
      selectedLocation.latitude.toString(),
      selectedLocation.longitude.toString(),
    );
    setState(() {
      address = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color darkBrown = const Color(0xFF4E342E);
    Color brown = const Color(0xFF8D6E63);
    Color lightBrown = const Color(0xFFD7CCC8);

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [lightBrown, brown.withOpacity(0.9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Decorative wavy background shapes
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Map
          FlutterMap(
            options: MapOptions(
              initialCenter: selectedLocation,
              initialZoom: 13,
              onTap: (tapPosition, point) {
                setState(() {
                  selectedLocation = point;
                });
                _updateAddress();
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
                    width: 50,
                    height: 50,
                    point: selectedLocation,
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: Colors.red,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            height: 50,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              gradient: appBarGradient,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0, 3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'Select Location',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
          // Glassmorphic info card
          Positioned(
            top: 55,
            left: 20,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        const Color.fromARGB(255, 84, 31, 13).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color.fromARGB(255, 100, 10, 10)
                          .withOpacity(0.3),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.place, color: Colors.red, size: 38),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Selected Coordinates",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Lat: ${selectedLocation.latitude.toStringAsFixed(6)}",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white),
                            ),
                            Text(
                              "Lng: ${selectedLocation.longitude.toStringAsFixed(6)}",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white),
                            ),
                            if (address != null) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.location_city,
                                      size: 18, color: Colors.white70),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      address!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ]
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Confirm button
          Positioned(
            bottom: 30,
            left: 30,
            right: 30,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context, {
                  "latitude": selectedLocation.latitude,
                  "longitude": selectedLocation.longitude,
                  "address": address,
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: appBarGradient,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: darkBrown.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Confirm Location",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
