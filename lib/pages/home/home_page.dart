import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './widgets/weather_day_item.dart';
import '../location_search/location_search_page.dart';
import '../home/bloc/home_bloc.dart';
import '../../providers/geo_location_provider.dart';
import '../../providers/weather_data_provider.dart';
import '../../repositories/weather_data_repository.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  void _onSearchIconPressed(BuildContext context) {
    Navigator.of(context).pushNamed(LocationSearchPage.routeName);
  }

  Future<void> _refreshWeatherData() async {
    // TODO: Reload data from API
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(
        WeatherDataRepository(
          geoLocationProvider: GeoLocationProvider(),
          weatherDataProvider: WeatherDataProvider(),
        ),
      )..add(LoadWeatherDays()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Awesome Weather Forecast'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _onSearchIconPressed(context),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is LoadingWeatherDaysState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: _refreshWeatherData,
                  child: ListView.builder(
                    itemBuilder: (_, i) {
                      if (state is LoadedWeatherDaysState) {
                        return Column(
                          children: [
                            WeatherDayItem(weatherDay: state.weatherDays[i])
                          ],
                        );
                      } else if (state is FailedToLoadWeatherDaysState) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight!,
                          child: Center(
                            child: Text(state.error),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                    itemCount: state is LoadedWeatherDaysState
                        ? state.weatherDays.length
                        : 1,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
