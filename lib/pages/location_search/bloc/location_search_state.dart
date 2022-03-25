part of 'location_search_bloc.dart';

@immutable
abstract class LocationSearchState {}

class LocationSearchInitial extends LocationSearchState {}

class LocationSelectedState extends LocationSearchState {
  final GeoLocation selectedLocation;

  LocationSelectedState({
    required this.selectedLocation,
  });
}

class ErrorSelectingLocation extends LocationSearchState {}
