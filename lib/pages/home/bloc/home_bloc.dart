import 'package:awesome_weather_forecast/models/weather_day.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:awesome_weather_forecast/repositories/weather_data_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final WeatherDataRepository repository;

  HomeBloc(
    this.repository,
  ) : super(HomeInitial()) {
    on<HomeEvent>(_onHomeEvent);
  }

  Future<void> _onHomeEvent(HomeEvent event, Emitter<HomeState> emit) async {
      if (event is SearchLocationEvent) {
        // TODO: Handle search location event
      } else if (event is LoadWeatherDays) {
        emit(LoadingWeatherDaysState());
        // TODO: Try to fetch from local storage if less than 12 hours since refresh otherwise fetch from API
        try {
          final weatherDays = await repository.getWeatherDays(0.0, 0.0); // TODO: Use actual location data
          emit(LoadedWeatherDaysState(weatherDays: weatherDays));
        } catch (error) {
          // TODO: Display different relevant errors based on the error message
          emit(FailedToLoadWeatherDaysState(error: 'Oops! Something went wrong... try again later.'));
        }
      } else if (event is RefreshWeatherDays) {
        // TODO: Fetch days from API
      }
  }
}
