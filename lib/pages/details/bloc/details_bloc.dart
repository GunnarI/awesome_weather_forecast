import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '/models/database/local_database.dart';
import '/repositories/weather_data_repository.dart';

part 'details_event.dart';
part 'details_state.dart';

enum LoadErrorCase {
  noDataAvailable,
  errorFetchingFromStorage,
}

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final WeatherDataRepository repository;

  DetailsBloc(
    this.repository,
  ) : super(DetailsInitial()) {
    on<DetailsEvent>(_onDetailsEvent);
  }

  Future<void> _onDetailsEvent(
      DetailsEvent event, Emitter<DetailsState> emit) async {
    if (event is LoadWeatherHoursEvent) {
      emit(LoadingWeatherHoursState());

      var weatherHours = <WeatherHour>[];
      try {
        final selectedWeatherDayDateTime = DateTime.fromMillisecondsSinceEpoch(
            repository.selectedWeatherDay!.timestamp * 1000);
        final dayStartTime = DateTime(
                    selectedWeatherDayDateTime.year,
                    selectedWeatherDayDateTime.month,
                    selectedWeatherDayDateTime.day)
                .millisecondsSinceEpoch ~/
            1000;
        final dayEndTime = DateTime(
                    selectedWeatherDayDateTime.year,
                    selectedWeatherDayDateTime.month,
                    selectedWeatherDayDateTime.day)
                .add(const Duration(hours: 24))
                .millisecondsSinceEpoch ~/
            1000;

        weatherHours = await repository.getWeatherHoursFromCache(
            repository.selectedGeoLocation!, dayStartTime, dayEndTime);
        if (weatherHours.isEmpty) {
          emit(FailedToLoadWeatherHoursState(
              error: LoadErrorCase.noDataAvailable));
        } else {
          emit(LoadedWeatherHoursState(weatherHours: weatherHours));
        }
      } catch (error) {
        emit(FailedToLoadWeatherHoursState(
            error: LoadErrorCase.errorFetchingFromStorage));
      }
    }
  }
}
