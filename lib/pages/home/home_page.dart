import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/pages/home/bloc/home_bloc.dart';
import '/pages/location_search/location_search_page.dart';
import 'widgets/weather_day_item.dart';

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
    BlocProvider.of<HomeBloc>(context).add(LoadWeatherDays());

    return Scaffold(
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
              } else if (state is NoLocationSelectedState) {
                return const Center(
                  child: Text('No location selected yet'),
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
                          height: MediaQuery.of(context).size.height -
                              Scaffold.of(context).appBarMaxHeight!,
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
    );
  }
}
