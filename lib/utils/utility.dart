import 'dart:math';

class Utility {
  static double roundDoubleToPrecision(double value, int decimalPlaces) {
    var operator = pow(value, decimalPlaces);
    return ((value * operator).roundToDouble() / operator);
  }
}