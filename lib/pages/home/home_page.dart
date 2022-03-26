import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/pages/home/bloc/home_bloc.dart';
import '/pages/location_search/location_search_page.dart';
import '/pages/details/details_page.dart';
import 'widgets/weather_day_item.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  void _onSearchIconPressed(BuildContext context) {
    Navigator.of(context).pushNamed(LocationSearchPage.routeName);
  }

  void _onListItemPressed(BuildContext context, HomeState state, int index) {
    if (state is LoadedWeatherDaysState) {
      context
          .read<HomeBloc>()
          .add(NavigateToDetailsEvent(weatherDay: state.weatherDays[index]));
      Navigator.of(context).pushNamed(DetailsPage.routeName);
    }
  }

  Future<void> _refreshWeatherData(BuildContext context) async {
    var geoLocation =
        BlocProvider.of<HomeBloc>(context).repository.selectedGeoLocation;

    if (geoLocation != null) {
      await BlocProvider.of<HomeBloc>(context)
          .repository
          .getWeatherDays(geoLocation);
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
