import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/Pages/home_screen.dart';
import 'package:weather_app/main.dart';
import 'package:lottie/lottie.dart';
import 'package:location/location.dart';

Location location = new Location();
bool _serviceEnabled = false;
PermissionStatus? _permissionGranted;
//sdfgfgf
Future<dynamic> getLoc() async {
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
  }

  LocationData _locationData = await location.getLocation();

  return _locationData;
}

class SplashScreen extends StatefulWidget {
  final WeatherFactory wf;
  const SplashScreen({super.key, required this.wf});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String location = "Delhi";
  double lat = 0, lot = 0;

  void getweather(String location) async {
    Weather w;

    LocationData _loc = await getLoc();

    try {
      w = await widget.wf
          .currentWeatherByLocation(_loc.latitude!, _loc.longitude!);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    w: w,
                    location: w.areaName.toString(),
                    wf: widget.wf,
                  )));
    } on OpenWeatherAPIException catch (ex) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(ex.toString()),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"))
              ],
            );
          });
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      getweather(location);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Lottie.asset("assets/aniamtion/11.json")),
      ),
    );
  }
}
