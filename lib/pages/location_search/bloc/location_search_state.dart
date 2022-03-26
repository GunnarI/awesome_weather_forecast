part of 'location_search_bloc.dart';

@immutable
abstract class LocationSearchState {}

class LocationSearchInitial extends LocationSearchState {}

class LocationSelectedState extends LocationSearchState {}

class ErrorSelectingLocation extends LocationSearchState {}
