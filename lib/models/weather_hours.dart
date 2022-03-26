import 'package:drift/drift.dart';

class WeatherHours extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get timeOfStoring => integer()();
  IntColumn get locationId => integer()();
  IntColumn get timestamp => integer()();
  RealColumn get temp => real()();
  RealColumn get feelsLikeTemp => real()();
  IntColumn get pressure => integer()();
  IntColumn get humidity => integer()();
  IntColumn get clouds => integer()();
  RealColumn get windSpeed => real()();
  RealColumn get windDirectionInDegrees => real()();
  RealColumn get probabilityOfPrecipitation => real()();
  TextColumn get weatherGroup => text()();
  TextColumn get weatherGroupDescription => text()();
  BlobColumn get weatherGroupIcon => blob()();

  @override
  List<String> get customConstraints => [
    'UNIQUE (location_id, timestamp)'
  ];
}