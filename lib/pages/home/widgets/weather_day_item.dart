import 'dart:math' as math;

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '/models/database/local_database.dart';

enum TimePeriodOfDay {
  morning,
  day,
  evening,
  night,
}

class WeatherDayItem extends StatelessWidget {
  final WeatherDay weatherDay;

  const WeatherDayItem({
    Key? key,
    required this.weatherDay,
  }) : super(key: key);

  Widget _temperatureWidget(TimePeriodOfDay timePeriodOfDay) {
    if (timePeriodOfDay == TimePeriodOfDay.night) {
      return Column(children: [
        const Text('Night'),
        Text(
          '${weatherDay.tempNight.toStringAsFixed(0)}°',
          style: const TextStyle(fontSize: 32),
        ),
        Text(
          'Feels like ${weatherDay.feelsLikeTempNight.toStringAsFixed(0)}°',
          style: const TextStyle(fontSize: 10),
        ),
      ]);
    } else if (timePeriodOfDay == TimePeriodOfDay.morning) {
      return Column(children: [
        const Text('Morning'),
        Text(
          '${weatherDay.tempMorning.toStringAsFixed(0)}°',
          style: const TextStyle(fontSize: 32),
        ),
        Text(
          'Feels like ${weatherDay.feelsLikeTempMorning.toStringAsFixed(0)}°',
          style: const TextStyle(fontSize: 10),
        ),
      ]);
    } else if (timePeriodOfDay == TimePeriodOfDay.day) {
      return Column(children: [
        const Text('Day'),
        Text(
          '${weatherDay.tempDay.toStringAsFixed(0)}°',
          style: const TextStyle(fontSize: 32),
        ),
        Text(
          'Feels like ${weatherDay.feelsLikeTempDay.toStringAsFixed(0)}°',
          style: const TextStyle(fontSize: 10),
        ),
      ]);
    } else if (timePeriodOfDay == TimePeriodOfDay.evening) {
      return Column(children: [
        const Text('Evening'),
        Text(
          '${weatherDay.tempDay.toStringAsFixed(0)}°',
          style: const TextStyle(fontSize: 32),
        ),
        Text(
          'Feels like ${weatherDay.feelsLikeTempDay.toStringAsFixed(0)}°',
          style: const TextStyle(fontSize: 10),
        ),
      ]);
    } else {
      return Container();
    }
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
                  Image.memory(
                    weatherDay.weatherGroupIcon,
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
                  Text('Min: ${weatherDay.tempMin.toStringAsFixed(0)}°'),
                  const Spacer(
                    flex: 2,
                  ),
                  Text('Max: ${weatherDay.tempMax.toStringAsFixed(0)}°'),
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
                            angle: weatherDay.windDirectionInDegrees *
                                math.pi /
                                180,
                            child: const Icon(Icons.arrow_circle_down),
                          ),
                          Text(
                              '${weatherDay.windSpeed.toStringAsPrecision(3)} m/s'),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                          'Rain (Prob: ${(weatherDay.probabilityOfPrecipitation * 100).toStringAsFixed(0)}%)'),
                      Text(weatherDay.rain == null
                          ? 'No rain'
                          : '${weatherDay.rain} mm'),
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
