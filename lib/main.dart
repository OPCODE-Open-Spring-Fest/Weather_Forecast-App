import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/Pages/splash_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

WeatherFactory wf = new WeatherFactory("ad461b71ad7b18def4419e29d7a0e6ee");
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: SplashScreen(
          wf: wf,
        ));
  }
}
