import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class CurrentLocation {
  Future<String> getAddressFromLatLngString(
      String? latitudeStr, String? longitudeStr) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        if (latitudeStr == null ||
            longitudeStr == null ||
            latitudeStr.trim().isEmpty ||
            longitudeStr.trim().isEmpty) {
          return "Not known";
        }

        final latitude = double.tryParse(latitudeStr);
        final longitude = double.tryParse(longitudeStr);

        if (latitude == null || longitude == null) {
          return "Not known";
        }
        debugPrint("logitude = $longitude  latitude = $latitudeStr");
        final placemarks = await placemarkFromCoordinates(latitude, longitude);

        if (placemarks.isEmpty) {
          return "Not known";
        }

        final placemark = placemarks.first;
        final city = placemark.locality ?? '';
        final state = placemark.administrativeArea ?? '';
        final country = placemark.country ?? '';

        // If all fields are empty, it's unknown
        if (city.isEmpty && state.isEmpty && country.isEmpty) {
          return "Not known";
        }

        debugPrint('City: $city, State: $state, Country: $country');
        return 'City: $city, State: $state, Country: $country';
      } else {
        return "Not Supported on Windows";
      }
    } catch (e, s) {
      debugPrint('Error in reverse geocoding: $e\nStack: $s');
      return "Not known";
    }
  }

  Future<String?> getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        String city = placemark.locality ?? '';
        String state = placemark.administrativeArea ?? '';
        String country = placemark.country ?? '';
        debugPrint('City: $city, State: $state, Country: $country');
        return 'City: $city, State: $state, Country: $country';
      }
    } catch (e) {
      debugPrint('Error in reverse geocoding 2: $e');
    }
    return null;
  }

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
