import 'dart:convert';

import 'package:drift/drift.dart';

//part 'geo_location.dart';

//@UseRowClass(GeoLocation)
class GeoLocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get location => text()();
  TextColumn get countryCode => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get localNames => text().map(const JsonConverter()).nullable()();
  TextColumn get state => text().nullable()();

  @override
  List<String> get customConstraints => [
    'UNIQUE (latitude, longitude)'
  ];
}

class JsonConverter extends TypeConverter<Map<String, dynamic>, String> {
  const JsonConverter();

  @override
  Map<String, dynamic>? mapToDart(String? fromDb) {
    if (fromDb == null) {
      return null;
    }
    return json.decode(fromDb);
  }

  @override
  String? mapToSql(Map<String, dynamic>? value) {
    if (value == null) {
      return null;
    }

    return json.encode(value);
  }
}
