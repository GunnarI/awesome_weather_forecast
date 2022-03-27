import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pages/details/details_page.dart';
import 'pages/location_search/location_search_page.dart';
import 'pages/home/home_page.dart';
import 'pages/home/bloc/home_bloc.dart';
import 'pages/location_search/bloc/location_search_bloc.dart';
import '/pages/details/bloc/details_bloc.dart';
import 'providers/geo_location_provider.dart';
import 'providers/weather_data_provider.dart';
import 'repositories/weather_data_repository.dart';
import '/models/database/local_database.dart';

void main() {
  runApp(
    RepositoryProvider(
      create: (context) => WeatherDataRepository(
        localDatabase: LocalDatabase(),
        geoLocationProvider: GeoLocationProvider(),
        weatherDataProvider: WeatherDataProvider(),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LocationSearchBloc>(
            create: (context) => LocationSearchBloc(
              RepositoryProvider.of<WeatherDataRepository>(context),
            ),
          ),
          BlocProvider<HomeBloc>(
            create: (context) => HomeBloc(
              RepositoryProvider.of<WeatherDataRepository>(context),
              BlocProvider.of<LocationSearchBloc>(context),
            ),
          ),
          BlocProvider<DetailsBloc>(
            create: (context) => DetailsBloc(
              RepositoryProvider.of<WeatherDataRepository>(context),
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
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        LocationSearchPage.routeName: (context) => const LocationSearchPage(),
        DetailsPage.routeName: (context) => const DetailsPage(),
      },
    );
  }
}
