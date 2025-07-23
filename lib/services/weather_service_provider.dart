import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_app/models/location_response_model.dart';
import 'package:weather_app/secrets/api.dart';
import 'package:http/http.dart' as http;

class WeatherServiceProvider extends ChangeNotifier {
  weatherModel? _weather;
  weatherModel? get weather => _weather;

  bool? _isloading = false;
  bool? get isloading => _isloading;

  String? _error = "";
  String? get error => _error;

  Future<void> fetchWeatherDataByCity(String city) async {
    _isloading = true;
    _error = "";

    try {
      final apiUrl =
          "${APIEndPoints().cityUrl}${city}${APIEndPoints().apikey}${APIEndPoints().unit}";
      print(apiUrl);

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);

        _weather = weatherModel.fromJson(data);
        notifyListeners();
      } else {
        _error = "Error in fetching weather";
      }
    } catch (e) {
      print("Failed to load weather ${e}");
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }
}
