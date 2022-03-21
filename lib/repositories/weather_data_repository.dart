import '/models/geo_location.dart';
import '/models/weather_day.dart';
import '/providers/geo_location_provider.dart';
import '/providers/weather_data_provider.dart';

enum UnitsOfMeasurement {
  metric,
  imperial,
}

class WeatherDataRepository {
  final WeatherDataProvider weatherDataProvider;
  final GeoLocationProvider geoLocationProvider;

  WeatherDataRepository({
    required this.weatherDataProvider,
    required this.geoLocationProvider,
  });

  // TODO: Make this field based on user configuration
  var _unitsOfMeasurementSetting = UnitsOfMeasurement.metric;

  /// If the value is an int then it is converted to double and returned, otherways the value is returned as is.
  double _ensureDoubleFromJson(num value) {
    return value is int ? value.toDouble() : value as double;
  }

  /// Converts temperature values from standard (Kelvin) to celcius or fahrenheit based on settings
  double _parseTempValue(num value) {
    double parsedValue;
    if (_unitsOfMeasurementSetting == UnitsOfMeasurement.metric) {
      parsedValue = value - 273.15;
    } else {
      parsedValue = (value - 273.15) * (9 / 5) + 32;
    }
    return parsedValue;
  }

  Future<List<GeoLocation>> getGeoLocationDataByName(
      String cityName, String? stateCode, String? countryCode) async {
    try {
      final List<dynamic> rawGeoLocationData = await geoLocationProvider
          .getGeoLocationByName(cityName, stateCode, countryCode);

      final List<GeoLocation> locationData = [];

      for (var locationRaw in rawGeoLocationData) {
        locationData.add(
          GeoLocation(
            location: locationRaw['name'],
            countryCode: locationRaw['country'],
            latitude: locationRaw['lat'],
            longitude: locationRaw['lon'],
            localNames: locationRaw['local_names'] is Map<String, dynamic> ? locationRaw['local_names'] : null,
            state: locationRaw['state']
          ),
        );
      }

      return locationData;
    } catch (error) {
      // TODO: Do something fancy with the error and then throw something for the bloc to catch
      rethrow;
    }
  }

  Future<List<WeatherDay>> getWeatherDays(
      double latitude, double longitude) async {
    try {
      final Map<String, dynamic> rawDailyForecastData =
          await weatherDataProvider.getDailyForecast(latitude, longitude);

      final List<dynamic> rawForecastExtractedData =
          rawDailyForecastData['daily'] as List<dynamic>;
      final List<WeatherDay> weatherDays = [];

      for (var rawWeatherDay in rawForecastExtractedData) {
        final Map<TimePeriodOfDay, double> temp = {
          TimePeriodOfDay.night:
              _parseTempValue(rawWeatherDay['temp']['night']),
          TimePeriodOfDay.day: _parseTempValue(rawWeatherDay['temp']['day']),
          TimePeriodOfDay.evening:
              _parseTempValue(rawWeatherDay['temp']['eve']),
          TimePeriodOfDay.morning:
              _parseTempValue(rawWeatherDay['temp']['morn']),
        };

        final Map<TimePeriodOfDay, double> feelsLikeTemp = {
          TimePeriodOfDay.night:
              _parseTempValue(rawWeatherDay['feels_like']['night']),
          TimePeriodOfDay.day:
              _parseTempValue(rawWeatherDay['feels_like']['day']),
          TimePeriodOfDay.evening:
              _parseTempValue(rawWeatherDay['feels_like']['eve']),
          TimePeriodOfDay.morning:
              _parseTempValue(rawWeatherDay['feels_like']['morn']),
        };

        weatherDays.add(
          WeatherDay(
            timestamp: rawWeatherDay['dt'],
            sunrise: rawWeatherDay['sunrise'],
            sunset: rawWeatherDay['sunset'],
            temp: temp,
            tempMin: _parseTempValue(rawWeatherDay['temp']['min']),
            tempMax: _parseTempValue(rawWeatherDay['temp']['max']),
            feelsLikeTemp: feelsLikeTemp,
            pressure: rawWeatherDay['pressure'],
            humidity: rawWeatherDay['humidity'],
            windSpeed: _ensureDoubleFromJson(rawWeatherDay['wind_speed']),
            windDirectionInDegrees:
                _ensureDoubleFromJson(rawWeatherDay['wind_deg']),
            clouds: rawWeatherDay['clouds'],
            probabilityOfPrecipitation:
                _ensureDoubleFromJson(rawWeatherDay['pop']),
            weatherGroup: rawWeatherDay['weather'][0]['main'],
            weatherGroupDescription: rawWeatherDay['weather'][0]['description'],
            weatherGroupIconUrl:
                'http://openweathermap.org/img/wn/${rawWeatherDay['weather'][0]['icon']}@2x.png',
            rain: rawWeatherDay['rain'] == null ? null : _ensureDoubleFromJson(rawWeatherDay['rain']),
          ),
        );
      }
      return weatherDays;
    } catch (error) {
      // TODO: Do something fancy with the error and then throw something for the bloc to catch
      rethrow;
    }
  }

  Future<List<WeatherDay>> getWeatherDaysFromCache() async {
    // TODO: Replace below with actual fetching from cache
    return const [
      WeatherDay(
        timestamp: 1647639088,
        sunrise: 1647639088,
        sunset: 1647639088,
        temp: {
          TimePeriodOfDay.night: 2,
          TimePeriodOfDay.morning: 4,
          TimePeriodOfDay.day: 6,
          TimePeriodOfDay.evening: 8,
        },
        tempMin: 2,
        tempMax: 8,
        feelsLikeTemp: {
          TimePeriodOfDay.night: -2,
          TimePeriodOfDay.morning: -4,
          TimePeriodOfDay.day: -6,
          TimePeriodOfDay.evening: -8,
        },
        pressure: 10,
        humidity: 10,
        windSpeed: 10,
        windDirectionInDegrees: 90,
        clouds: 10,
        probabilityOfPrecipitation: 0.5,
        weatherGroup: 'Snow',
        weatherGroupDescription: 'Light snow',
        weatherGroupIconUrl: 'http://openweathermap.org/img/wn/13d@2x.png',
      ),
      WeatherDay(
        timestamp: 1647639088,
        sunrise: 1647639088,
        sunset: 1647639088,
        temp: {
          TimePeriodOfDay.night: 2,
          TimePeriodOfDay.morning: 4,
          TimePeriodOfDay.day: 6,
          TimePeriodOfDay.evening: 8,
        },
        tempMin: 2,
        tempMax: 8,
        feelsLikeTemp: {
          TimePeriodOfDay.night: -2,
          TimePeriodOfDay.morning: -4,
          TimePeriodOfDay.day: -6,
          TimePeriodOfDay.evening: -8,
        },
        pressure: 10,
        humidity: 10,
        windSpeed: 10,
        windDirectionInDegrees: 90,
        clouds: 10,
        probabilityOfPrecipitation: 0.5,
        weatherGroup: 'Snow',
        weatherGroupDescription: 'Light snow',
        weatherGroupIconUrl: 'http://openweathermap.org/img/wn/13d@2x.png',
      ),
      WeatherDay(
        timestamp: 1647639088,
        sunrise: 1647639088,
        sunset: 1647639088,
        temp: {
          TimePeriodOfDay.night: 2,
          TimePeriodOfDay.morning: 4,
          TimePeriodOfDay.day: 6,
          TimePeriodOfDay.evening: 8,
        },
        tempMin: 2,
        tempMax: 8,
        feelsLikeTemp: {
          TimePeriodOfDay.night: -2,
          TimePeriodOfDay.morning: -4,
          TimePeriodOfDay.day: -6,
          TimePeriodOfDay.evening: -8,
        },
        pressure: 10,
        humidity: 10,
        windSpeed: 10,
        windDirectionInDegrees: 90,
        clouds: 10,
        probabilityOfPrecipitation: 0.5,
        weatherGroup: 'Snow',
        weatherGroupDescription: 'Light snow',
        weatherGroupIconUrl: 'http://openweathermap.org/img/wn/13d@2x.png',
      ),
    ];
  }
}
