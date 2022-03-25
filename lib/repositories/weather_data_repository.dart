import 'package:drift/drift.dart';

import '/models/database/local_database.dart';
import '/providers/geo_location_provider.dart';
import '/providers/weather_data_provider.dart';

enum UnitsOfMeasurement {
  metric,
  imperial,
}

class WeatherDataRepository {
  final LocalDatabase localDatabase;
  final WeatherDataProvider weatherDataProvider;
  final GeoLocationProvider geoLocationProvider;

  WeatherDataRepository({
    required this.localDatabase,
    required this.weatherDataProvider,
    required this.geoLocationProvider,
  });

  // TODO: Make this field based on user configuration
  var _unitsOfMeasurementSetting = UnitsOfMeasurement.metric;

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
            id: -1,
            location: locationRaw['name'],
            countryCode: locationRaw['country'],
            latitude: locationRaw['lat'],
            longitude: locationRaw['lon'],
            localNames: locationRaw['local_names'] is Map<String, dynamic>
                ? locationRaw['local_names']
                : null,
            state: locationRaw['state'],
          ),
        );
      }

      return locationData;
    } catch (error) {
      // TODO: Do something fancy with the error and then throw something for the bloc to catch
      rethrow;
    }
  }

  Future<int> clearOutdatedCache() {
    try {
      return localDatabase.clearOutdatedData();
    } catch (error) {
      // TODO: Do something fancy with the error and then throw something for the bloc to catch
      rethrow;
    }
  }

  Future<List<WeatherDay>> getWeatherDays(GeoLocation geoLocation) async {
    try {
      final Map<String, dynamic> rawDailyForecastData =
          await weatherDataProvider.getDailyForecast(
              geoLocation.latitude, geoLocation.longitude);

      final timeOfFetchingForecast = DateTime.now().millisecondsSinceEpoch;

      final List<dynamic> rawForecastExtractedData =
          rawDailyForecastData['daily'] as List<dynamic>;
      final List<WeatherDay> weatherDays = [];

      for (var rawWeatherDay in rawForecastExtractedData) {
        Uint8List icon = await weatherDataProvider
            .getIconBytesFromUrl(rawWeatherDay['weather'][0]['icon']);
        weatherDays.add(
          WeatherDay(
            id: -1,
            locationId: geoLocation.id,
            timeOfStoring: timeOfFetchingForecast,
            timestamp: rawWeatherDay['dt'],
            sunrise: rawWeatherDay['sunrise'],
            sunset: rawWeatherDay['sunset'],
            tempMorning: _parseTempValue(rawWeatherDay['temp']['morn']),
            tempDay: _parseTempValue(rawWeatherDay['temp']['day']),
            tempEvening: _parseTempValue(rawWeatherDay['temp']['eve']),
            tempNight: _parseTempValue(rawWeatherDay['temp']['night']),
            tempMin: _parseTempValue(rawWeatherDay['temp']['min']),
            tempMax: _parseTempValue(rawWeatherDay['temp']['max']),
            feelsLikeTempMorning:
                _parseTempValue(rawWeatherDay['feels_like']['morn']),
            feelsLikeTempDay:
                _parseTempValue(rawWeatherDay['feels_like']['day']),
            feelsLikeTempEvening:
                _parseTempValue(rawWeatherDay['feels_like']['eve']),
            feelsLikeTempNight:
                _parseTempValue(rawWeatherDay['feels_like']['night']),
            pressure: rawWeatherDay['pressure'],
            humidity: rawWeatherDay['humidity'],
            windSpeed: (rawWeatherDay['wind_speed'] as num).toDouble(),
            windDirectionInDegrees:
                (rawWeatherDay['wind_deg'] as num).toDouble(),
            clouds: rawWeatherDay['clouds'],
            probabilityOfPrecipitation:
                (rawWeatherDay['pop'] as num).toDouble(),
            weatherGroup: rawWeatherDay['weather'][0]['main'],
            weatherGroupDescription: rawWeatherDay['weather'][0]['description'],
            weatherGroupIcon: icon,
            rain: rawWeatherDay['rain'] == null
                ? null
                : (rawWeatherDay['rain'] as num).toDouble(),
          ),
        );
      }

      cacheWeatherDaysData(weatherDays);

      return weatherDays;
    } catch (error) {
      // TODO: Do something fancy with the error and then throw something for the bloc to catch
      rethrow;
    }
  }

  Future<GeoLocation> cacheGeoLocationData(GeoLocation geoLocation) {
    try {
      return localDatabase.addGeoLocation(geoLocation);
    } catch (error) {
      // TODO: Do something fancy with the error and then throw something for the bloc to catch
      rethrow;
    }
  }

  Future<GeoLocation?> getLatestCachedGeoLocation() {
    //localDatabase.allGeoLocationEntries.then((value) => print('All geo locations number: ${value.length}'));
    return localDatabase.getLatestGeoLocation;
  }

  Future<void> cacheWeatherDaysData(List<WeatherDay> weatherDayList) {
    try {
      return localDatabase.addWeatherDays(weatherDayList);
    } catch (error) {
      rethrow;
    }
  }

  Future<List<WeatherDay>> getWeatherDaysFromCache(
      GeoLocation geoLocation) async {
    try {
      var locallyStoredWeatherDays =
          await localDatabase.getWeatherDaysByLocation(geoLocation.id);

      return locallyStoredWeatherDays
        ..where(
          (weatherDay) =>
              DateTime.fromMillisecondsSinceEpoch(weatherDay.timestamp * 1000)
                  .isAfter(
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ),
          ),
        );
    } catch (error) {
      // TODO: Do something fancy with the error and then throw something for the bloc to catch
      rethrow;
    }
  }
}
