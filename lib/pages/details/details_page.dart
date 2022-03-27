import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '/pages/home/bloc/home_bloc.dart';
import '/pages/details/widgets/weather_hour_item.dart';
import 'bloc/details_bloc.dart';

enum ColumnName {
  hour,
  sky,
  temp,
  feelsLikeTemp,
  wind,
}

class DetailsPage extends StatelessWidget {
  static const routeName = '/details';

  const DetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<ColumnName, double> columnWidthSetting = {
      ColumnName.hour:
          (MediaQuery.of(context).size.width - 16.0) * (2.0 / 16.0),
      ColumnName.sky: (MediaQuery.of(context).size.width - 16.0) * (4.0 / 16.0),
      ColumnName.temp:
          (MediaQuery.of(context).size.width - 16.0) * (3.0 / 16.0),
      ColumnName.feelsLikeTemp:
          (MediaQuery.of(context).size.width - 16.0) * (3.0 / 16.0),
      ColumnName.wind:
          (MediaQuery.of(context).size.width - 16.0) * (3.0 / 16.0),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(BlocProvider.of<HomeBloc>(context)
            .repository
            .selectedGeoLocation!
            .location),
      ),
      body: BlocBuilder<DetailsBloc, DetailsState>(
        builder: (context, state) {
          if (state is LoadingWeatherHoursState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is FailedToLoadWeatherHoursState) {
            Navigator.of(context).pop(state.error);
            return const Center(
              child: Text(
                  'Something went wrong in fetching data... please try again later!'),
            );
          } else if (state is LoadedWeatherHoursState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      DateFormat('EEE, dd/MM/yyyy').format( // TODO: Make date format based on locale
                        DateTime.fromMillisecondsSinceEpoch(
                            state.weatherHours.first.timestamp * 1000),
                      ),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16.0,
                      bottom: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: columnWidthSetting[ColumnName.hour],
                          child: const Text('Hour'),
                        ),
                        SizedBox(
                          width: columnWidthSetting[ColumnName.sky],
                          child: const Center(child: Text('Sky')),
                        ),
                        SizedBox(
                          width: columnWidthSetting[ColumnName.temp],
                          child: const Text('Temp'),
                        ),
                        SizedBox(
                          width: columnWidthSetting[ColumnName.feelsLikeTemp],
                          child: const Text('Feels like'),
                        ),
                        SizedBox(
                          width: columnWidthSetting[ColumnName.wind],
                          child: const Text('Wind'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.weatherHours.length,
                      itemBuilder: (_, i) {
                        return WeatherHourItem(
                          weatherHour: state.weatherHours[i],
                          columnWidthSettings: columnWidthSetting,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Something went wrong... please try again later!'),
            );
          }
        },
      ),
    );
  }
}
