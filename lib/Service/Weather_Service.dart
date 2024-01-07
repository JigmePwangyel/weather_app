import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../Models/Weather_Model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = "http://api.openweathermap.org/data/2.5/weather";
  final String API_KEY;

  WeatherService({required this.API_KEY});

  //API call to fetch the weather data
  Future<Weather> getWeather(String CityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$CityName&appid=$API_KEY&units=metric'));
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load Data");
    }
  }

  //To get the current city of the user
  Future<String> getCurrentCity() async {
    //Get permission from the user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //Fetch the current location of the user
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //Convert the location into a list of placemark objects
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    //Extract the cityname form the first placemark
    String? city = placemarks[0].locality;
    return city ?? "";
  }
}
