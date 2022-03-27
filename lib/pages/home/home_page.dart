import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/pages/home/bloc/home_bloc.dart';
import '/pages/location_search/location_search_page.dart';
import '/pages/details/details_page.dart';
import '/pages/details/bloc/details_bloc.dart';
import 'widgets/weather_day_item.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  void _onSearchIconPressed(BuildContext context) async {
    // TODO: Move this logic into the bloc
    try {
      final testApiAccess =
          await InternetAddress.lookup('api.openweathermap.org');
      if (testApiAccess.isNotEmpty && testApiAccess[0].rawAddress.isNotEmpty) {
        Navigator.of(context).pushNamed(LocationSearchPage.routeName);
      } else {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content:
                  Text('Location API is unavailable so no location search available.'),
            ),
          );
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content:
                Text('Location API is unavailable so no location search available.'),
          ),
        );
    }
  }

  void _onListItemPressed(
      BuildContext context, HomeState state, int index) async {
    if (state is LoadedWeatherDaysState) {
      context
          .read<HomeBloc>()
          .add(NavigateToDetailsEvent(weatherDay: state.weatherDays[index]));

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      BlocProvider.of<DetailsBloc>(context).add(LoadWeatherHoursEvent());
      final response =
          await Navigator.of(context).pushNamed(DetailsPage.routeName);
      if (response is LoadErrorCase) {
        if (response == LoadErrorCase.noDataAvailable) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('No details data available for this item'),
              ),
            );
        } else if (response == LoadErrorCase.errorFetchingFromStorage) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Could not fetch details for this item'),
              ),
            );
        }
      }
    }
  }

  Future<void> _refreshWeatherData(BuildContext context) async {
    // TODO: Move some of this logic into the bloc
    try {
final testApiAccess =
          await InternetAddress.lookup('api.openweathermap.org');
      if (testApiAccess.isEmpty || testApiAccess[0].rawAddress.isEmpty) {
        ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Weather API is unavailable so data could not be refreshed.'),
              ),
            );
        return;
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Weather API is unavailable so data could not be refreshed.'),
              ),
            );
      return;
    }

    final geoLocation =
        BlocProvider.of<HomeBloc>(context).repository.selectedGeoLocation;

    if (geoLocation != null) {
      try {
        var newWeatherDays = await BlocProvider.of<HomeBloc>(context)
            .repository
            .getWeatherDays(geoLocation);

        BlocProvider.of<HomeBloc>(context)
            .add(RefreshEvent(weatherDays: newWeatherDays));
      } catch (error) {
        ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Error fetching weather data.'),
              ),
            );
      }
    }

    return;
  }

  Widget _listViewWidget(BuildContext context, HomeState state, int index) {
    if (state is LoadedWeatherDaysState) {
      return Column(
        children: [WeatherDayItem(weatherDay: state.weatherDays[index])],
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
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<HomeBloc>(context).add(LoadWeatherDaysEvent());

    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            var geoLocation = BlocProvider.of<HomeBloc>(context)
                .repository
                .selectedGeoLocation;
            if (state is LoadedWeatherDaysState && geoLocation != null) {
              return Text(geoLocation.location);
            } else {
              return const Text('Awesome Weather App');
            }
          },
        ),
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
                onRefresh: () => _refreshWeatherData(context),
                child: ListView.builder(
                  itemBuilder: (_, i) {
                    return InkWell(
                      child: _listViewWidget(context, state, i),
                      onTap: () => _onListItemPressed(context, state, i),
                    );
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
