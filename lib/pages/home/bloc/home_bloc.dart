import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '/models/database/local_database.dart'; //import '/models/geo_locations.dart';
//import '/models/weather_days.dart';
import '/pages/location_search/bloc/location_search_bloc.dart';
import '/repositories/weather_data_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final WeatherDataRepository repository;
  final LocationSearchBloc locationSearchBloc;

  late final StreamSubscription locationSearchSubscription;

  GeoLocation? geoLocation;

  HomeBloc(
    this.repository,
    this.locationSearchBloc,
  ) : super(HomeInitial()) {
    locationSearchSubscription = locationSearchBloc.stream.listen((state) {
      if (state is LocationSelectedState) {
        geoLocation = state.selectedLocation;
        add(LoadWeatherDays());
      }
    });
    on<HomeEvent>(_onHomeEvent);
  }

  Future<void> _onHomeEvent(HomeEvent event, Emitter<HomeState> emit) async {
    if (event is SearchLocationEvent) {
      // TODO: Handle search location event by checking internet access before navigation
    } else if (event is LoadWeatherDays) {
      emit(LoadingWeatherDaysState());

      await repository.clearOutdatedCache();

      if (geoLocation == null) {
        try {
          geoLocation = await repository.getLatestCachedGeoLocation();
          if (geoLocation == null) {
            emit(NoLocationSelectedState());
            return;
          }
        } catch (error) {
          rethrow;
        }
      }

      var weatherDays = <WeatherDay>[];
      try {
        weatherDays = await repository.getWeatherDaysFromCache(geoLocation!);

        if (weatherDays.isEmpty) {
          weatherDays = await repository.getWeatherDays(geoLocation!);
        }

        emit(LoadedWeatherDaysState(weatherDays: weatherDays));
      } catch (error) {
        emit(
          FailedToLoadWeatherDaysState(
              error:
                  'Oops! Something went wrong... try refreshing or try again later.'),
        );
      }
    } else if (event is RefreshWeatherDays) {
      // TODO: Fetch days from API
    }
  }
}
