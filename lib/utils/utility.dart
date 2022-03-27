import 'dart:math';

class Utility {
  static double roundDoubleToPrecision(double value, int decimalPlaces) {
    var operator = pow(value, decimalPlaces);
    return ((value * operator).roundToDouble() / operator);
  }

  static List<double> extractDoublesFromString(String value) {
    var doubleRegex = RegExp(r'-?(?:\d*\.)?\d+(?:[eE][+-]?\d+)?');
    return doubleRegex.allMatches(value).map((singleDoubleString) => double.parse(singleDoubleString[0]!)).toList();
  }

  static bool isValidLatitude(double latitude) {
    return latitude >= -90 && latitude <= 90;
  }

  static bool isValidLongitude(double longitude) {
    return longitude >= -180 && longitude <= 180;
  }
}