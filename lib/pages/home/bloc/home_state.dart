part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class LoadingWeatherDaysState extends HomeState {}

class LoadedWeatherDaysState extends HomeState {
  final List<WeatherDay> weatherDays;

  LoadedWeatherDaysState({
    required this.weatherDays,
  });
}

class FailedToLoadWeatherDaysState extends HomeState {
  final String error;

  FailedToLoadWeatherDaysState({
    required this.error,
  });
}
