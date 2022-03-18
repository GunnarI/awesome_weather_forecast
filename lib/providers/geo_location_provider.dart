import 'dart:convert';

import 'package:http/http.dart' as http;

class GeoLocationProvider {
  final String _baseUrl = 'http://api.openweathermap.org/geo/1.0';
  final String _apiKey = 'd000921e38492e43dbe902a46854ab25';
  final int _resultLimit = 10;

  /// Fetches location data from the http://api.openweathermap.org/geo/1.0/direct API using location names.
  /// 
  /// Each item of the list returned will contain (amongst other objects) the city name, country code, latitude, and longitude of the place searched for.
  /// The [stateCode] is only applicable for the US and [countryCode] should use the ISO 3166 format.
  /// 
  /// See _Direct geocoding_ at https://openweathermap.org/api/geocoding-api for more details.
  Future<List<dynamic>> getGeoLocationByName(String cityName, String? stateCode, String? countryCode) async {
    final searchParams = '$cityName${stateCode == null ? '' : ',$stateCode'}${countryCode == null ? '' : ',$countryCode'}';

    final url = Uri.parse(
      '$_baseUrl/direct?q=$searchParams&limit=$_resultLimit&appid=$_apiKey'
    );

    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as List<dynamic>;
      return responseData;
    } catch (error) {
      rethrow;
    }
  }

  /// Fetches data from the http://api.openweathermap.org/geo/1.0/reverse API using location's geo coordinates.
  /// 
  /// Each item of the list returned will contain (amongst other objects) the city name, country code, latitude, and longitude of the place searched for.
  /// 
  /// See _Reverse geocoding_ at https://openweathermap.org/api/geocoding-api for more details.
  Future<List<dynamic>> getGeoLocationByLatitudeLongitude(double latitude, double longitude) async {
    final url = Uri.parse(
      '$_baseUrl/reverse?lat=$latitude&lon=$longitude&limit=$_resultLimit&appid=$_apiKey'
    );

    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as List<dynamic>;
      return responseData;
    } catch (error) {
      rethrow;
    }
  }
}