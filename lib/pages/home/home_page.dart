import 'package:flutter/material.dart';

import './widgets/weather_day_item.dart';
import '../../models/weather_day.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  // TODO: Remove test lists below
  static const List<WeatherDay> _weatherDays = [
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

  void _onSearchIconPressed() {
    // TODO: Navigate to search screen
  }

  Future<void> _refreshWeatherData() async {
    // TODO: Reload data from API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Awesome Weather Forecast'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _onSearchIconPressed,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          child: ListView.builder(
            itemBuilder: (_, i) => Column(
              children: [WeatherDayItem(weatherDay: HomePage._weatherDays[i])],
            ),
            itemCount: HomePage._weatherDays.length,
          ),
          onRefresh: _refreshWeatherData,
        ),
      ),
    );
  }
}
