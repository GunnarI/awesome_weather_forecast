part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class SearchLocationEvent extends HomeEvent {}

class LoadWeatherDaysEvent extends HomeEvent {}

class NavigateToDetailsEvent extends HomeEvent {
  final WeatherDay weatherDay;

  NavigateToDetailsEvent({required this.weatherDay});
}

class RefreshEvent extends HomeEvent {
  final List<WeatherDay> weatherDays;

  RefreshEvent({required this.weatherDays});
}
