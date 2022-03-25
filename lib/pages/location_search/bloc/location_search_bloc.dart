import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '/repositories/weather_data_repository.dart';

import '/models/database/local_database.dart';

part 'location_search_event.dart';
part 'location_search_state.dart';

class LocationSearchBloc
    extends Bloc<LocationSearchEvent, LocationSearchState> {
  final WeatherDataRepository repository;

  LocationSearchBloc(
    this.repository,
  ) : super(LocationSearchInitial()) {
    on<LocationSearchEvent>(_onLocationSearchEvent);
  }

  Future<void> _onLocationSearchEvent(
      LocationSearchEvent event, Emitter<LocationSearchState> emit) async {
    if (event is LocationSelectedEvent) {
      try {
        var geoLocation =
            await repository.cacheGeoLocationData(event.selectedLocation);
        emit(
          LocationSelectedState(
            selectedLocation: geoLocation,
          ),
        );
      } catch (error) {
        emit(ErrorSelectingLocation());
      }
    }
  }
}
