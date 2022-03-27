import 'package:flutter/material.dart';

import '/models/database/local_database.dart';
import '../details_page.dart';

class WeatherHourItem extends StatelessWidget {
  final WeatherHour weatherHour;
  final Map<ColumnName, double> columnWidthSettings;

  const WeatherHourItem(
      {Key? key, required this.weatherHour, required this.columnWidthSettings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hour =
        DateTime.fromMillisecondsSinceEpoch(weatherHour.timestamp * 1000).hour;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: columnWidthSettings[ColumnName.hour],
            child: Text(hour < 10 ? '0$hour' : hour.toString()),
          ),
          SizedBox(
            width: columnWidthSettings[ColumnName.sky],
            child:
                Image.memory(weatherHour.weatherGroupIcon, fit: BoxFit.contain),
          ),
          SizedBox(
            width: columnWidthSettings[ColumnName.temp],
            child: Text(
                '${weatherHour.temp.toStringAsFixed(0)}°C'), // TODO: Make degrees symbol based on settings
          ),
          SizedBox(
            width: columnWidthSettings[ColumnName.feelsLikeTemp],
            child: Text('${weatherHour.feelsLikeTemp.toStringAsFixed(0)}°C'),
          ),
          SizedBox(
            width: columnWidthSettings[ColumnName.wind],
            child: Text('${weatherHour.windSpeed.toStringAsPrecision(3)} m/s'),
          ),
        ],
      ),
    );
  }
}
