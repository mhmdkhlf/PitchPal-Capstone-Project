import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import '../data/location.dart';

class _Position {
  const _Position({
    required this.longitude,
    required this.latitude,
  });
  final double longitude, latitude;
}

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

  Future<_Position> _getCurrentPosition() async {
    double longitude = 0;
    double latitude = 0;
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) throw Exception("Can't get location. No permissions");
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
    return _Position(
      longitude: longitude,
      latitude: latitude,
    );
  }

  Future<String> _getCurrentAdress(_Position position) async {
    String address;
    final dio = Dio();
    final response = await dio.get(
      'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${position.latitude}&longitude=${position.longitude}&localityLanguage=en',
    );
    if (response.statusCode == 200) {
      final String countryName = response.data['countryName'];
      final String principalSubdivision = response.data['principalSubdivision'];
      final String locality = response.data['locality'];
      address = '$locality, $principalSubdivision, $countryName';
    } else {
      throw Exception('failed to create player profile');
    }
    return address;
  }

  void getCurrentLocation() async {
    _Position position = await _getCurrentPosition();
    String address = await _getCurrentAdress(position);
    widget.location.latitude = position.latitude;
    widget.location.longitude = position.longitude;
    widget.location.place = address;
    setState(() {
      buttonText = "Location Obtained";
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: getCurrentLocation,
      child: Text(buttonText),
    );
  }
}
