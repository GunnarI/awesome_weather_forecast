import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '/models/database/local_database.dart';
import '/pages/location_search/bloc/location_search_bloc.dart';
import '/repositories/weather_data_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final WeatherDataRepository repository;
  final LocationSearchBloc locationSearchBloc;

  late final StreamSubscription locationSearchSubscription;

  HomeBloc(
    this.repository,
    this.locationSearchBloc,
  ) : super(HomeInitial()) {
    locationSearchSubscription = locationSearchBloc.stream.listen((state) {
      if (state is LocationSelectedState) {
        add(LoadWeatherDaysEvent());
      }
    });
    on<HomeEvent>(_onHomeEvent);
    on<NavigateToDetailsEvent>(((event, emit) => repository.selectedWeatherDay = event.weatherDay));
  }

  Future<void> _onHomeEvent(HomeEvent event, Emitter<HomeState> emit) async {
    if (event is SearchLocationEvent) {
      // TODO: Handle search location event by checking internet access before navigation
    } else if (event is LoadWeatherDaysEvent) {
      emit(LoadingWeatherDaysState());

      await repository.clearOutdatedCache();

      if (repository.selectedGeoLocation == null) {
        try {
          repository.selectedGeoLocation = await repository.getLatestCachedGeoLocation();
          if (repository.selectedGeoLocation == null) {
            emit(NoLocationSelectedState());
            return;
          }
        } catch (error) {
          rethrow;
        }
      }

      var weatherDays = <WeatherDay>[];
      try {
        weatherDays = await repository.getWeatherDaysFromCache(repository.selectedGeoLocation!);

        if (weatherDays.isEmpty) {
          weatherDays = await repository.getWeatherDays(repository.selectedGeoLocation!);
        }

        emit(LoadedWeatherDaysState(weatherDays: weatherDays));
      } catch (error) {
        emit(
          FailedToLoadWeatherDaysState(
              error:
                  'Oops! Something went wrong... try refreshing or try again later.'),
        );
      }
    } else if (event is RefreshEvent) {
      if (event.weatherDays.isNotEmpty) {
        emit(LoadedWeatherDaysState(weatherDays: event.weatherDays));
      }
    }
  }
}
