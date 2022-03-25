import 'package:drift/drift.dart';

class WeatherDays extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get timeOfStoring => integer()();
  IntColumn get locationId => integer()();
  IntColumn get timestamp => integer()();
  IntColumn get sunrise => integer()();
  IntColumn get sunset => integer()();
  RealColumn get tempMorning => real()();
  RealColumn get tempDay => real()();
  RealColumn get tempEvening => real()();
  RealColumn get tempNight => real()();
  RealColumn get tempMin => real()();
  RealColumn get tempMax => real()();
  RealColumn get feelsLikeTempMorning => real()();
  RealColumn get feelsLikeTempDay => real()();
  RealColumn get feelsLikeTempEvening => real()();
  RealColumn get feelsLikeTempNight => real()();
  IntColumn get pressure => integer()();
  IntColumn get humidity => integer()();
  RealColumn get windSpeed => real()();
  RealColumn get windDirectionInDegrees => real()();
  IntColumn get clouds => integer()();
  RealColumn get probabilityOfPrecipitation => real()();
  TextColumn get weatherGroup => text()();
  TextColumn get weatherGroupDescription => text()();
  BlobColumn get weatherGroupIcon => blob()();
  RealColumn get rain => real().nullable()();

  @override
  List<String> get customConstraints => [
    'UNIQUE (location_id, timestamp)'
  ];
}
