import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '/models/geo_locations.dart';
import '/models/weather_days.dart';
import '/models/weather_hours.dart';

part 'local_database.g.dart';

@DriftDatabase(
  tables: [WeatherDays, WeatherHours, GeoLocations],
  queries: {
    'latestCachedLocation':
        'SELECT * FROM geo_locations WHERE id = (SELECT MAX(id) FROM geo_locations);',
    'deleteUnusedLocations':
        'DELETE FROM geo_locations WHERE id NOT IN (SELECT location_id FROM weather_days);',
  },
)
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<GeoLocation> addGeoLocation(GeoLocation geoLocation) async {
    // TODO: Fix bug where geo location is not returned correctly if it is previously stored
    try {
      var returnGeoLocation = await into(geoLocations).insertReturning(
        GeoLocationsCompanion(
          location: Value(geoLocation.location),
          countryCode: Value(geoLocation.countryCode),
          latitude: Value((geoLocation.latitude * 1000).roundToDouble() / 1000),
          longitude:
              Value((geoLocation.longitude * 1000).roundToDouble() / 1000),
          localNames: Value(geoLocation.localNames),
          state: Value(geoLocation.state),
        ),
      );

      return returnGeoLocation;
    } catch (error) {
      if (error is SqliteException) {
        try {
          return getGeoLocationByLatLon(
              geoLocation.latitude, geoLocation.longitude);
        } catch (error) {
          rethrow;
        }
      }
      rethrow;
    }
  }

  Future<GeoLocation> getGeoLocationByLatLon(
      double latitude, double longitude) async {
    var geoLocation = await (select(geoLocations)
          ..where((tbl) => tbl.latitude.equals(latitude))
          ..limit(1))
        .get();
    return geoLocation.first;
  }

  Future<GeoLocation?> get getLatestGeoLocation async {
    return latestCachedLocation().getSingleOrNull();
  }

  Future<void> addWeatherDays(List<WeatherDay> weatherDayList) async {
    List<WeatherDaysCompanion> entries = [];

    for (var weatherDay in weatherDayList) {
      entries.add(
        WeatherDaysCompanion(
          locationId: Value(weatherDay.locationId),
          timeOfStoring: Value(weatherDay.timeOfStoring),
          timestamp: Value(weatherDay.timestamp),
          sunrise: Value(weatherDay.sunrise),
          sunset: Value(weatherDay.sunset),
          tempMorning: Value(weatherDay.tempMorning),
          tempDay: Value(weatherDay.tempDay),
          tempEvening: Value(weatherDay.tempEvening),
          tempNight: Value(weatherDay.tempNight),
          tempMin: Value(weatherDay.tempMin),
          tempMax: Value(weatherDay.tempMax),
          feelsLikeTempMorning: Value(weatherDay.feelsLikeTempMorning),
          feelsLikeTempDay: Value(weatherDay.feelsLikeTempDay),
          feelsLikeTempEvening: Value(weatherDay.feelsLikeTempEvening),
          feelsLikeTempNight: Value(weatherDay.feelsLikeTempNight),
          pressure: Value(weatherDay.pressure),
          humidity: Value(weatherDay.humidity),
          windSpeed: Value(weatherDay.windSpeed),
          windDirectionInDegrees: Value(weatherDay.windDirectionInDegrees),
          clouds: Value(weatherDay.clouds),
          probabilityOfPrecipitation:
              Value(weatherDay.probabilityOfPrecipitation),
          weatherGroup: Value(weatherDay.weatherGroup),
          weatherGroupDescription: Value(weatherDay.weatherGroupDescription),
          weatherGroupIcon: Value(weatherDay.weatherGroupIcon),
          rain: Value(weatherDay.rain),
        ),
      );
    }

    return batch((batch) => batch.insertAll(weatherDays, entries,
        mode: InsertMode.insertOrReplace));
  }

  Future<List<WeatherDay>> getWeatherDaysByLocation(int locationId) {
    return (select(weatherDays)
          ..where((tbl) => tbl.locationId.equals(locationId)))
        .get();
  }

  Future<void> addWeatherHours(List<WeatherHour> weatherHourList) async {
    List<WeatherHoursCompanion> entries = [];

    for (var weatherHour in weatherHourList) {
      entries.add(
        WeatherHoursCompanion(
          locationId: Value(weatherHour.locationId),
          timeOfStoring: Value(weatherHour.timeOfStoring),
          timestamp: Value(weatherHour.timestamp),
          temp: Value(weatherHour.temp),
          feelsLikeTemp: Value(weatherHour.feelsLikeTemp),
          pressure: Value(weatherHour.pressure),
          humidity: Value(weatherHour.humidity),
          windSpeed: Value(weatherHour.windSpeed),
          windDirectionInDegrees: Value(weatherHour.windDirectionInDegrees),
          clouds: Value(weatherHour.clouds),
          probabilityOfPrecipitation:
              Value(weatherHour.probabilityOfPrecipitation),
          weatherGroup: Value(weatherHour.weatherGroup),
          weatherGroupDescription: Value(weatherHour.weatherGroupDescription),
          weatherGroupIcon: Value(weatherHour.weatherGroupIcon),
        ),
      );
    }

    return batch((batch) => batch.insertAll(weatherHours, entries,
        mode: InsertMode.insertOrReplace));
  }

  Future<List<WeatherHour>> getWeatherHoursByLocationAndTimeRange(
      int locationId, int startTime, int endTime) {
    return (select(weatherHours)
          ..where((tbl) =>
              tbl.locationId.equals(locationId) &
              tbl.timestamp.isBetweenValues(startTime, endTime)))
        .get();
  }

  Future<void> clearOutdatedData() async {
    (delete(weatherDays)
          ..where(
            (tbl) =>
                tbl.timeOfStoring.isSmallerThanValue(DateTime.now()
                    .subtract(const Duration(hours: 12))
                    .millisecondsSinceEpoch) |
                tbl.timestamp.isSmallerThanValue(DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day)
                        .millisecondsSinceEpoch ~/
                    1000),
          ))
        .go();
    (delete(weatherHours)
          ..where(
            (tbl) =>
                tbl.timeOfStoring.isSmallerThanValue(DateTime.now()
                    .subtract(const Duration(hours: 12))
                    .millisecondsSinceEpoch) |
                tbl.timestamp.isSmallerThanValue(
                    DateTime.now().millisecondsSinceEpoch ~/ 1000),
          ))
        .go();
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
