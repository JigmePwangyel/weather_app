import 'dart:async';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/Service/Weather_Service.dart';

import '../Models/Weather_Model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //API KEY
  final _weatherService =
      WeatherService(API_KEY: "230d396045334b76fa9298d8d7234b99");
  Weather? _weather;
  String cityName = "";
  //Fetch Weather
  _fetchWeather() async {
    //Get the weather for the city
    if (cityName.isEmpty) {
      cityName = await _weatherService.getCurrentCity();
    }
    try {
      final weather = await _weatherService.getWeather(cityName);

      setState(() {
        _weather = weather;
      });
    }
    //Errors
    catch (e) {
      print(e);

      //Error dialog
      // ignore: use_build_context_synchronously
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'No city found',
        btnOkOnPress: () {
          setState(() {
            cityName = "";
          });
        },
      ).show();
    }
  }

  //Weather animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/loading.json';
    }

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/Cloudy.json';
      case 'rain':
      case 'drizzel':
      case 'shower rain':
        return 'assets/Rain.json';
      case 'thunderstorm':
        return 'assets/Thunder.json';
      case 'clear':
        return 'assets/Sunny.json';
      case 'snow':
        return 'assets/Snow.json';
      default:
        return 'assets/Sunny.json';
    }
  }

  //init state
  @override
  void initState() {
    super.initState();
    //Fetch weather on App Start up
    _fetchWeather();
  }

  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 40,
              left: 10,
              right: 10,
            ),
            child: AnimSearchBar(
              width: 400,
              textController: textController,
              rtl: true,
              onSuffixTap: () {
                setState(() {
                  textController.clear();
                });
              },
              onSubmitted: (String name) {
                setState(() {
                  cityName = name;
                  _fetchWeather();
                });
              },
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //City name
                  Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 30,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            _weather?.CityName ?? "loading city...",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )),

                  //animation
                  Lottie.asset(getWeatherAnimation(_weather?.MainCondition)),

                  //Temperature
                  Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Text(
                      "${_weather?.Temperature.round()}°C",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
