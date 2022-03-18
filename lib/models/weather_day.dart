enum TimeOfDay {
  morning,
  day,
  evening,
  night
}
class WeatherDay {
  final int timestamp;
  final int sunrise;
  final int sunset;
  final Map<TimeOfDay, double> temp;
  final double tempMin;
  final double tempMax;
  final Map<TimeOfDay, double> feelsLikeTemp;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final double windDirectionInDegrees;
  final int clouds;
  final double probabilityOfPrecipitation;
  final String weatherGroup;
  final String weatherGroupDescription;
  final String weatherGroupIconUrl;

  WeatherDay({
    required this.timestamp,
    required this.sunrise,
    required this.sunset,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.feelsLikeTemp,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.windDirectionInDegrees,
    required this.clouds,
    required this.probabilityOfPrecipitation,
    required this.weatherGroup,
    required this.weatherGroupDescription,
    required this.weatherGroupIconUrl,
  });
}
