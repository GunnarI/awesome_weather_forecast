import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pages/details/details_page.dart';
import 'pages/location_search/location_search_page.dart';
import 'pages/home/home_page.dart';
import 'pages/home/bloc/home_bloc.dart';
import 'pages/location_search/bloc/location_search_bloc.dart';
import 'providers/geo_location_provider.dart';
import 'providers/weather_data_provider.dart';
import 'repositories/weather_data_repository.dart';

void main() {
  runApp(
    RepositoryProvider(
      create: (context) => WeatherDataRepository(
        geoLocationProvider: GeoLocationProvider(),
        weatherDataProvider: WeatherDataProvider(),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LocationSearchBloc>(
            create: (context) => LocationSearchBloc(
              RepositoryProvider.of<WeatherDataRepository>(context)
            ),
          ),
          BlocProvider<HomeBloc>(
            create: (context) => HomeBloc(
              RepositoryProvider.of<WeatherDataRepository>(context),
              BlocProvider.of<LocationSearchBloc>(context),
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Awesome Weather Forecast',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => HomePage(),
        LocationSearchPage.routeName: (context) => LocationSearchPage(),
        DetailsPage.routeName: (context) => DetailsPage(),
      },
    );
  }
}
