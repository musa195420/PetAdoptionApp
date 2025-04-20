import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
class CurrentLocation{

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
    debugPrint('Error in reverse geocoding: $e');
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