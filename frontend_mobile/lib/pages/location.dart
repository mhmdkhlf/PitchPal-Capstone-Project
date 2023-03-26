import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

//TODO: page to be converted to components and added to first time log-in page

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
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
    print(longitude);
    print(latitude);
    final response = await dio.get(
      'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$latitude&longitude=$longitude&localityLanguage=en',
    );
    if (response.statusCode == 200) {
      final String countryName = response.data['countryName'];
      final String city = response.data['city'];
      final String locality = response.data['locality'];
      address = '$locality, $city, $countryName';
    } else {
      throw Exception('failed to create player profile');
    }
  }

  void getCurrentLocation() {
    _getCurrentPosition();
    _getCurrentAdress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location Page")),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('LAT: $latitude'),
              Text('LNG: $longitude'),
              Text(
                'Address: $address',
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: getCurrentLocation,
                child: const Text("Get Current Location"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
