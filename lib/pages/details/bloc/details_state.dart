part of 'details_bloc.dart';

@immutable
abstract class DetailsState {}

class DetailsInitial extends DetailsState {}

class LoadingWeatherHoursState extends DetailsState {}

class LoadedWeatherHoursState extends DetailsState {
  final List<WeatherHour> weatherHours;

  LoadedWeatherHoursState({required this.weatherHours});
}

class FailedToLoadWeatherHoursState extends DetailsState {}
