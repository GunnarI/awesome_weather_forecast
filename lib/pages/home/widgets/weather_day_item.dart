import 'dart:math' as math;

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../../models/weather_day.dart';

class WeatherDayItem extends StatelessWidget {
  final WeatherDay weatherDay;

  const WeatherDayItem({
    Key? key,
    required this.weatherDay,
  }) : super(key: key);

  Widget _temperatureWidget(TimePeriodOfDay timePeriodOfDay) {
    return Column(
      children: [
        if (timePeriodOfDay == TimePeriodOfDay.night)
          const Text('Night')
        else if (timePeriodOfDay == TimePeriodOfDay.morning)
          const Text('Morning')
        else if (timePeriodOfDay == TimePeriodOfDay.day)
          const Text('Day')
        else if (timePeriodOfDay == TimePeriodOfDay.evening)
          const Text('Evening'),
        Text(
          '${weatherDay.temp[timePeriodOfDay]}°',
          style: const TextStyle(fontSize: 32),
        ),
        Text(
          'Feels like ${weatherDay.feelsLikeTemp[timePeriodOfDay]}°',
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(DateFormat('yyyy-MM-dd').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          weatherDay.timestamp * 1000))),
                  const Spacer(),
                  Image.network(
                    weatherDay.weatherGroupIconUrl,
                    fit: BoxFit.cover,
                  ),
                  Text(weatherDay.weatherGroupDescription),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _temperatureWidget(TimePeriodOfDay.night),
                  _temperatureWidget(TimePeriodOfDay.morning),
                  _temperatureWidget(TimePeriodOfDay.day),
                  _temperatureWidget(TimePeriodOfDay.evening),
                ],
              ),
              Row(
                children: [
                  const Spacer(
                    flex: 3,
                  ),
                  Text('Min: ${weatherDay.tempMin}°'),
                  const Spacer(
                    flex: 2,
                  ),
                  Text('Max: ${weatherDay.tempMax}°'),
                  const Spacer(
                    flex: 3,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text('Sunrise'),
                      Text(DateFormat('HH:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              weatherDay.sunrise * 1000))),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Wind'),
                      Row(
                        children: [
                          Transform.rotate(
                            angle: weatherDay.windDirectionInDegrees * math.pi / 180,
                            child: const Icon(Icons.arrow_circle_down),
                          ),
                          Text('${weatherDay.windSpeed} m/s'),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Rain (Prob: ${weatherDay.probabilityOfPrecipitation}%)'),
                      Text(weatherDay.rain == null ? 'No rain' : '${weatherDay.rain} mm'),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Sunset'),
                      Text(DateFormat('HH:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              weatherDay.sunset * 1000))),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
