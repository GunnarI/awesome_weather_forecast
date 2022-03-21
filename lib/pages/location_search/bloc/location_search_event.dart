part of 'location_search_bloc.dart';

@immutable
abstract class LocationSearchEvent {}

class LocationSelectedEvent extends LocationSearchEvent {
  final GeoLocation selectedLocation;

  LocationSelectedEvent({
    required this.selectedLocation,
  });
}
