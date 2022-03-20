part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class SearchLocationEvent extends HomeEvent {}

class LoadWeatherDays extends HomeEvent {}

class RefreshWeatherDays extends HomeEvent {}
