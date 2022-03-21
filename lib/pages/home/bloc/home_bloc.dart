import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '/models/geo_location.dart';
import '/models/weather_day.dart';
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
      // TODO: Handle search location event
    } else if (event is LoadWeatherDays) {
      if (geoLocation == null) {
        emit(NoLocationSelectedState());
      } else {
        emit(LoadingWeatherDaysState());
        // TODO: Try to fetch from local storage if less than 12 hours since refresh otherwise fetch from API
        try {
          final weatherDays = await repository.getWeatherDays(
              geoLocation!.latitude, geoLocation!.longitude);
          emit(LoadedWeatherDaysState(weatherDays: weatherDays));
        } catch (error) {
          // TODO: Display different relevant errors based on the error message
          print(error);
          emit(FailedToLoadWeatherDaysState(
              error: 'Oops! Something went wrong... try again later.'));
        }
      }
    } else if (event is RefreshWeatherDays) {
      // TODO: Fetch days from API
    }
  }
}
