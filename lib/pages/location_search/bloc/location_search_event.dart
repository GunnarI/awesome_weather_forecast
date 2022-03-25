part of 'location_search_bloc.dart';

@immutable
abstract class LocationSearchEvent {}

class OptionsLoadingEvent extends LocationSearchEvent {
  final List<GeoLocation> locationOptions;
  
  OptionsLoadingEvent({
    required this.locationOptions,
  });
}

class LocationSelectedEvent extends LocationSearchEvent {
  final GeoLocation selectedLocation;

  LocationSelectedEvent({
    required this.selectedLocation,
  });
}
