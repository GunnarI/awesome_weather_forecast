import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;

class WeatherDataProvider {
  final String _baseUrl = 'http://api.openweathermap.org/data/2.5/onecall';
  final String _apiKey = 'd000921e38492e43dbe902a46854ab25';
  final String _iconUrlPrefix = 'http://openweathermap.org/img/wn/';
  final String _iconUrlPostfix = '@2x.png';

  /// Fetches daily weather data for next 7 days from the http://api.openweathermap.org/data/2.5/onecall API using geo coordinates.
  /// 
  /// The map returned will contain some location metadata and then a list containing 7 items (for 7 days), 
  /// each with a map of objects containing the weather data for each day.
  /// 
  /// See _Current and forecast weather data_ at https://openweathermap.org/api/one-call-api for more details.
  Future<Map<String, dynamic>> getDailyForecast(double latitude, double longitude) async {
    const exclusions = 'current,minutely,hourly,alerts';

    final url = Uri.parse(
      '$_baseUrl?lat=$latitude&lon=$longitude&exclude=$exclusions&appid=$_apiKey'
    );

    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      return responseData;
    } catch (error) {
      rethrow;
    }
  }

  Future<Uint8List> getIconBytesFromUrl(String icon) async {
    final url = Uri.parse('$_iconUrlPrefix$icon$_iconUrlPostfix');
    try {
      final response = await http.get(url);
      return response.bodyBytes;
    } catch (error) {
      rethrow;
    }
  }
}