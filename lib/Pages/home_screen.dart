import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/Pages/splash_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyHomePage extends StatefulWidget {
  Weather w;
  String location;
  WeatherFactory wf;
  MyHomePage({
    super.key,
    required this.w,
    required this.location,
    required this.wf,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  String? wallpaper;
  String getwallpaper(String des) {
    if (des == "clear sky") {
      return "assets/wallpaper/clear_sky.jpg";
    } else if (des == "few clouds") {
      return "assets/wallpaper/few_clouds.png";
    } else if (des == "scattered clouds") {
      return "assets/wallpaper/scattered_clouds.jpg";
    } else if (des == "broken clouds") {
      return "assets/wallpaper/broken_clouds.jpg";
    } else if (des == "shower rain") {
      return "assets/wallpaper/shower_rain.jpg";
    } else if (des == "rain") {
      return "assets/wallpaper/rain.jpg";
    } else if (des == "thunderstrom") {
      return "assets/wallpaper/thunderstrom.jpg";
    } else if (des == "snow") {
      return "assets/wallpaper/snow.jpg";
    } else if (des == "mist" || des == "haze") {
      return "assets/wallpaper/mist.jpg";
    } else {
      return "assets/wallpaper/clear_sky.jpg";
    }
  }

  String? weathericon;
  String geticon(String des) {
    if (des == "clear sky") {
      return "assets/images/clear_sky.png";
    } else if (des == "few clouds") {
      return "assets/images/few_cloud.png";
    } else if (des == "scattered clouds") {
      return "assets/images/scattered_clouds.png";
    } else if (des == "broken clouds") {
      return "assets/images/broken_clouds.png";
    } else if (des == "shower rain") {
      return "assets/images/shower_rain.png";
    } else if (des == "rain") {
      return "assets/images/rain.png";
    } else if (des == "thunderstrom") {
      return "assets/images/thunderstrom.png";
    } else if (des == "snow") {
      return "assets/images/snow.png";
    } else if (des == "mist" || des == "haze") {
      return "assets/images/mist.png";
    } else {
      return "assets/images/clear_sky.png";
    }
  }

  void getweather(String location) async {
    try {
      Weather w = await widget.wf.currentWeatherByCityName(location);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    w: w,
                    location: location,
                    wf: widget.wf,
                  )));
    } on OpenWeatherAPIException catch (ex) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
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

  void _onRefresh() {
    return getweather(widget.location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
            getwallpaper(widget.w.weatherDescription.toString()),
          ),
          fit: BoxFit.cover,
        )),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10),
              child: ListTile(
                title: Text(
                  widget.w.areaName.toString() +
                      "," +
                      widget.w.country.toString(),
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search),
                  color: Colors.white,
                ),
              ),
            ),
            Divider(
              thickness: 0.8,
              color: Colors.grey,
            ),
            Expanded(
              child: SmartRefresher(
                controller: RefreshController(),
                enablePullDown: true,
                onRefresh: _onRefresh,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage(
                            geticon(widget.w.weatherDescription.toString())),
                      )),
                    ),
                    Center(
                      child: Container(
                        child: Text(
                          widget.w.temperature.toString().split(" ").first +
                              "\u1d52" +
                              "C",
                          style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        margin: EdgeInsets.only(top: 0),
                      ),
                    ),
                    Center(
                      child: Text(
                        widget.w.tempMax.toString().split(" ").first +
                            "\u1d52" +
                            "C" +
                            '/' +
                            widget.w.tempMin.toString().split(" ").first +
                            "\u1d52" +
                            "C",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Feels like: " +
                            widget.w.tempFeelsLike.toString().split(" ").first +
                            "\u1d52" +
                            "C",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    Center(
                      child: Text(
                        widget.w.weatherDescription.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.2),
                            Colors.black.withOpacity(0.2)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Image(
                                  image: AssetImage("assets/images/windd.png")),
                              title: Text(
                                "Wind Speed: ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              trailing: Text(
                                widget.w.windSpeed.toString() + "m/s",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                            Divider(
                              thickness: 0.5,
                              color: Colors.grey,
                            ),
                            ListTile(
                              leading: Image(
                                  image: AssetImage(
                                      "assets/images/windsockk.png")),
                              title: Text(
                                "Wind Direction: ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              trailing: Text(
                                widget.w.windDegree.toString() + "\u1d52",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                            Divider(
                              thickness: 0.5,
                              color: Colors.grey,
                            ),
                            ListTile(
                              leading: Image(
                                  image:
                                      AssetImage("assets/images/clouds.png")),
                              title: Text(
                                "Clouds: ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              trailing: Text(
                                widget.w.cloudiness.toString() + "%",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                            Divider(
                              thickness: 0.5,
                              color: Colors.grey,
                            ),
                            ListTile(
                              leading: Image(
                                  image:
                                      AssetImage("assets/images/pressure.png")),
                              title: Text(
                                "Pressure: ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              trailing: Text(
                                widget.w.pressure.toString() + "hPa",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                            Divider(
                              thickness: 0.5,
                              color: Colors.grey,
                            ),
                            ListTile(
                              leading: Image(
                                  image:
                                      AssetImage("assets/images/humidity.png")),
                              title: Text(
                                "Humidity: ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              trailing: Text(
                                widget.w.humidity.toString() + "%",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.2),
                            Colors.black.withOpacity(0.2)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              margin: EdgeInsets.only(bottom: 0),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: const AssetImage(
                                          "assets/images/sunrise.png"),
                                      fit: BoxFit.fill)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Column(
                                children: [
                                  Text(
                                      "Sun Rise: " +
                                          widget.w.sunrise
                                              .toString()
                                              .split(" ")[1]
                                              .split(".")
                                              .first,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18)),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                      "Sun Set: " +
                                          widget.w.sunset
                                              .toString()
                                              .split(" ")[1]
                                              .split(".")
                                              .first,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
