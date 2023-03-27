import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import '../data/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({
    super.key,
    required this.location,
  });

  final Location location;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String buttonText = "Get Current Location";
  late Position _currentPosition;
  double longitude = 0;
  double latitude = 0;
  String address = '';

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Location services are disabled. Please enable the services'),
          ),
        );
        return false;
      }
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permissions are denied'),
            ),
          );
          return false;
        }
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.'),
          ),
        );
        return false;
      }
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then(
      (Position position) {
        setState(() => _currentPosition = position);
        longitude = _currentPosition.longitude;
        latitude = _currentPosition.latitude;
      },
    ).catchError((e) {
      throw Exception(e);
    });
  }

  void _getCurrentAdress() async {
    final dio = Dio();
    final response = await dio.get(
      'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$latitude&longitude=$longitude&localityLanguage=en',
    );
    if (response.statusCode == 200) {
      final String countryName = response.data['countryName'];
      final String principalSubdivision = response.data['principalSubdivision'];
      final String locality = response.data['locality'];
      address = '$locality, $principalSubdivision, $countryName';
    } else {
      throw Exception('failed to create player profile');
    }
  }

  void getCurrentLocation() {
    _getCurrentPosition();
    _getCurrentAdress();
    widget.location.latitude = latitude;
    widget.location.longitude = longitude;
    widget.location.place = address;
    setState(() {
      buttonText = "Location Obtained";
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: getCurrentLocation,
      child: const Text("Get Current Location"),
    );
  }
}
